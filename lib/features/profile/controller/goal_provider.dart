import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalProvider extends ChangeNotifier {
  // Default goals if user hasn't set any yet
  int _stepGoal = 10000;
  double _sleepGoal = 8.0;

  int get stepGoal => _stepGoal;
  double get sleepGoal => _sleepGoal;

  GoalProvider() {
    _loadGoalsFromDisk();
  }

  Future<void> _loadGoalsFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    _stepGoal = prefs.getInt('stepGoal') ?? 10000;
    _sleepGoal = prefs.getDouble('sleepGoal') ?? 8.0;
    notifyListeners();
  }

  Future<void> updateStepGoal(int newGoal) async {
    _stepGoal = newGoal;
    notifyListeners(); // Updates UI instantly
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stepGoal', newGoal); // Saves to physical drive
  }

  Future<void> updateSleepGoal(double newGoal) async {
    _sleepGoal = newGoal;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sleepGoal', newGoal);
  }
}