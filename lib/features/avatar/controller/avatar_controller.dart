import 'package:flutter/material.dart';
import '../../../data/services/ai_service.dart';

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

  /// This is the main function that handles the logic
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
}