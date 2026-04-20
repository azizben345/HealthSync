import 'package:flutter/material.dart';

class MoodInputCard extends StatelessWidget {
  final TextEditingController diaryController;
  final double moodScore;
  final Function(double) onMoodChanged;

  const MoodInputCard({
    super.key,
    required this.diaryController,
    required this.moodScore,
    required this.onMoodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Mood", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(),
            const SizedBox(height: 8),
            
            // NEW: The 1-10 Mood Slider
            Text("Overall Mood: ${moodScore.toInt()}/10", style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: moodScore,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: _getMoodColor(moodScore),
              label: moodScore.toInt().toString(),
              onChanged: onMoodChanged,
            ),
            const SizedBox(height: 16),

            // DIARY
            const Text("Journal"),
            const SizedBox(height: 8),
            TextField(
              controller: diaryController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "How are you feeling today?",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(double score) {
    if (score >= 8) return Colors.green;
    if (score >= 5) return Colors.orange;
    return Colors.red;
  }
}