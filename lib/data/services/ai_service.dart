import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert'; 

class AIService {
  final GenerativeModel _model;

  AIService(String apiKey) : _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: apiKey,
    generationConfig: GenerationConfig(responseMimeType: 'application/json'),
  );

  Future<Map<String, dynamic>> getAvatarResponse(int steps, double sleep, String diary) async {
    final prompt = """
      You are an AI character engine. Analyze the user's data and return creative message. Return ONLY JSON.
      Data: Steps: $steps, Sleep: $sleep, Note: "$diary"
      Return format: {"state": "happy"|"tired"|"gloomy"|"proud", "message": "string"}
    """;

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      // Gemini might wrap JSON in ```json ... ``` blocks, so we clean it
      String cleanJson = response.text ?? "{}";
      cleanJson = cleanJson.replaceAll('```json', '').replaceAll('```', '').trim();

      return jsonDecode(cleanJson) as Map<String, dynamic>;
    } catch (e) {
      print("AI Error: $e");
      return {"state": "gloomy", "message": "I'm offline..."};
    }
  }
}