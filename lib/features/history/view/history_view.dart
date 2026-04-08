import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../controller/history_controller.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  // to find and show file path/location
  Future<void> _showDatabasePath(BuildContext context) async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fyp_tracker.sqlite'));

    // Check if the widget is still on screen before showing the dialog
    if (!context.mounted) return; 

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Database Location"),
        content: SelectableText(file.path), // SelectableText lets you copy it!
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyCtrl = context.watch<HistoryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Logs"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'mock') historyCtrl.generateMockData();
              if (value == 'clear') historyCtrl.clearAllData();
              if (value == 'path') _showDatabasePath(context); // NEW: Trigger the popup
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'path', child: Text("Show DB Path")),
              const PopupMenuItem(value: 'mock', child: Text("Inject Mock Data")),
              const PopupMenuItem(value: 'clear', child: Text("Clear All Data", style: TextStyle(color: Colors.red))),
            ],
          ),
        ],
      ),
      body: historyCtrl.records.isEmpty
          ? const Center(child: Text("No records yet. Try injecting mock data!"))
          : ListView.builder(
              itemCount: historyCtrl.records.length,
              itemBuilder: (context, index) {
                final record = historyCtrl.records[index];
                final dateStr = "${record.date.day}/${record.date.month}/${record.date.year}";

                return Dismissible(
                  key: Key(record.id.toString()),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) => historyCtrl.deleteSingleRecord(record.id),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getColorForState(record.avatarState),
                        child: Icon(_getIconForState(record.avatarState), color: Colors.white),
                      ),
                      title: Text(dateStr, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Steps: ${record.steps} | Sleep: ${record.sleepHours}h\nNote: ${record.diaryNote}"),
                      isThreeLine: true,
                      // Retry Button
                      trailing: record.avatarState == 'pending' 
                          ? (historyCtrl.isRetrying(record.id)
                              // If this specific card is loading, show a small spinner
                              ? const SizedBox(
                                  width: 24, 
                                  height: 24, 
                                  child: CircularProgressIndicator(strokeWidth: 2)
                                )
                              // Otherwise, show the retry button
                              : IconButton(
                                  icon: const Icon(Icons.refresh, color: Colors.blue),
                                  tooltip: "Retry AI Sync",
                                  onPressed: () => historyCtrl.retryPendingAI(record),
                                ))
                          : null, // If it's NOT pending, show nothing on the right side
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getColorForState(String state) {
    switch (state.toLowerCase()) {
      case 'happy': return Colors.green;
      case 'proud': return Colors.purple;
      case 'tired': return Colors.orange;
      case 'gloomy': return Colors.blueGrey;
      case 'pending': return Colors.grey;
      default: return Colors.grey;
    }
  }

  IconData _getIconForState(String state) {
    switch (state.toLowerCase()) {
      case 'happy': return Icons.sentiment_very_satisfied;
      case 'proud': return Icons.star;
      case 'tired': return Icons.bedtime;
      case 'gloomy': return Icons.sentiment_dissatisfied;
      case 'pending': return Icons.hourglass_empty;
      default: return Icons.person;
    }
  }
}