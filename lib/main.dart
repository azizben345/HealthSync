import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:healthsync_demo_v01_00/app.dart';
import 'data/services/ai_service.dart';
import 'features/avatar/controller/avatar_controller.dart';
import 'package:provider/provider.dart'; // use Provider for state
import 'data/database/app_database.dart';
import 'package:healthsync_demo_v01_00/features/history/controller/history_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load API key from .env
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['GEMINI_API_KEY']!;

  final aiService = AIService(apiKey);
  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AvatarController(aiService, database)),
        Provider<AppDatabase>(create: (_) => database),
        ChangeNotifierProvider(create: (context) => HistoryController(context.read<AppDatabase>(), aiService)),
      ],
      child: const MyApp(),
    ),
  );
}
