import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart' as drift; 

class AIService {
  final GenerativeModel _model;

  AIService(String apiKey) : _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: apiKey,
    generationConfig: GenerationConfig(responseMimeType: 'application/json'),
  );

  Future<Map<String, dynamic>> getAvatarResponse(
    int steps, 
    double sleep, 
    String diary, 
    String diet, 
    String workout
  ) async {
    final prompt = """
      You are an AI character engine. 
      Analyze the user's data and return creative message. 
      Only relate data to note if relevant.
      Return ONLY JSON.
      Data: Steps: $steps, Sleep: $sleep, Diet: "$diet", Workout: "$workout", Note: "$diary"
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
      return {"state": "pending", "message": "I'm offline, retry later..."};
    }
  }

  // NEW: A variable to hold the ongoing conversation memory
  late drift.ChatSession _chatSession; // Assuming you are using google_generative_ai

  // 1. Initialize the chat with the database history
  Future<void> startNewChatSession(String systemContext, String apiKey) async {
    // gemini-1.5-flash is the best model for fast, multi-turn chat
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      // We feed it the SQLite data as a hidden system instruction so it knows the user!
      systemInstruction: Content.system(
        "You are HealthSync, an empathetic AI health coach. "
        "Here is the user's recent health data: $systemContext\n"
        "Keep your answers concise, supportive, and reference their data when appropriate."
      ),
    );

    // This creates a blank chat history, ready for the user's first message
    _chatSession = model.startChat();
  }

  // 2. Send a single message to the existing session
  Future<String> sendChatMessage(String message) async {
    try {
      final response = await _chatSession.sendMessage(Content.text(message));
      return response.text ?? "I'm having trouble thinking right now.";
    } catch (e) {
      print("Chat API Error: $e");
      return "I seem to have lost my connection. Can we try again later?";
    }
  }
}