import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  final GenerativeModel _model;

  AIService(String apiKey) : _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
    // We force the AI to return JSON so our code can read it easily
    generationConfig: GenerationConfig(responseMimeType: 'application/json'),
  );

  Future<Map<String, dynamic>> getAvatarResponse(int steps, double sleep, String diary) async {
    final prompt = """
      Context: A user's fitness and mood tracker.
      Data: { "steps": $steps, "sleep_hours": $sleep, "diary": "$diary" }
      
      Task: Determine the avatar's state and a coach's message.
      States: 'happy', 'tired', 'gloomy', 'proud'.
      
      Return ONLY this JSON format:
      { "state": "string", "message": "string" }
    """;

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      // The .text will contain the JSON string
      return _parseJsonResponse(response.text ?? "{}");
    } catch (e) {
      return {"state": "neutral", "message": "I'm having trouble thinking today..."};
    }
  }

  Map<String, dynamic> _parseJsonResponse(String rawJson) {
    // Basic manual parsing for now, or use 'dart:convert'
    // For your demo, we'll keep it simple
    return {"state": "happy", "message": "Great job on your steps!"};
  }
}