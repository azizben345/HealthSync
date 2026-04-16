import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../avatar/controller/avatar_controller.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/database/app_database.dart';
import '../../../data/services/sync_service.dart';
import '../../../data/services/health_service.dart';
class InputView extends StatefulWidget {
  const InputView({super.key});

  @override
  State<InputView> createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  // Core Metrics
  double _steps = 5000;
  double _sleep = 7.0;
  final TextEditingController _diaryController = TextEditingController();
  String _dietQuality = 'Normal'; 
  String _workoutType = 'Rest';
  bool _isFetchingHealth = false;

  @override
  void dispose() {
    _diaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatarCtrl = context.watch<AvatarController>();

    return Scaffold(
      appBar: AppBar(
        // title: const Text("HealthSync Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        title: const Text("Daily Check-in", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        // logout button
        actions: [
          // Cloud Backup (Firestore DB) Button
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            tooltip: "Backup to Cloud",
            onPressed: () async {
              try {
                // show loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Syncing to cloud...")),
                );
                
                // run the sync service
                final db = context.read<AppDatabase>();
                await SyncService(db).backupToCloud();
                
                // success message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Backup successful!"), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Sync failed: $e"), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 171, 23, 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            tooltip: "Logout",
            onPressed: () async {
              // calls the backend, and the StreamBuilder handles the UI switch
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            // --- 1. THE HERO SECTION (Avatar & Coach) ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.blue.shade50, // Soft background for the avatar
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 180,
                      width: 180,
                      child: avatarCtrl.isLoading 
                        ? const Center(child: CircularProgressIndicator()) 
                        : Lottie.asset(
                            'assets/animations/${avatarCtrl.avatarState}.json', 
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.person, size: 80)),
                          ),
                    ),
                    const SizedBox(height: 12),
                    // AI Coach Message Bubble
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Text(
                        "\"${avatarCtrl.coachMessage}\"",
                        style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- 2. CORE METRICS CARD ---
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Daily Metrics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    Text("Steps: ${_steps.toInt()}"),
                    // // Step Input
                    // Slider(
                    //   value: _steps,
                    //   min: 0,
                    //   max: 20000,
                    //   divisions: 20,
                    //   label: _steps.toInt().toString(),
                    //   onChanged: (val) => setState(() => _steps = val),
                    // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _steps.toString(),
                            // decoration: const InputDecoration(labelText: 'Steps', border: OutlineInputBorder()),
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            onChanged: (val) => setState(() => _steps = double.tryParse(val) ?? 0),
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // The Auto-Fill Button
                        SizedBox(
                          height: 56, // Match the height of the TextField
                          child: FilledButton.tonalIcon(
                            icon: _isFetchingHealth 
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.auto_awesome),
                            label: const Text("Auto-fill"),
                            onPressed: _isFetchingHealth ? null : () async {
                              setState(() => _isFetchingHealth = true);
                              
                              final steps = await HealthService().fetchTodaySteps();
                              
                              if (steps != null) {
                                setState(() {
                                  _steps = steps.toDouble();
                                  // If you are using a TextEditingController instead of initialValue, 
                                  // update it here! e.g., _stepsController.text = steps.toString();
                                });
                                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Steps synced from phone!"), backgroundColor: Colors.green));
                              } else {
                                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to get steps. Do you have Google Fit / Health Connect installed?"), backgroundColor: Colors.orange));
                              }
                              
                              setState(() => _isFetchingHealth = false);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Sleep Input
                    Text("Sleep: ${_sleep.toStringAsFixed(1)} hours"),
                    Slider(
                      value: _sleep,
                      min: 0,
                      max: 12,
                      divisions: 24,
                      label: _sleep.toStringAsFixed(1),
                      onChanged: (val) => setState(() => _sleep = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- 3. QUICK HABITS CARD (Diet & Workout) ---
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Quick Habits", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    const Text("Diet Quality today?"),
                    const SizedBox(height: 8),
                    // Segmented Button looks very professional
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'Cheat Day', label: Text('Cheat Day')),
                        ButtonSegment(value: 'Normal', label: Text('Normal')),
                        ButtonSegment(value: 'Healthy', label: Text('Healthy')),
                      ],
                      selected: {_dietQuality},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() => _dietQuality = newSelection.first);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Workout today?"),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'Rest', label: Text('Rest')),
                        ButtonSegment(value: 'Cardio', label: Text('Cardio')),
                        ButtonSegment(value: 'Strength', label: Text('Strength')),
                      ],
                      selected: {_workoutType},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() => _workoutType = newSelection.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- 4. THE JOURNAL CARD ---
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Journal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    TextField(
                      controller: _diaryController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "How are you feeling today?",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- 5. THE SYNC BUTTON ---
            FilledButton.icon(
              icon: avatarCtrl.isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.sync),
              label: Text(avatarCtrl.isLoading ? "Analyzing..." : "Sync with AI Avatar"),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: avatarCtrl.isLoading ? null : () {
                // For now, we still only pass the 3 original variables.
                // We will add Diet and Workout to the DB in the next step!
                avatarCtrl.updateAvatarLogic(
                  steps: _steps.toInt(),
                  sleep: _sleep,
                  diary: _diaryController.text,
                  diet: _dietQuality,
                  workout: _workoutType,
                );
              },
            ),
            const SizedBox(height: 40), // Bottom padding for scrolling
          ],
        ),
      ),
    );
  }
}