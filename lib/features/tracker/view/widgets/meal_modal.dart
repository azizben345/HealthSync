import 'package:flutter/material.dart';

class MealModal extends StatefulWidget {
  final Function(String name, String type, int? calories) onSave;

  const MealModal({super.key, required this.onSave});

  static void show(BuildContext context, Function(String, String, int?) onSave) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: MealModal(onSave: onSave),
      ),
    );
  }

  @override
  State<MealModal> createState() => _MealModalState();
}

class _MealModalState extends State<MealModal> {
  final _nameCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  String _mealType = 'Lunch'; // Default value

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
              const Text("Log Meal", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: "Meal Name (e.g., Chicken Salad)", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _mealType,
                  decoration: const InputDecoration(labelText: "Meal Type", border: OutlineInputBorder()),
                  items: ['Breakfast', 'Lunch', 'Dinner', 'Snack'].map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (val) => setState(() => _mealType = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _calCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Calories (Optional)", border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final calories = int.tryParse(_calCtrl.text);
                if (_nameCtrl.text.isNotEmpty) {
                  widget.onSave(_nameCtrl.text, _mealType, calories);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Meal"),
            ),
          )
        ],
      ),
    );
  }
}