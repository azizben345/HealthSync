import 'package:flutter/material.dart';
import 'features/tracker/view/input_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FYP Avatar Tracker',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const InputView(), // Start with our demo screen
    );
  }
}