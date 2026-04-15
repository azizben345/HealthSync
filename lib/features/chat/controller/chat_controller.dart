import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:drift/drift.dart' as drift; // required for database inserts
import 'package:healthsync_demo_v01_00/features/chat/model/chat_message.dart';
// import '../../model/chat_message.dart';
import '../../../data/services/ai_service.dart';
import '../../../data/database/app_database.dart';

class ChatController extends ChangeNotifier {
  final AIService _aiService;
  final AppDatabase _db;

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  ChatController(this._aiService, this._db);

  // 1. Initialize Chat & Load History
  Future<void> initializeChat() async {
    if (_isInitialized) return;
    
    _isLoading = true;
    notifyListeners();

    // --- A. PULL HEALTH CONTEXT ---
    final records = await _db.getAllRecords();
    final recentRecords = records.reversed.take(7).toList();
    String contextString = "";
    for (var r in recentRecords) {
      contextString += "Date: ${r.date.day}/${r.date.month}, Steps: ${r.steps}, Sleep: ${r.sleepHours}h, Diet: ${r.dietQuality}, Workout: ${r.workoutType}, Mood Note: ${r.diaryNote}\n";
    }

    // --- B. LOAD SAVED CHAT MESSAGES FROM DRIFT ---
    final savedMessages = await _db.getAllChatMessages();
    
    // Convert Drift database rows back into our UI ChatMessage objects
    _messages = savedMessages.map((m) => ChatMessage(
      text: m.textMessage,
      isUser: m.isUser,
      timestamp: m.timestamp,
    )).toList();

    // --- START AI SESSION ---
    // currently just relying on the AI reading the 'contextString' 
    // to remember who you are, rather than sending the entire chat history back to the cloud
    await dotenv.load(fileName: ".env");
    final apiKey = dotenv.env['GEMINI_API_KEY']!;
    await _aiService.startNewChatSession(contextString, apiKey);

    // --- D. GREETING FALLBACK ---
    // if the database is completely empty (first time open), say hello
    if (_messages.isEmpty) {
      final greetingText = "Hi there! I've reviewed your recent logs. How can I help you today?";
      
      // Add to UI
      _messages.add(ChatMessage(text: greetingText, isUser: false));
      
      // Save to Drift Database
      await _db.insertChatMessage(
        ChatHistoryCompanion.insert(
          textMessage: greetingText, 
          isUser: false,
        )
      );
    }

    _isInitialized = true;
    _isLoading = false;
    notifyListeners();
  }

  // 2. Send Message and Save to Database
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // --- A. HANDLE USER MESSAGE ---
    _messages.add(ChatMessage(text: text, isUser: true));
    
    // Save User message to Drift
    await _db.insertChatMessage(
      ChatHistoryCompanion.insert(textMessage: text, isUser: true)
    );
    
    _isLoading = true;
    notifyListeners();

    // --- B. GET AI RESPONSE ---
    final responseText = await _aiService.sendChatMessage(text);

    // --- C. HANDLE AI MESSAGE ---
    _messages.add(ChatMessage(text: responseText, isUser: false));
    
    // Save AI message to Drift
    await _db.insertChatMessage(
      ChatHistoryCompanion.insert(textMessage: responseText, isUser: false)
    );

    _isLoading = false;
    notifyListeners();
  }

  // Clear History Function
  Future<void> clearHistory() async {
    _isLoading = true;
    notifyListeners();

    await _db.clearChatHistory(); // Delete all rows from Drift
    _messages.clear();            // Clear the UI
    _isInitialized = false;       // Force the controller to reboot
    
    await initializeChat();       // Restart the chat to get the greeting back
  }
}