import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../avatar/controller/avatar_controller.dart';
import 'package:lottie/lottie.dart';

class InputView extends StatefulWidget {
  const InputView({super.key});

  @override
  State<InputView> createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  // Local state for the sliders/text
  double _steps = 5000;
  double _sleep = 7;
  final TextEditingController _diaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // This "watches" the controller for any changes
    final avatarCtrl = context.watch<AvatarController>();

    return Scaffold(
      appBar: AppBar(title: const Text("FYP Avatar Demo")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- AVATAR PLACEHOLDER ---
            // Container(
            //   height: 200,
            //   width: 200,
            //   decoration: BoxDecoration(
            //     color: _getMoodColor(avatarCtrl.avatarState),
            //     shape: BoxShape.circle,
            //   ),
            //   child: Center(
            //     child: avatarCtrl.isLoading 
            //       ? const CircularProgressIndicator(color: Colors.white)
            //       : Text(
            //           avatarCtrl.avatarState.toUpperCase(),
            //           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            //         ),
            //   ),
            // ),
            // --- AVATAR VISUAL/ANIMATION ---
            SizedBox(
              height: 200,
              width: 200,
              child: avatarCtrl.isLoading 
                ? const Center(child: CircularProgressIndicator()) // Show spinner while Gemini thinks
                : Lottie.asset(
                    // dynamically loads the file based on Gemini's state!
                    'assets/animations/${avatarCtrl.avatarState}.json', 
                    fit: BoxFit.contain,
                    // maybe add an error builder just in case you spell a file name wrong
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text("Animation not found", style: TextStyle(color: Colors.red)),
                      );
                    },
                  ),
            ),
            const SizedBox(height: 10),
            Text(avatarCtrl.coachMessage, textAlign: TextAlign.center, 
                 style: const TextStyle(fontStyle: FontStyle.italic)),
            
            const Divider(height: 40),

            // --- INPUTS ---
            Text("Steps Walked: ${_steps.toInt()}"),
            Slider(
              value: _steps,
              min: 0,
              max: 20000,
              onChanged: (val) => setState(() => _steps = val),
            ),

            Text("Hours Slept: ${_sleep.toStringAsFixed(1)}"),
            Slider(
              value: _sleep,
              min: 0,
              max: 12,
              onChanged: (val) => setState(() => _sleep = val),
            ),

            TextField(
              controller: _diaryController,
              decoration: const InputDecoration(
                labelText: "How was your day?",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            // --- THE SYNC BUTTON ---
            ElevatedButton(
              onPressed: avatarCtrl.isLoading 
                ? null 
                : () {
                    avatarCtrl.updateAvatarLogic(
                      steps: _steps.toInt(),
                      sleep: _sleep,
                      diary: _diaryController.text,
                    );
                  },
              child: const Text("Sync with AI Avatar"),
            ),
          ],
        ),
      ),
    );
  }

  // Simple logic to change color based on state for now
  Color _getMoodColor(String state) {
    switch (state.toLowerCase()) {
      case 'happy': return Colors.green;
      case 'tired': return Colors.orange;
      case 'gloomy': return Colors.blueGrey;
      case 'proud': return Colors.purple;
      default: return Colors.grey;
    }
  }
}