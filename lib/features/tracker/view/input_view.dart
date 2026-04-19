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

  // keep track of which day users are logging for (defaults to today)
  DateTime _selectedDate = DateTime.now();
  // flag to track either updating existing data or creating new data
  bool _hasExistingData = false;
  // set of dates to tell the calendar where to draw dots - indicated logged dates
  Set<DateTime> _loggedDates = {};

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
      }
    });
  }

  // fetch list of dates from database
  Future<void> _refreshCalendarDots() async {
    final db = context.read<AppDatabase>();
    final dates = await db.getAllLoggedDates();
    setState(() {
      // Normalize them so they match the calendar perfectly
      _loggedDates = dates.map((d) => DateTime(d.year, d.month, d.day)).toSet();
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
                    Text("Ready to sync?", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
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
                            date: _selectedDate,
                          );
                        },
                        child: Text(
                          _hasExistingData ? "Update Daily Log" : "Save Daily Log", 
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),
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
                    
                    // THIS IS THE MAGIC: It checks if the day is in our database list
                    eventLoader: (day) {
                      final normalizedDay = DateTime(day.year, day.month, day.day);
                      return _loggedDates.contains(normalizedDay) ? ['Logged'] : [];
                    },
                    
                    // Styling to make it match your theme
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

}