import 'package:flutter/material.dart';
import 'package:healthsync_demo_v01_00/data/database/app_database.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../controller/history_controller.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  // default view of History tab
  String _viewMode = 'map'; 

  Future<void> _showDatabasePath(BuildContext context) async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fyp_tracker.sqlite'));
    if (!context.mounted) return; 
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Database Location"),
        content: SelectableText(file.path),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
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
              if (value == 'path') _showDatabasePath(context);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'path', child: Text("Show DB Path")),
              const PopupMenuItem(value: 'mock', child: Text("Inject Mock Data")),
              const PopupMenuItem(value: 'clear', child: Text("Clear All Data", style: TextStyle(color: Colors.red))),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Toggle Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'chart', label: Text('Analytics'), icon: Icon(Icons.bar_chart)),
                ButtonSegment(value: 'list', label: Text('List View'), icon: Icon(Icons.list)),
              ],
              selected: {_viewMode},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() => _viewMode = newSelection.first);
              },
            ),
          ),
          
          // --- Display Area ---
          Expanded(
            child: historyCtrl.records.isEmpty
                ? const Center(child: Text("No records yet. Try injecting mock data!"))
                : _viewMode == 'list' 
                    ? _buildListView(historyCtrl) 
                    : _buildChartView(historyCtrl),
          ),
        ],
      ),
    );
  }

  // List Logic
  Widget _buildListView(HistoryController historyCtrl) {
    return ListView.builder(
      itemCount: historyCtrl.records.length,
      itemBuilder: (context, index) {
        final record = historyCtrl.records[index];
        final dateStr = "${record.date.day}/${record.date.month}";

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
              subtitle: Text("Steps: ${record.steps} | Sleep: ${record.sleepHours}h\nWorkout: ${record.workoutType} | Diet: ${record.dietQuality}"),
              isThreeLine: true,
              trailing: record.avatarState == 'pending' 
                  ? (historyCtrl.isRetrying(record.id)
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.blue),
                          onPressed: () => historyCtrl.retryPendingAI(record),
                        ))
                  : null,
            ),
          ),
        );
      },
    );
  }

  // Bar Chart
  // --- DASHBOARD VIEW (Google Fit Style) ---
  Widget _buildChartView(HistoryController historyCtrl) {
    // Grab up to 7 days of data, chronologically (oldest to newest)
    final recentRecords = historyCtrl.records.take(7).toList().reversed.toList();

    if (recentRecords.isEmpty) {
      return const Center(child: Text("No data to display."));
    }

    // The last item in the list is the most recent day ("Today")
    final todayRecord = recentRecords.last;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildMetricCard(
          title: "Steps",
          valueText: todayRecord.steps.toString(),
          unitText: "Today",
          barColor: Colors.blueAccent,
          records: recentRecords,
          valueMapper: (record) => record.steps.toDouble(),
        ),
        const SizedBox(height: 16),
        _buildMetricCard(
          title: "Sleep",
          valueText: todayRecord.sleepHours.toStringAsFixed(1),
          unitText: "Hours Today",
          barColor: Colors.deepPurpleAccent,
          records: recentRecords,
          valueMapper: (record) => record.sleepHours,
        ),
      ],
    );
  }

  // --- THE REUSABLE GOOGLE FIT CARD ENGINE ---
  Widget _buildMetricCard({
    required String title,
    required String valueText,
    required String unitText,
    required Color barColor,
    required List<DailyRecord> records,
    required double Function(DailyRecord) valueMapper,
  }) {
    // 1. Calculate the maximum Y value so the bars don't break the top of the chart
    double maxY = 0;
    for (var r in records) {
      if (valueMapper(r) > maxY) maxY = valueMapper(r);
    }
    if (maxY == 0) maxY = 10; // Fallback to prevent divide-by-zero

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text("Last 7 days", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            
            // The Split View: Value on Left, Chart on Right
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // LEFT SIDE: Big Number
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        valueText, 
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: barColor)
                      ),
                      Text(unitText, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                
                // RIGHT SIDE: The Minimalist Chart
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 70, // Keep the chart short and glanceable!
                    child: BarChart(
                      BarChartData(
                        maxY: maxY * 1.2, // Give the highest bar a little breathing room
                        gridData: const FlGridData(show: false), // Hide background lines
                        borderData: FlBorderData(show: false), // Hide borders
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          // Only show the bottom X-Axis letters
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 && value.toInt() < records.length) {
                                  final date = records[value.toInt()].date;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      _getWeekdayLetter(date.weekday), 
                                      style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)
                                    ),
                                  );
                                }
                                return const Text("");
                              },
                            ),
                          ),
                        ),
                        // Draw the actual bars
                        barGroups: records.asMap().entries.map((entry) {
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: valueMapper(entry.value),
                                color: barColor,
                                width: 10, // Slim, sleek bars
                                borderRadius: BorderRadius.circular(2),
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper to convert DateTime.weekday (1-7) into a single letter
  String _getWeekdayLetter(int weekday) {
    switch (weekday) {
      case 1: return 'M';
      case 2: return 'T';
      case 3: return 'W';
      case 4: return 'T';
      case 5: return 'F';
      case 6: return 'S';
      case 7: return 'S';
      default: return '';
    }
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