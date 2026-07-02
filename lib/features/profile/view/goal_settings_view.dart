import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/database/app_database.dart'; // Point to your DB!

class GoalSettingsView extends StatefulWidget {
  const GoalSettingsView({super.key});

  @override
  State<GoalSettingsView> createState() => _GoalSettingsViewState();
}

class _GoalSettingsViewState extends State<GoalSettingsView> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers to hold the text
  final _stepsCtrl = TextEditingController();
  final _sleepCtrl = TextEditingController();
  final _workoutCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  final _moodCtrl = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentGoals();
  }

  // Fetch the current goals when the screen opens
  Future<void> _loadCurrentGoals() async {
    final db = context.read<AppDatabase>();
    final goal = await db.getUserGoal();
    
    setState(() {
      _stepsCtrl.text = goal.targetSteps.toString();
      _sleepCtrl.text = goal.targetSleep.toString();
      _workoutCtrl.text = goal.targetWorkoutMinutesWeekly.toString();
      _calCtrl.text = goal.targetDailyCalories.toString();
      _moodCtrl.text = goal.targetAvgMood.toString();
      _isLoading = false;
    });
  }

  // Save them back to the DB
  // A quick helper to show the exact error message
  void _showError(String fieldName, String badValue) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error in $fieldName! The app read: '$badValue'"), 
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4), // Keep it on screen longer so you can read it
        )
      );
    }
  }

  // Save them back to the DB with Tripwires!
  Future<void> _saveGoals() async {
    if (!_formKey.currentState!.validate()) return;
    
    // We will declare the variables here, and try to fill them one by one
    int steps;
    double sleep;
    int workoutMins;
    int calories;
    double mood;

    // --- THE TRIPWIRES ---
    // If one of these fails, it immediately shows the error and stops the function.
    
    // 1. Check Steps
    try { 
      // Pro-tip: .replaceAll(',', '') safely removes commas before parsing!
      steps = double.parse(_stepsCtrl.text.trim().replaceAll(',', '')).toInt(); 
    } catch (e) { 
      return _showError("Steps", _stepsCtrl.text); 
    }

    // 2. Check Sleep
    try { 
      sleep = double.parse(_sleepCtrl.text.trim().replaceAll(',', '')); 
    } catch (e) { 
      return _showError("Sleep", _sleepCtrl.text); 
    }

    // 3. Check Workouts
    try { 
      workoutMins = double.parse(_workoutCtrl.text.trim().replaceAll(',', '')).toInt(); 
    } catch (e) { 
      return _showError("Workouts", _workoutCtrl.text); 
    }

    // 4. Check Calories
    try { 
      calories = double.parse(_calCtrl.text.trim().replaceAll(',', '')).toInt(); 
    } catch (e) { 
      return _showError("Calories", _calCtrl.text); 
    }

    // 5. Check Mood
    try { 
      mood = double.parse(_moodCtrl.text.trim().replaceAll(',', '')); 
    } catch (e) { 
      return _showError("Mood", _moodCtrl.text); 
    }

    // --- IF WE SURVIVE THE TRIPWIRES, SAVE TO DB ---
    try {
      final db = context.read<AppDatabase>();
      await db.updateUserGoal(
        steps: steps,
        sleep: sleep,
        workoutMins: workoutMins,
        calories: calories,
        mood: mood,
      );
    } catch (e) {
      // IF THE DATABASE CRASHES, SHOW THE ERROR!
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Database Error: $e"), 
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          )
        );
      }
      return; // Stop the function so we don't show the success message!
    }

    // --- SUCCESS ---
    if (mounted) {
      FocusScope.of(context).unfocus(); // Hide keyboard
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Goals successfully updated!"), backgroundColor: Colors.green)
      );
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text("My Health Goals")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const Text("Set your baseline targets so your AI Coach can track your progress.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            
            _buildSectionHeader(Icons.directions_walk, "Fitness & Exercise Preferences"),
            _buildTextField(_stepsCtrl, "Daily Steps", "e.g., 8000"),
            _buildTextField(_sleepCtrl, "Target Sleep (Hours)", "e.g., 7.5"),
            _buildTextField(_workoutCtrl, "Weekly Workout Duration (Mins)", "e.g., 150"),
            
            const SizedBox(height: 24),
            _buildSectionHeader(Icons.restaurant, "Nutrition Goal"),
            _buildTextField(_calCtrl, "Daily Calorie Limit", "e.g., 2200"),
            
            const SizedBox(height: 24),
            _buildSectionHeader(Icons.psychology, "Mental Well-being"),
            _buildTextField(_moodCtrl, "Target Average Mood (1-10)", "e.g., 6.5"),
            
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _saveGoals,
                child: const Text("Save Goals", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Quick UI Helper for the Headers
  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Quick UI Helper for the Text Fields
  Widget _buildTextField(TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }
}