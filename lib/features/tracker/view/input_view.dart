import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../avatar/controller/avatar_controller.dart';
// import '../../../data/services/auth_service.dart';
// import '../../../data/database/app_database.dart';
// import '../../../data/services/sync_service.dart';
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
      // Notice we removed the rigid AppBar to make it look more modern!
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            
            // HEADER & AVATAR SPACE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Good Morning,", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey)),
                    Text("Ready to sync?", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Placeholder for future Animated Avatar
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              // color: Colors.blue.shade50, // Soft background for the avatar
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      // height: 180,
                      // width: 180,
                      child: avatarCtrl.isLoading 
                        ? const Center(child: CircularProgressIndicator()) 
                        : Lottie.asset(
                            'assets/animations/${avatarCtrl.avatarState}.json', 
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.person, size: 80)),
                          ),
                    ),
                    const SizedBox(height: 12),
                    // AI Response Message Bubble
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        // borderRadius: BorderRadius.circular(15),
                        // border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Text(
                        "\"${avatarCtrl.coachMessage}\"",
                        // style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 2. ACTIVITY CARD (Steps & Workout)
            const Text("Activity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Daily Metrics Input Box
                    const Text("Daily Metrics"),
                    const Divider(),
                    // // STEP INPUT
                    Text("Steps: ${_steps.toInt()}"),
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
                            decoration: const InputDecoration(hintText: "Steps"),
                            keyboardType: TextInputType.number,
                            onChanged: (val) => setState(() => _steps = double.tryParse(val) ?? 0),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Steps Auto-Fill Button
                        SizedBox(
                          height: 56, // Match the height of the TextField
                          child: FilledButton.tonalIcon(
                            icon: _isFetchingHealth 
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.fitbit),
                            label: const Text("Auto-fill"),
                            onPressed: _isFetchingHealth ? null : () async {
                              setState(() => _isFetchingHealth = true);
                              
                              final steps = await HealthService().fetchTodaySteps();
                              
                              if (steps != null) {
                                setState(() {
                                  _steps = steps.toDouble();
                                  // if using a TextEditingController instead of initialValue, 
                                  // update here. e.g., _stepsController.text = steps.toString();
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
                    const SizedBox(height: 16),
                    // WORKOUT?PHYSICAL SEGMENT INPUT
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
            const SizedBox(height: 24),

            // 3. RECOVERY CARD (Sleep & Diet)
            const Text("Recovery & Fuel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // SLEEP SLIDER
                    Text("Sleep: ${_sleep.toStringAsFixed(1)} hours"),
                    Slider(
                      value: _sleep,
                      min: 0,
                      max: 12,
                      divisions: 24,
                      label: _sleep.toStringAsFixed(1),
                      onChanged: (val) => setState(() => _sleep = val),
                    ),
                    const SizedBox(height: 16),
                    // DIET SEGMENT INPUT
                    const Text("Diet"),
                    const SizedBox(height: 8),
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 4. MOOD & SUBMIT CARD
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // // DIARY NOTE TEXTFIELD
                    const Text("Journal"),
                    const Divider(),
                    TextField(
                      controller: _diaryController,
                      maxLines: 3,
                      decoration: const InputDecoration(hintText: "How are you feeling today?"),
                    ),
                    const SizedBox(height: 16),
                    
                    // The Big Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: avatarCtrl.isLoading ? null : () {
                          avatarCtrl.updateAvatarLogic(
                            steps: _steps.toInt(),
                            sleep: _sleep,
                            diary: _diaryController.text,
                            diet: _dietQuality,
                            workout: _workoutType,
                          );
                        },
                        child: const Text("Save Daily Log", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40), // Bottom padding so it doesn't hug the nav bar
          ],
        ),
      ),
    );
  }
}