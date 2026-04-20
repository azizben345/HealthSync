import 'package:flutter/material.dart';
import 'meal_modal.dart';
import 'package:provider/provider.dart';
import '../../../../data/database/app_database.dart';

class NutritionInputCard extends StatelessWidget {
  final String dietQuality;
  final Function(String) onDietChanged;
  final VoidCallback onAddMeal;
  final DateTime selectedDate;

  const NutritionInputCard({
    super.key,
    required this.dietQuality,
    required this.onDietChanged,
    required this.onAddMeal,
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
            const Text("Nutrition", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Cheat Day', label: Text('Cheat Day')),
                ButtonSegment(value: 'Normal', label: Text('Normal')),
                ButtonSegment(value: 'Healthy', label: Text('Healthy')),
              ],
              selected: {dietQuality},
              onSelectionChanged: (newSelection) => onDietChanged(newSelection.first),
            ),
            const SizedBox(height: 16),
            // Center(
            //   child: TextButton.icon(
            //     icon: const Icon(Icons.add),
            //     label: const Text("Log specific meal details"),
            //     onPressed: () {
            //       MealModal.show(context, (name, type, calories) {
            //         // For now, just print it to test the UI! 
            //         // We will connect this to the database next.
            //         print("Saved: $name, $type, $calories cals");
            //       });
            //     },
            //   ),
            // ),
            // const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Log detailed meal"),
                onPressed: onAddMeal, // TRIGGERS THE MODAL
              ),
            ),
            // Live List of Meals
            StreamBuilder<List<Meal>>(
              stream: db.watchMealsForDate(selectedDate),
              builder: (context, snapshot) {
                final items = snapshot.data ?? [];
                if (items.isEmpty) return const SizedBox();
                
                return Column(
                  children: items.map((m) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.restaurant, color: Colors.orange, size: 20),
                    title: Text(m.mealName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(m.mealType),
                    trailing: m.calories != null ? Text("${m.calories} kcal", style: const TextStyle(color: Colors.grey)) : null,
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