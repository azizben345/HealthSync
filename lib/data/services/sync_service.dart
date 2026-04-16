import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../database/app_database.dart';
import 'package:drift/drift.dart' as drift; // for parsing dates

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AppDatabase _db;

  SyncService(this._db);

  // 1. BACKUP: Push SQLite to Firestore
  Future<void> backupToCloud() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User is not logged in!");

    // Grab all local records
    final records = await _db.getAllRecords();
    
    // Convert the complex Drift objects into simple JSON Maps
    final List<Map<String, dynamic>> jsonData = records.map((r) => {
      'id': r.id,
      'date': r.date.toIso8601String(),
      'steps': r.steps,
      'sleepHours': r.sleepHours,
      'diaryNote': r.diaryNote,
      'avatarState': r.avatarState,
      'dietQuality': r.dietQuality,
      'workoutType': r.workoutType,
    }).toList();

    // Save to Firestore inside a document named after their secure UID
    await _firestore.collection('users').doc(user.uid).set({
      'lastBackup': FieldValue.serverTimestamp(),
      'daily_records': jsonData,
    }, SetOptions(merge: true)); // Merge prevents deleting other user info we might add later
  }

  // 2. RESTORE: Pull from Firestore to SQLite
  Future<void> restoreFromCloud() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User is not logged in!");

    // 1. Fetch the document from Firestore
    final doc = await _firestore.collection('users').doc(user.uid).get();
    
    if (!doc.exists || doc.data() == null || !doc.data()!.containsKey('daily_records')) {
      throw Exception("No backup found in the cloud.");
    }

    final List<dynamic> cloudRecords = doc.data()!['daily_records'];
    
    // 2. Wipe the local database completely
    await _db.clearAllDailyRecords();

    // 3. Loop through the cloud data and insert it back into SQLite
    for (var r in cloudRecords) {
      await _db.insertRecord(
        DailyRecordsCompanion.insert(
          date: drift.Value(DateTime.parse(r['date'])), // Convert String back to DateTime
          steps: r['steps'],
          sleepHours: r['sleepHours'],
          diaryNote: r['diaryNote'],
          avatarState: r['avatarState'],
          // Using drift.Value() for default columns, with a fallback just in case
          dietQuality: drift.Value(r['dietQuality'] ?? 'Normal'), 
          workoutType: drift.Value(r['workoutType'] ?? 'Rest'),
        )
      );
    }
  }
}