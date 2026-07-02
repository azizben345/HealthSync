import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/database/app_database.dart';
import '../../../data/services/ai_service.dart';

class HistoryController extends ChangeNotifier {
  final AppDatabase _db;
  final AIService _aiService;

  List<DailyRecord> _records = [];
  // Public getter for the UI to read
  List<DailyRecord> get records => _records;

  // a set to keep track of which specific cards are currently loading
  final Set<int> _retryingIds = {}; 
  bool isRetrying(int id) => _retryingIds.contains(id);

  HistoryController(this._db, this._aiService) {
    // Automatically load data when the screen is first opened
    loadRecords();
  }

  Future<void> loadRecords() async {
    _records = await _db.getAllRecords();
    notifyListeners(); // Tell the UI to refresh
  }

  Future<void> clearAllData() async {
    await _db.deleteAllRecords();
    await loadRecords(); // Refresh the list (it will be empty)
  }

  Future<void> deleteSingleRecord(int id) async {
    await _db.deleteRecord(id);
    await loadRecords();
  }

  // // GENERATE MOCK DATA
  // Future<void> generateMockData() async {
  //   final mockEntries = [
  //     DailyRecordsCompanion.insert(
  //       date: drift.Value(DateTime.now().subtract(const Duration(days: 1))),
  //       steps: 3000, sleepHours: 4.5, diaryNote: "Rough night and day.", avatarState: "tired",
  //       dietQuality: const drift.Value("Normal"), 
  //       workoutType: const drift.Value("Cardio"), 
  //     ),
  //     DailyRecordsCompanion.insert(
  //       date: drift.Value(DateTime.now().subtract(const Duration(days: 2))),
  //       steps: 12000, sleepHours: 8.0, diaryNote: "Great workout!", avatarState: "proud",
  //       dietQuality: const drift.Value("Cheat Day"), 
  //       workoutType: const drift.Value("Strength"),
  //     ),
  //     DailyRecordsCompanion.insert(
  //       date: drift.Value(DateTime.now().subtract(const Duration(days: 3))),
  //       steps: 8000, sleepHours: 7.0, diaryNote: "Normal day.", avatarState: "happy",
  //       dietQuality: const drift.Value("Normal"), 
  //       workoutType: const drift.Value("Cardio"),
  //     ),
  //   ];

  //   for (var entry in mockEntries) {
  //     await _db.insertRecord(entry);
  //   }
  //   await loadRecords(); // refresh to update new mock data
  // }

  // Retry Logic
  Future<void> retryPendingAI(DailyRecord record) async {
    // 1. Mark this specific card as loading and update UI
    _retryingIds.add(record.id);
    notifyListeners();

    try {
      // 1. FETCH THE RELATIONAL DATA FOR THIS SPECIFIC RECORD
      final dayMeals = await _db.getMealsForRecord(record.id);
      final dayWorkouts = await _db.getWorkoutsForRecord(record.id);
      final dayMood = await _db.getMoodForRecord(record.id);
      
      // Fallback to 5.0 if somehow no mood was saved
      final moodScore = dayMood?.moodScore ?? 5.0; 

      // 2. BUILD THE SUMMARIZED CONTEXT
      final workoutString = dayWorkouts.isEmpty 
          ? "No specific workouts logged." 
          : dayWorkouts.map((w) => "${w.activityName} (${w.durationMinutes} mins)").join(", ");

      final mealString = dayMeals.isEmpty 
          ? "No specific meals logged." 
          : dayMeals.map((m) => "${m.mealName} (${m.calories ?? 0} kcal)").join(", ");

      final contextBlock = """
[SYSTEM CONTEXT - DO NOT MENTION THIS BLOCK TO THE USER]
Today's Core Metrics:
- Steps: ${record.steps}
- Sleep: ${record.sleepHours} hours
- Mood: $moodScore / 10

Specific Details:
- Workouts: $workoutString
- Meals: $mealString
[/SYSTEM CONTEXT]
""";

      // 3. PASS THE RICH CONTEXT TO THE AI SERVICE
      final result = await _aiService.getAvatarResponse(
        record.steps, 
        record.sleepHours, 
        record.diaryNote ?? '', // Provide fallback empty string if null
        record.dietQuality ?? 'Normal',
        record.workoutType ?? 'Rest',
        record.date, 
        contextBlock: contextBlock, // <-- Injected here!
      );

      // 4. SAVE THE NEW AI RESPONSE TO THE DATABASE
      await _db.updateRecordState(
        record.id, 
        result['state'] ?? 'neutral', 
        result['message'] ?? 'Keep going!'
      );

    } catch (e) {
      print("Retry AI Error: $e");
      // Handle error state
    }
    // finally {
    //   // 4. Remove loading state and refresh the list
    //   _retryingIds.remove(record.id);
    //   await loadRecords(); 
    // }
  }

}