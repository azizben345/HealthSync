import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
import 'features/profile/controller/goal_provider.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Firebase before app starts
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load API key from .env
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['GEMINI_API_KEY']!;

  final aiService = AIService(apiKey);
  final database = AppDatabase();

  runApp(
    MultiProvider(
      // controller-view link
      providers: [
        Provider<AppDatabase>(create: (_) => database),
        ChangeNotifierProvider(
          create: (_) => AvatarController(aiService, database),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              HistoryController(context.read<AppDatabase>(), aiService),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ChatController(aiService, context.read<AppDatabase>()),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GoalProvider()
        ),
      ],
      child: const HealthSyncApp(),
    ),
  );
}

class HealthSyncApp extends StatelessWidget {
  const HealthSyncApp({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'HealthSync',

      // // centralized theme
      // theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system,
      themeMode: themeProvider.themeMode,

      // Gatekeeper StreamBuilder
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If we are still waiting to hear from Firebase, show a loader
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // If a user is found, show the main app
          if (snapshot.hasData) {
            return const MainNavigation();
          }

          // If we already know who the user is, don't destroy the navigation bar!
          if (snapshot.hasData) {
            return const MainNavigation(); // (Make sure this has the 'const' keyword if possible)
          }

          // Only show the loading screen if we genuinely have no data yet
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          // Otherwise, force them to login/register
          return const AuthView();
        },
      ),
    );
  }
}
