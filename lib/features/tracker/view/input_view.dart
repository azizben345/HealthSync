import 'package:flutter/material.dart';
import 'package:healthsync_demo_v01_00/data/database/app_database.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../avatar/controller/avatar_controller.dart';
// import '../../../data/services/auth_service.dart';
// import '../../../data/database/app_database.dart';
// import '../../../data/services/sync_service.dart';
import '../../../data/services/health_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'widgets/fitness_input_card.dart';
import 'widgets/meal_modal.dart';
import 'widgets/nutrition_input_card.dart';
import 'widgets/mood_input_card.dart';
import 'widgets/workout_modal.dart';

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
  double _moodScore = 5.0;
  bool _isFetchingHealth = false;

  // keep track of which day users are logging for (defaults to today)
  DateTime _selectedDate = DateTime.now();
  // flag to track either updating existing data or creating new data
  bool _hasExistingData = false;
  // set of dates to tell the calendar where to draw dots - indicated logged dates
  Map<DateTime, String> _loggedDates = {};

  @override
  void initState() {
    super.initState();
    // NEW: Check if there's already data for "Today" when the screen first loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataForSelectedDate();
      _refreshCalendarDots();
    });
  }

  // NEW: The function that pulls the database record and changes the UI sliders
  Future<void> _loadDataForSelectedDate() async {
    final db = context.read<AppDatabase>();
    final record = await db.getRecordByDate(_selectedDate);

    setState(() {
      if (record != null) {
        // MATCH FOUND: Auto-fill the form with their past data!
        _hasExistingData = true;
        _steps = record.steps.toDouble();
        _sleep = record.sleepHours;
        _dietQuality = record.dietQuality ?? 'Normal';
        _workoutType = record.workoutType ?? 'Rest';
        _diaryController.text = record.diaryNote ?? '';
        context.read<AvatarController>().setHistoricalState(
          record.avatarState, 
          record.coachMessage ?? "I still haven't respond to this date's logs",
        );
      } else {
        // NO MATCH: Reset the form to default blank states
        _hasExistingData = false;
        _steps = 5000;
        _sleep = 7.0;
        _dietQuality = 'Normal';
        _workoutType = 'Rest';
        _diaryController.text = '';
        // reset/clear the avatar state
        context.read<AvatarController>().resetState();
      }
    });
  }

  // fetch list of dates from database
  Future<void> _refreshCalendarDots() async {
    final db = context.read<AppDatabase>();
    final records = await db.getAllLoggedRecords();
    
    final Map<DateTime, String> newMap = {};
    for (var r in records) {
      final normDate = DateTime(r.date.year, r.date.month, r.date.day);
      newMap[normDate] = r.avatarState; // Link the date to the emotion!
    }
    
    setState(() {
      _loggedDates = newMap;
    });
  }

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
                    // Text("Good Morning,", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey)),
                    Text("Sync your health today", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text("Good Morning,", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey)),
                            // NEW: A clickable button that shows the selected date
                            TextButton.icon(
                              onPressed: _pickDate,
                              icon: const Icon(Icons.calendar_month, color: Colors.teal),
                              label: Text(
                                // If it's today, say "Today". Otherwise, show the date.
                                _selectedDate.day == DateTime.now().day && _selectedDate.month == DateTime.now().month 
                                    ? "Logging for Today" 
                                    : "Logging for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.teal),
                              ),
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                            ),
                            // Visual Cue
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _hasExistingData ? Colors.orange.shade100 : Colors.teal.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _hasExistingData ? "✎ Editing Existing Log" : "✨ Creating New Log",
                                style: TextStyle(
                                  fontSize: 12, 
                                  fontWeight: FontWeight.bold,
                                  color: _hasExistingData ? Colors.orange.shade900 : Colors.teal.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

            // // 2. ACTIVITY CARD (Steps & Workout)
            // const Text("Activity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            // const SizedBox(height: 8),
            // Card(
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Column(
            //       children: [
            //         // Daily Metrics Input Box
            //         const Text("Daily Metrics"),
            //         const Divider(),
            //         // // STEP INPUT
            //         Text("Steps: ${_steps.toInt()}"),
            //         // Slider(
            //         //   value: _steps,
            //         //   min: 0,
            //         //   max: 20000,
            //         //   divisions: 20,
            //         //   label: _steps.toInt().toString(),
            //         //   onChanged: (val) => setState(() => _steps = val),
            //         // ),
            //         Row(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Expanded(
            //               child: TextFormField(
            //                 initialValue: _steps.toString(),
            //                 // decoration: const InputDecoration(labelText: 'Steps', border: OutlineInputBorder()),
            //                 decoration: const InputDecoration(hintText: "Steps"),
            //                 keyboardType: TextInputType.number,
            //                 onChanged: (val) => setState(() => _steps = double.tryParse(val) ?? 0),
            //               ),
            //             ),
            //             const SizedBox(width: 8),
            //             // Steps Auto-Fill Button
            //             SizedBox(
            //               height: 56, // Match the height of the TextField
            //               child: FilledButton.tonalIcon(
            //                 icon: _isFetchingHealth 
            //                     ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            //                     : const Icon(Icons.fitbit),
            //                 label: const Text("Auto-fill"),
            //                 onPressed: _isFetchingHealth ? null : () async {
            //                   setState(() => _isFetchingHealth = true);
                              
            //                   final steps = await HealthService().fetchTodaySteps();
                              
            //                   if (steps != null) {
            //                     setState(() {
            //                       _steps = steps.toDouble();
            //                       // if using a TextEditingController instead of initialValue, 
            //                       // update here. e.g., _stepsController.text = steps.toString();
            //                     });
            //                     if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Steps synced from phone!"), backgroundColor: Colors.green));
            //                   } else {
            //                     if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to get steps. Do you have Google Fit / Health Connect installed?"), backgroundColor: Colors.orange));
            //                   }
                              
            //                   setState(() => _isFetchingHealth = false);
            //                 },
            //               ),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(height: 16),
            //         // WORKOUT?PHYSICAL SEGMENT INPUT
            //         const Text("Workout today?"),
            //         const SizedBox(height: 8),
            //         SegmentedButton<String>(
            //           segments: const [
            //             ButtonSegment(value: 'Rest', label: Text('Rest')),
            //             ButtonSegment(value: 'Cardio', label: Text('Cardio')),
            //             ButtonSegment(value: 'Strength', label: Text('Strength')),
            //           ],
            //           selected: {_workoutType},
            //           onSelectionChanged: (Set<String> newSelection) {
            //             setState(() => _workoutType = newSelection.first);
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 24),

            // 3. RECOVERY CARD (Sleep & Diet)
            // 3. THE REFACTORED LEGO BLOCKS
            FitnessInputCard(
              selectedDate: _selectedDate,
              steps: _steps,
              sleep: _sleep,
              workoutType: _workoutType,
              isFetchingHealth: _isFetchingHealth,
              onStepsChanged: (val) => setState(() => _steps = val),
              onSleepChanged: (val) => setState(() => _sleep = val),
              onWorkoutChanged: (val) => setState(() => _workoutType = val),
              onAutoFill: () async {
                // Keep your HealthService logic here!
                setState(() => _isFetchingHealth = true);
                final steps = await HealthService().fetchTodaySteps();
                if (steps != null) {
                  setState(() => _steps = steps.toDouble());
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Steps synced!")));
                }
                setState(() => _isFetchingHealth = false);
              },
              onAddWorkout: () {
                WorkoutModal.show(context, (name, duration, calories) async {
                  // 1. Grab the database
                  final db = context.read<AppDatabase>();
                  
                  // 2. Save the details to SQLite!
                  await db.addDetailedWorkout(_selectedDate, name, duration, calories);
                  
                  // 3. Show a success message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Saved $name to your logs!"), backgroundColor: Colors.green)
                    );
                  }
                });
              },
            ),
            const SizedBox(height: 24),

            NutritionInputCard(
              selectedDate: _selectedDate,
              dietQuality: _dietQuality,
              onDietChanged: (val) => setState(() => _dietQuality = val),
              onAddMeal: () {
                MealModal.show(context, (name, type, calories) async {
                  final db = context.read<AppDatabase>();
                  await db.addDetailedMeal(_selectedDate, name, type, calories);
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Saved $name to your logs!"), backgroundColor: Colors.green)
                    );
                  }
                });
              },
            ),
            const SizedBox(height: 24),

            MoodInputCard(
              diaryController: _diaryController,
              moodScore: _moodScore,
              onMoodChanged: (val) => setState(() => _moodScore = val),
            ),
            const SizedBox(height: 24),

            // 4. THE SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: avatarCtrl.isLoading ? null : () async {
                  await avatarCtrl.updateAvatarLogic(
                    steps: _steps.toInt(),
                    sleep: _sleep,
                    diary: _diaryController.text,
                    diet: _dietQuality,
                    workout: _workoutType,
                    date: _selectedDate,
                  );
                  // Refresh calendar dots after saving!
                  _refreshCalendarDots(); 
                },
                child: Text(
                  _hasExistingData ? "Update Daily Log" : "Save Daily Log", 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ),
            ),
            const SizedBox(height: 40), // Bottom padding so it doesn't hug the nav bar
          ],
        ),
      ),
    );
  }

  // Calendar Popup Function
  void _pickDate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder( // StatefulBuilder allows the calendar to update inside the modal
          builder: (context, setModalState) {
            return Container(
              height: 450,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(height: 16),
                  TableCalendar(
                    firstDay: DateTime.now().subtract(const Duration(days: 365)),
                    lastDay: DateTime.now(),
                    focusedDay: _selectedDate,
                    currentDay: _selectedDate, // Highlights the currently selected day
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                    
                    // checks if the day is in our database list
                    eventLoader: (day) {
                      final normalizedDay = DateTime(day.year, day.month, day.day);
                      // if it exists, pass the state string. else, empty list.
                      return _loggedDates.containsKey(normalizedDay) ? [_loggedDates[normalizedDay]] : []; 
                    },

                    // custom draw the dots based on the emotion
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (events.isEmpty) return const SizedBox(); // No events, no dot
                        
                        // Grab the emotion string we passed in the eventLoader
                        final stateString = events.first as String; 
                        final dotColor = _getColorForState(stateString);

                        return Positioned(
                          bottom: 4,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    // Styling to match theme
                    calendarStyle: CalendarStyle(
                      markerDecoration: const BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(color: Colors.teal.withOpacity(0.3), shape: BoxShape.circle),
                      selectedDecoration: const BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
                    ),
                    headerStyle: const HeaderStyle(titleCentered: true),
                    
                    onDaySelected: (selectedDay, focusedDay) async {
                      Navigator.pop(context); // Close the modal
                      setState(() {
                        _selectedDate = selectedDay;
                      });
                      await _loadDataForSelectedDate(); // Auto-fill the form!
                    },
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Color _getColorForState(String state) {
    switch (state.toLowerCase()) {
      case 'happy': return Colors.green;
      case 'proud': return Colors.purple;
      case 'tired': return Colors.orange;
      case 'gloomy': return Colors.blueGrey;
      case 'pending': return Colors.grey;
      default: return Colors.teal; // Fallback
    }
  }

}