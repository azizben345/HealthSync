import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import '../../../data/services/ai_service.dart';
import '../../../data/database/app_database.dart';
// import 'package:drift/drift.dart' as drift;

class AvatarController extends ChangeNotifier {
  final AIService _aiService;
  final AppDatabase _db;

  // Internal State
  String _avatarState = 'neutral'; // default state
  String _coachMessage = 'How was your day?'; // default response before daily sync
  bool _isLoading = false;

  // Public Getters (So the UI can read these but not change them directly)
  String get avatarState => _avatarState;
  String get coachMessage => _coachMessage;
  bool get isLoading => _isLoading;

  AvatarController(this._aiService, this._db);

  /// main function - handle logic
  Future<void> updateAvatarLogic({
    required int steps,
    required double sleep,
    required String diary,
    required String diet,     
    required String workout,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. call Gemini service and send data via arguments
      final result = await _aiService.getAvatarResponse(steps, sleep, diary, diet, workout);
      
      _avatarState = result['state'] ?? 'neutral';
      _coachMessage = result['message'] ?? 'Keep going!';

    } catch (e) {
      // 2. THE DEMO-SAVER FALLBACK
      print("API Error: $e"); // terminal debugging
      _avatarState = 'pending'; // state of "AI didn't answer"
      _coachMessage = "The AI servers are currently resting. Your data is saved safely in your history.";
      
    } finally {
      // 3. SAVE DATA
      await _db.insertRecord(
        DailyRecordsCompanion.insert(
          steps: steps,
          sleepHours: sleep,
          diaryNote: diary,
          avatarState: _avatarState, // 'happy', 'tired', or 'pending'
          dietQuality: drift.Value(diet),       
          workoutType: drift.Value(workout),
        ),
      );

      _isLoading = false;
      notifyListeners();
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