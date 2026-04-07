import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/database/app_database.dart';

class HistoryController extends ChangeNotifier {
  final AppDatabase _db;
  List<DailyRecord> _records = [];

  // Public getter for the UI to read
  List<DailyRecord> get records => _records;

  HistoryController(this._db) {
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
      ),
      DailyRecordsCompanion.insert(
        date: drift.Value(DateTime.now().subtract(const Duration(days: 2))),
        steps: 12000, sleepHours: 8.0, diaryNote: "Great workout!", avatarState: "proud",
      ),
      DailyRecordsCompanion.insert(
        date: drift.Value(DateTime.now().subtract(const Duration(days: 3))),
        steps: 8000, sleepHours: 7.0, diaryNote: "Normal day.", avatarState: "happy",
      ),
    ];

    for (var entry in mockEntries) {
      await _db.insertRecord(entry);
    }
    await loadRecords(); // Refresh to show the new fake data
  }
}