// sync_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../database/app_database.dart';
import 'package:drift/drift.dart' as drift;

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AppDatabase _db;

  SyncService(this._db);

  // ---------------------------------------------------------
  // 1. BACKUP: Push SQLite to Firestore
  // ---------------------------------------------------------
  Future<void> backupToCloud() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User is not logged in!");

    // A. SYNC GOALS
    final goals = await _db.getUserGoal();
    final goalsData = {
      'targetSteps': goals.targetSteps,
      'targetSleep': goals.targetSleep,
      'targetWorkoutMinutesWeekly': goals.targetWorkoutMinutesWeekly,
      'targetDailyCalories': goals.targetDailyCalories,
      'targetAvgMood': goals.targetAvgMood,
    };

    // B. SYNC DAILY RECORDS & RELATIONAL DATA
    final records = await _db.getAllLoggedRecords(); 
    List<Map<String, dynamic>> jsonData = [];

    for (var r in records) {
      // Fetch the child data for this specific day
      final dayMeals = await _db.getMealsForRecord(r.id);
      final dayWorkouts = await _db.getWorkoutsForRecord(r.id);
      final dayMood = await _db.getMoodForRecord(r.id);

      // Build the nested JSON object
      jsonData.add({
        'date': r.date.toIso8601String(),
        'steps': r.steps,
        'sleepHours': r.sleepHours,
        'diaryNote': r.diaryNote,
        'avatarState': r.avatarState,
        'coachMessage': r.coachMessage,
        'dietQuality': r.dietQuality,
        'workoutType': r.workoutType,
        'moodScore': dayMood?.moodScore, // Flattened 1-10 score
        
        // Map SQLite lists directly into Firebase JSON Arrays
        'meals': dayMeals.map((m) => {
          'name': m.mealName,
          'type': m.mealType,
          'calories': m.calories,
        }).toList(),
        
        'workouts': dayWorkouts.map((w) => {
          'name': w.activityName,
          'duration': w.durationMinutes,
          'calories': w.caloriesBurned,
        }).toList(),
      });
    }

    // C. PUSH TO FIRESTORE
    await _firestore.collection('users').doc(user.uid).set({
      'lastBackup': FieldValue.serverTimestamp(),
      'user_goals': goalsData,
      'daily_records': jsonData,
    }, SetOptions(merge: true)); 
  }

  // ---------------------------------------------------------
  // 2. RESTORE: Pull from Firestore to SQLite
  // ---------------------------------------------------------
  Future<void> restoreFromCloud() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User is not logged in!");

    final doc = await _firestore.collection('users').doc(user.uid).get();
    
    if (!doc.exists || doc.data() == null) {
      throw Exception("No backup found in the cloud.");
    }

    final data = doc.data()!;
    
    // A. RESTORE GOALS
    if (data.containsKey('user_goals')) {
      final g = data['user_goals'];
      await _db.updateUserGoal(
        steps: g['targetSteps'] ?? 8000,
        sleep: (g['targetSleep'] ?? 7.5).toDouble(),
        workoutMins: g['targetWorkoutMinutesWeekly'] ?? 150,
        calories: g['targetDailyCalories'] ?? 2200,
        mood: (g['targetAvgMood'] ?? 6.0).toDouble(),
      );
    }

    // B. RESTORE DAILY RECORDS
    if (data.containsKey('daily_records')) {
      final List<dynamic> cloudRecords = data['daily_records'];
      
      // 1. Wipe the local database completely
      await _db.clearAllDailyRecords(); 

      // 2. Loop through cloud data and rebuild SQLite
      for (var r in cloudRecords) {
        final dateObj = DateTime.parse(r['date']);
        
        // Insert parent record AND get its new auto-incremented SQLite ID back
        final newRecordId = await _db.into(_db.dailyRecords).insert(
          DailyRecordsCompanion.insert(
            date: drift.Value(dateObj), 
            steps: r['steps'],
            sleepHours: r['sleepHours'],
            diaryNote: r['diaryNote'], // changed from drift.Value(...
            avatarState: r['avatarState'],
            coachMessage: drift.Value(r['coachMessage']),
            dietQuality: drift.Value(r['dietQuality'] ?? 'Normal'), 
            workoutType: drift.Value(r['workoutType'] ?? 'Rest'),
          )
        );

        // Restore Mood
        if (r['moodScore'] != null) {
          await _db.saveMoodDetail(dateObj, (r['moodScore'] as num).toDouble());
        }

        // Restore Meals array
        if (r['meals'] != null) {
          for (var m in r['meals']) {
            await _db.addDetailedMeal(dateObj, m['name'], m['type'], m['calories']);
          }
        }

        // Restore Workouts array
        if (r['workouts'] != null) {
          for (var w in r['workouts']) {
            await _db.addDetailedWorkout(dateObj, w['name'], w['duration'], w['calories']);
          }
        }
      }
    }
  }

// --- ADMIN MODERATION: PUSH FLAGGED MESSAGE ---
  Future<void> reportFlaggedMessageToCloud(int recordId, String badMessage) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Pushes to a dedicated 'flagged_ai_responses' collection for the Admin
      await _firestore.collection('flagged_ai_responses').add({
        'userId': user.uid,
        'recordId': recordId,
        'flaggedMessage': badMessage,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'Pending Review',
      });
      print("Bad AI response successfully reported to Admin console.");
    } catch (e) {
      print("Failed to report flagged message: $e");
    }
  }

}