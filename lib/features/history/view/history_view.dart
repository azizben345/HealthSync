import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../controller/history_controller.dart';
import '../../../data/database/app_database.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  String _viewMode = 'chart'; // Let's default to the cool chart!

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
    final db = context.read<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Logs"),
        centerTitle: true,
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
          // 1. The Toggle Button
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
          
          // 2. The Live Display Area
          Expanded(
            child: StreamBuilder<List<DailyRecord>>(
              stream: db.watchAllRecords(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final records = snapshot.data ?? [];

                if (records.isEmpty) {
                  return const Center(child: Text("No records yet. Try injecting mock data!"));
                }

                // Pass the live records to whichever view is selected
                return _viewMode == 'list' 
                    ? _buildListView(records, historyCtrl) 
                    : _buildChartView(records);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- SLEEK LIST VIEW ---
  // --- UPGRADED EXPANDABLE LIST VIEW ---
  Widget _buildListView(List<DailyRecord> records, HistoryController historyCtrl) {
    final db = context.read<AppDatabase>(); // Need this for the delete function

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        final dateString = DateFormat.yMMMd().format(record.date);

        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          clipBehavior: Clip.antiAlias, // Keeps the corners rounded when expanded
          // ExpansionTile is the magic widget that handles the drop-down animation!
          child: ExpansionTile(
            // --- SIMPLIFIED VIEW (Always Visible) ---
            title: Text(dateString, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
            subtitle: Text("Steps: ${record.steps} • Sleep: ${record.sleepHours}h\nDiet: ${record.dietQuality} • Workout: ${record.workoutType}", style: const TextStyle(color: Colors.grey)),
            leading: Icon(_getIconForState(record.avatarState), color: _getColorForState(record.avatarState)),
            
            // --- DETAILED VIEW (Revealed on Tap) ---
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),

                    // DETAILED WORKOUTS LIST
                    StreamBuilder<List<Workout>>(
                      stream: db.watchWorkoutsForDate(record.date),
                      builder: (context, snapshot) {
                        final workouts = snapshot.data ?? [];
                        if (workouts.isEmpty) return const SizedBox(); // Hide if no workouts
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Workouts", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            ...workouts.map((w) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.fitness_center, color: Colors.teal, size: 20),
                              title: Text(w.activityName, style: const TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text("${w.durationMinutes} mins"),
                              trailing: w.caloriesBurned != null ? Text("${w.caloriesBurned} kcal", style: const TextStyle(color: Colors.grey)) : null,
                            )),
                            const SizedBox(height: 16),
                          ],
                        );
                      }
                    ),

                    // DETAILED MEALS LIST
                    StreamBuilder<List<Meal>>(
                      stream: db.watchMealsForDate(record.date),
                      builder: (context, snapshot) {
                        final meals = snapshot.data ?? [];
                        if (meals.isEmpty) return const SizedBox(); // Hide if no meals
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Meals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            ...meals.map((m) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.restaurant, color: Colors.orange, size: 20),
                              title: Text(m.mealName, style: const TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(m.mealType),
                              trailing: m.calories != null ? Text("${m.calories} kcal", style: const TextStyle(color: Colors.grey)) : null,
                            )),
                            const SizedBox(height: 16),
                          ],
                        );
                      }
                    ),

                    // 1. THE DIARY
                    if (record.diaryNote != null && record.diaryNote!.isNotEmpty) ...[
                      const Text("Journal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Text("\"${record.diaryNote}\"", style: const TextStyle(fontStyle: FontStyle.italic)),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 2. THE AI COACH MESSAGE
                    if (record.coachMessage != null && record.coachMessage!.isNotEmpty) ...[
                      const Text("Coach Feedback", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(record.coachMessage!, style: const TextStyle(color: Colors.teal)),
                      const SizedBox(height: 16),
                    ],

                    const Divider(),

                    // 3. THE EXPLICIT DELETE BUTTON
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.delete_forever, color: Colors.red),
                        label: const Text("Delete Log", style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          // The Safety Confirmation Dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Delete Log?"),
                              content: const Text("This will permanently delete this day's health data, meals, and workouts. You cannot undo this."),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                FilledButton(
                                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () {
                                    db.deleteEntireDay(record.id); // Triggers the cascade delete
                                    Navigator.pop(context); // Close dialog
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetric(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  // --- ANALYTICS CHART VIEW ---
  Widget _buildChartView(List<DailyRecord> records) {
    // Because the StreamBuilder orders by newest first, we take the top 7 and reverse them for chronological charting
    final recentRecords = records.take(7).toList().reversed.toList();
    final todayRecord = recentRecords.last;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildMetricCard(
          title: "Steps",
          valueText: todayRecord.steps.toString(),
          unitText: "Today",
          barColor: Colors.teal, // Updated to match your theme!
          records: recentRecords,
          valueMapper: (record) => record.steps.toDouble(),
        ),
        const SizedBox(height: 16),
        _buildMetricCard(
          title: "Sleep",
          valueText: todayRecord.sleepHours.toStringAsFixed(1),
          unitText: "Hours Today",
          barColor: Colors.indigoAccent,
          records: recentRecords,
          valueMapper: (record) => record.sleepHours,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String valueText,
    required String unitText,
    required Color barColor,
    required List<DailyRecord> records,
    required double Function(DailyRecord) valueMapper,
  }) {
    double maxY = 0;
    for (var r in records) {
      if (valueMapper(r) > maxY) maxY = valueMapper(r);
    }
    if (maxY == 0) maxY = 10; 

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text("Last 7 days", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(valueText, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: barColor)),
                      Text(unitText, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 70, 
                    child: BarChart(
                      BarChartData(
                        maxY: maxY * 1.2, 
                        gridData: const FlGridData(show: false), 
                        borderData: FlBorderData(show: false), 
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                        barGroups: records.asMap().entries.map((entry) {
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: valueMapper(entry.value),
                                color: barColor,
                                width: 10, 
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
  // --- UI HELPERS ---
  Color _getColorForState(String state) {
    switch (state.toLowerCase()) {
      case 'happy': return Colors.green;
      case 'proud': return Colors.purple;
      case 'tired': return Colors.orange;
      case 'gloomy': return Colors.blueGrey;
      case 'pending': return Colors.grey;
      default: return Colors.teal;
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