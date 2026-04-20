import 'package:flutter/material.dart';
import 'workout_modal.dart';
import 'package:provider/provider.dart'; 
import '../../../../data/database/app_database.dart';

class FitnessInputCard extends StatelessWidget {
  final double steps;
  final double sleep;
  final String workoutType;
  final bool isFetchingHealth;
  final Function(double) onStepsChanged;
  final Function(double) onSleepChanged;
  final Function(String) onWorkoutChanged;
  final VoidCallback onAutoFill;
  final VoidCallback onAddWorkout;
  final DateTime selectedDate; 

  const FitnessInputCard({
    super.key,
    required this.steps,
    required this.sleep,
    required this.workoutType,
    required this.isFetchingHealth,
    required this.onStepsChanged,
    required this.onSleepChanged,
    required this.onWorkoutChanged,
    required this.onAutoFill,
    required this.onAddWorkout,
    required this.selectedDate, 
  });

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>(); 

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Fitness",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // STEPS
            const Text("Daily Steps"),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    key: ValueKey(
                      steps,
                    ), // Forces the field to update when data changes
                    initialValue: steps.toInt().toString(),
                    decoration: const InputDecoration(
                      hintText: "Steps",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val) =>
                        onStepsChanged(double.tryParse(val) ?? 0),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  child: FilledButton.tonalIcon(
                    icon: isFetchingHealth
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.fitbit),
                    label: const Text("Auto-fill"),
                    onPressed: isFetchingHealth ? null : onAutoFill,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // SLEEP
            Text("Sleep: ${sleep.toStringAsFixed(1)} hours"),
            Slider(
              value: sleep,
              min: 0,
              max: 12,
              divisions: 24,
              label: sleep.toStringAsFixed(1),
              onChanged: onSleepChanged,
            ),
            const SizedBox(height: 16),

            // WORKOUT TYPE
            const Text("Workout today?"),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Rest', label: Text('Rest')),
                ButtonSegment(value: 'Cardio', label: Text('Cardio')),
                ButtonSegment(value: 'Strength', label: Text('Strength')),
              ],
              selected: {workoutType},
              onSelectionChanged: (newSelection) =>
                  onWorkoutChanged(newSelection.first),
            ),
            const SizedBox(height: 16),

            // // WORKOUT MODAL
            // Center(
            //   child: TextButton.icon(
            //     icon: const Icon(Icons.add),
            //     label: const Text("Log specific workout details"),
            //     onPressed: () {
            //       WorkoutModal.show(context, (name, type, duration) {});
            //     },
            //   ),
            // ),
            // const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Log detailed workout"),
                onPressed: onAddWorkout, // TRIGGERS THE MODAL
              ),
            ),
            // Live List of Workouts
            StreamBuilder<List<Workout>>(
              stream: db.watchWorkoutsForDate(selectedDate),
              builder: (context, snapshot) {
                final items = snapshot.data ?? [];
                if (items.isEmpty) return const SizedBox(); // Hide if empty
                
                return Column(
                  children: items.map((w) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.fitness_center, color: Colors.teal, size: 20),
                    title: Text(w.activityName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${w.durationMinutes} mins"),
                    trailing: w.caloriesBurned != null ? Text("${w.caloriesBurned} kcal", style: const TextStyle(color: Colors.grey)) : null,
                  )).toList(),
                );
              }
            ),
            
          ],
        ),
      ),
    );
  }
}
