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

  Future<void> generateMockData() async {
    final mockEntries = [
      DailyRecordsCompanion.insert(
        date: drift.Value(DateTime.now().subtract(const Duration(days: 1))),
        steps: 3000, sleepHours: 4.5, diaryNote: "Rough night and day.", avatarState: "tired",
        dietQuality: const drift.Value("Normal"), 
        workoutType: const drift.Value("Cardio"), 
      ),
      DailyRecordsCompanion.insert(
        date: drift.Value(DateTime.now().subtract(const Duration(days: 2))),
        steps: 12000, sleepHours: 8.0, diaryNote: "Great workout!", avatarState: "proud",
        dietQuality: const drift.Value("Cheat Day"), 
        workoutType: const drift.Value("Strength"),
      ),
      DailyRecordsCompanion.insert(
        date: drift.Value(DateTime.now().subtract(const Duration(days: 3))),
        steps: 8000, sleepHours: 7.0, diaryNote: "Normal day.", avatarState: "happy",
        dietQuality: const drift.Value("Normal"), 
        workoutType: const drift.Value("Cardio"),
      ),
    ];

    for (var entry in mockEntries) {
      await _db.insertRecord(entry);
    }
    await loadRecords(); // refresh to update new mock data
  }

  // Retry Logic
  Future<void> retryPendingAI(DailyRecord record) async {
    // 1. Mark this specific card as loading and update UI
    _retryingIds.add(record.id);
    notifyListeners();

    try {
      // 2. Ask Gemini using the saved data from that day
      final result = await _aiService.getAvatarResponse(
        record.steps, 
        record.sleepHours, 
        record.diaryNote,
        record.dietQuality,
        record.workoutType,
        record.date
      );
      
      final newState = result['state'] ?? 'neutral';

      // 3. Update that specific row in the database with the new state
      await _db.updateRecord(
        DailyRecordsCompanion(
          id: drift.Value(record.id), // Must pass the ID so Drift knows WHICH row to update
          date: drift.Value(record.date),
          steps: drift.Value(record.steps),
          sleepHours: drift.Value(record.sleepHours),
          diaryNote: drift.Value(record.diaryNote),
          avatarState: drift.Value(newState), // The new AI result!
        ),
      );

    } catch (e) {
      print("Retry API Error: $e");
      // If it fails again, it just stays 'pending', no harm done.
    } finally {
      // 4. Remove loading state and refresh the list
      _retryingIds.remove(record.id);
      await loadRecords(); 
    }
  }

}