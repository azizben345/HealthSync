import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:healthsync_demo_v01_00/app.dart';
import 'package:healthsync_demo_v01_00/features/chat/controller/chat_controller.dart';
import 'data/services/ai_service.dart';
import 'features/avatar/controller/avatar_controller.dart';
import 'package:provider/provider.dart'; // use Provider for state
import 'data/database/app_database.dart';
import 'package:healthsync_demo_v01_00/features/history/controller/history_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'features/auth/view/auth_view.dart';
import 'features/home/view/main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Firebase before app starts
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load API key from .env
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['GEMINI_API_KEY']!;

  final aiService = AIService(apiKey);
  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) 
          => AvatarController(aiService, database)),
        Provider<AppDatabase>(create: (_) => database),
        ChangeNotifierProvider(create: (context) 
          => HistoryController(context.read<AppDatabase>(), aiService)),
        ChangeNotifierProvider(create: (context) 
          => ChatController(aiService, context.read<AppDatabase>())),
      ],
      child: const HealthSyncApp(),
    ),
  );
}

class HealthSyncApp extends StatelessWidget {
  const HealthSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthSync',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      // 2. The Gatekeeper StreamBuilder
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If we are still waiting to hear from Firebase, show a loader
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          
          // If a user is found, show the main app!
          if (snapshot.hasData) {
            return const MainNavigation();
          }
          
          // Otherwise, force them to login/register
          return const AuthView();
        },
      ),
    );
  }
}