import 'package:dart_openai/dart_openai.dart';

class OpenAIService {
  // Initialize with your key from .env (usually done in main.dart)
  static void init(String apiKey) {
    OpenAI.apiKey = apiKey;
  }

  Future<Map<String, String>> getAvatarReflection(int steps, double sleep, String note) async {
    final systemPrompt = """
      You are an AI character engine for a fitness app. 
      Analyze the user's data and return ONLY a JSON object.
      Rules:
      1. 'state' must be one of: 'energetic', 'tired', 'gloomy', 'proud'.
      2. 'message' must be a supportive 1-sentence coach tip.
      Format: {"state": "string", "message": "string"}
    """;

    final response = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.system,
          content: systemPrompt,
        ),
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: "Steps: $steps, Sleep: $sleep hrs, Note: $note",
        ),
      ],
      responseFormat: {"type": "json_object"},
    );

    // This is where you'd parse the JSON string from the response
    // For now, let's assume it returns the mapped values correctly
    return {
      "state": "energetic", 
      "message": "You're crushing it! Keep that momentum going."
    };
  }
}