import 'package:flutter/material.dart';

class WorkoutModal extends StatefulWidget {
  final Function(String name, int duration, int? calories) onSave;

  const WorkoutModal({super.key, required this.onSave});

  // A quick helper function to trigger this modal from anywhere
  static void show(BuildContext context, Function(String, int, int?) onSave) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        // This padding ensures the keyboard doesn't cover the form!
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: WorkoutModal(onSave: onSave),
      ),
    );
  }

  @override
  State<WorkoutModal> createState() => _WorkoutModalState();
}

class _WorkoutModalState extends State<WorkoutModal> {
  final _nameCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _calCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Log Workout", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: "Activity Name (e.g., Running, Yoga)", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _durationCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Duration (mins)", border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _calCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Calories Burned (Optional)", border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final duration = int.tryParse(_durationCtrl.text) ?? 0;
                final calories = int.tryParse(_calCtrl.text);
                if (_nameCtrl.text.isNotEmpty && duration > 0) {
                  widget.onSave(_nameCtrl.text, duration, calories);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Workout"),
            ),
          )
        ],
      ),
    );
  }
}