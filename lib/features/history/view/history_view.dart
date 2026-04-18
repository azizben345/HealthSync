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
  Widget _buildListView(List<DailyRecord> records, HistoryController historyCtrl) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        final dateString = DateFormat.yMMMd().format(record.date);

        return Dismissible(
          key: Key(record.id.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => historyCtrl.deleteSingleRecord(record.id),
          child: Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Date & Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dateString, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
                      Row(
                        children: [
                          // Retry AI Button (If it failed)
                          if (record.avatarState == 'pending') 
                            historyCtrl.isRetrying(record.id)
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : IconButton(
                                    icon: const Icon(Icons.refresh, color: Colors.blue, size: 20),
                                    onPressed: () => historyCtrl.retryPendingAI(record),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                          const SizedBox(width: 8),
                          // Workout Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              record.workoutType ?? "Rest",
                              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onPrimaryContainer),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  
                  // Metrics Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetric(Icons.directions_walk, "${record.steps}", "Steps"),
                      _buildMetric(Icons.bedtime, "${record.sleepHours}h", "Sleep"),
                      _buildMetric(Icons.restaurant, record.dietQuality ?? "-", "Diet"),
                    ],
                  ),
                ],
              ),
            ),
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
}