import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../../data/database/app_database.dart'; 

class DailyProgressRings extends StatelessWidget {
  final double currentSteps;
  final double currentSleep;
  final DateTime selectedDate;

  const DailyProgressRings({
    super.key,
    required this.currentSteps,
    required this.currentSleep,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    // We use a FutureBuilder to fetch the user's baseline goals from SQLite
    return FutureBuilder<UserGoal>(
      future: db.getUserGoal(),
      builder: (context, goalSnapshot) {
        if (!goalSnapshot.hasData) return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
        
        final goals = goalSnapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 1. STEPS RING (Reacts instantly to the _steps variable)
              _buildRing(
                title: "Steps",
                current: currentSteps,
                target: goals.targetSteps.toDouble(),
                color: Colors.green,
                icon: Icons.directions_walk,
              ),
              
              // 2. SLEEP RING (Reacts instantly to the _sleep variable)
              _buildRing(
                title: "Sleep",
                current: currentSleep,
                target: goals.targetSleep,
                color: Colors.indigo,
                icon: Icons.bedtime,
              ),
              
              // 3. CALORIES RING (Listens to the SQLite Stream for logged meals!)
              StreamBuilder<List<Meal>>(
                stream: db.watchMealsForDate(selectedDate),
                builder: (context, mealSnapshot) {
                  final meals = mealSnapshot.data ?? [];
                  
                  // Calculate total calories from all meals today
                  double totalCalories = 0;
                  for (var m in meals) {
                    totalCalories += (m.calories ?? 0);
                  }

                  return _buildRing(
                    title: "Calories",
                    current: totalCalories,
                    target: goals.targetDailyCalories.toDouble(),
                    color: Colors.orange,
                    icon: Icons.local_fire_department,
                  );
                }
              ),
            ],
          ),
        );
      }
    );
  }

  // A reusable helper to draw the individual rings cleanly
  Widget _buildRing({
    required String title,
    required double current,
    required double target,
    required Color color,
    required IconData icon,
  }) {
    // Math failsafe: Prevent division by zero and cap the ring at 100%
    double percent = target > 0 ? (current / target) : 0.0;
    if (percent > 1.0) percent = 1.0;
    if (percent < 0.0) percent = 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: 40.0,
          lineWidth: 8.0,
          animation: true,
          animateFromLastPercent: true, // This makes it slide smoothly when sliders move!
          percent: percent,
          center: Icon(icon, color: color, size: 28),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: color,
          backgroundColor: color.withOpacity(0.15),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(
          "${current.toInt()} / ${target.toInt()}", 
          style: const TextStyle(fontSize: 12, color: Colors.grey)
        ),
      ],
    );
  }
}