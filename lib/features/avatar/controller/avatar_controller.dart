// import 'package:drift/drift.dart' as drift;
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
    required DateTime? date,
    required double moodScore,
    required AppDatabase db,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. FETCH THE RELATIONAL DATA USING THE INJECTED _db
      final record = await _db.getRecordByDate(date ?? DateTime.now());
      
      List<dynamic> dayMeals = [];
      List<dynamic> dayWorkouts = [];
      
      if (record != null) {
        dayMeals = await _db.getMealsForRecord(record.id);
        dayWorkouts = await _db.getWorkoutsForRecord(record.id);
      }

      // BUILD THE CONTEXT STRING
      final contextBlock = _buildPromptContext(
        steps: steps,
        sleep: sleep,
        moodScore: moodScore,
        meals: dayMeals,
        workouts: dayWorkouts,
      );

      print("DEBUG CONTEXT BLOCK: \n$contextBlock");

      // CALL GEMINI SERVICE AND PASS CONTEXT
      final result = await _aiService.getAvatarResponse(
        steps, 
        sleep, 
        diary, 
        diet, 
        workout, 
        date,
        contextBlock: contextBlock, // <-- Injecting summary here
      );

      _avatarState = result['state'] ?? 'neutral';
      _coachMessage = result['message'] ?? 'Keep going!';

    } catch (e) {
      // 2. THE DEMO-SAVER FALLBACK
      print("API Error: $e"); // terminal debugging
      _avatarState = 'pending'; // state of "AI didn't answer"
      _coachMessage = "The AI servers are currently resting. Your data is saved safely in your history.";
      
    } finally {
      await _db.saveOrUpdateDailyLog(
        date: date ?? DateTime.now(),
        steps: steps,
        sleep: sleep,
        diet: diet,
        workout: workout,
        diary: diary,
        avatarState: _avatarState,
        coachMessage: _coachMessage
      );
      await _db.saveMoodDetail(date ?? DateTime.now(), moodScore);

      _isLoading = false;
      notifyListeners();
    }
  }

  // --- SUMMARIZER ---
  String _buildPromptContext({
    required int steps,
    required double sleep,
    required double moodScore,
    required List<dynamic> meals,     // Passed from AppDatabase
    required List<dynamic> workouts,  // Passed from AppDatabase
  }) {
    // Format the Workouts
    final workoutString = workouts.isEmpty 
        ? "No specific workouts logged." 
        : workouts.map((w) => "${w.activityName} (${w.durationMinutes} mins, ${w.caloriesBurned ?? 0} kcal)").join(", ");

    // Format the Meals
    final mealString = meals.isEmpty 
        ? "No specific meals logged." 
        : meals.map((m) => "${m.mealName} (${m.calories ?? 0} kcal)").join(", ");

    // Build the highly condensed Context Block
    return """
[USER'S ACTUAL DATA FOR TODAY]
- Steps: $steps
- Sleep: $sleep hours
- Mood: $moodScore / 10
- Workouts: $workoutString
- Meals: $mealString
[/USER'S ACTUAL DATA FOR TODAY]
""";
  }

  // resets the avatar to its default state for empty days
  void resetState() {
    _avatarState = 'idle'; // Or whatever your default animation string is
    _coachMessage = "Ready to sync?";
    _isLoading = false;
    notifyListeners();
  }
  Future<void> setHistoricalState(String state, String message) async {
    _avatarState = state;
    _coachMessage = message;
    notifyListeners();
  }

}