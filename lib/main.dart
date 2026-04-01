import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:healthsync_demo_v01_00/app.dart';
import 'data/services/ai_service.dart';
import 'features/avatar/controller/avatar_controller.dart';
import 'package:provider/provider.dart'; // use Provider for state

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load the API key from your .env file
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['GEMINI_API_KEY']!;

  // Create the service
  final aiService = AIService(apiKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AvatarController(aiService)),
      ],
      child: const MyApp(),
    ),
  );
}