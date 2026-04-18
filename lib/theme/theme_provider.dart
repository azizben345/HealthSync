import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // start with system default, but allow manual override (in RAM)
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    // but when provider boots up, check preference setting on the hard drive
    _loadThemeFromDisk();
  }

  ThemeMode get themeMode => _themeMode;

  // Helper boolean for UI toggle switch
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // If we're on system, system check what the device currently using
      final window = WidgetsBinding.instance.platformDispatcher;
      return window.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  void toggleTheme(bool isDark) async {
    // 1. Update RAM and redraw UI instantly
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); 

    // 2. Save the choice to the physical hard drive
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  Future<void> _loadThemeFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check if the user has ever manually flipped the switch before
    if (prefs.containsKey('isDarkMode')) {
      final isDark = prefs.getBool('isDarkMode') ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners(); // Tell the app to redraw with the saved preference
    }
  }

}