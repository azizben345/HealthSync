import 'package:flutter/material.dart';
import '../../../data/services/ai_service.dart';
// for mock data function
import 'package:drift/drift.dart';
import '../../../data/database/app_database.dart';

class AvatarController extends ChangeNotifier {
  final AIService _aiService;

  // Internal State
  String _avatarState = 'neutral'; // Default state
  String _coachMessage = 'Ready to start your day?';
  bool _isLoading = false;

  // Public Getters (So the UI can read these but not change them directly)
  String get avatarState => _avatarState;
  String get coachMessage => _coachMessage;
  bool get isLoading => _isLoading;

  AvatarController(this._aiService);

  /// main function - handle logic
  Future<void> updateAvatarLogic({
    required int steps,
    required double sleep,
    required String diary,
  }) async {
    _isLoading = true;
    notifyListeners(); // Tell the UI to show a loading spinner

    try {
      // 1. Call the Gemini Service
      final result = await _aiService.getAvatarResponse(steps, sleep, diary);

      // 2. Update the local state based on AI JSON
      _avatarState = result['state'] ?? 'neutral';
      _coachMessage = result['message'] ?? 'Keep going!';

    } catch (e) {
      _coachMessage = "Error connecting to Gemini. Check your internet!";
      _avatarState = 'gloomy'; 
    } finally {
      _isLoading = false;
      notifyListeners(); // Tell the UI to show the new data
    }
  }

  // // to generate mock data (can link to button)
  // Future<void> generateMockData(AppDatabase db) async {
  //   // Creating 3 days of fake history
  //   final mockEntries = [
  //     DailyRecordsCompanion.insert(
  //       date: Value(DateTime.now().subtract(const Duration(days: 1))),
  //       steps: 3000, sleepHours: 4.5, diaryNote: "Rough night and day.", avatarState: "tired",
  //     ),
  //     DailyRecordsCompanion.insert(
  //       date: Value(DateTime.now().subtract(const Duration(days: 2))),
  //       steps: 12000, sleepHours: 8.0, diaryNote: "Great workout!", avatarState: "proud",
  //     ),
  //     DailyRecordsCompanion.insert(
  //       date: Value(DateTime.now().subtract(const Duration(days: 3))),
  //       steps: 8000, sleepHours: 7.0, diaryNote: "Normal day.", avatarState: "happy",
  //     ),
  //   ];

  //   for (var entry in mockEntries) {
  //     await db.insertRecord(entry);
  //   }
  //   print("Mock data injected!");
  // }
}