import 'package:flutter/material.dart';
import 'package:healthsync_demo_v01_00/features/chat/view/chat_view.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_demo_v01_00/features/history/controller/history_controller.dart';
import '../../tracker/view/input_view.dart';
import '../../history/view/history_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // 1. The list now only contains the actual Widgets (the screens themselves).
  // No functions are allowed in this list!
  final List<Widget> _screens = [
    const InputView(),     // left tab (Index 0)
    const HistoryView(),   // middle tab (Index 1)
    const ChatView(),      // right tab (Index 2)
    // const Scaffold(        // right tab (Index 2) - placeholder view
    //   body: Center(
    //     child: Text("💬 AI Coach Chatbot\n(Coming Soon!)", textAlign: TextAlign.center),
    //   ),
    // ), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack preserves the state of the pages when switching tabs!
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      
      // NavigationBar is the modern, Material 3 standard for bottom tabs
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        // 2. We make this function async so we can wait for the database
        onDestinationSelected: (int index) async {
          
          // 3. If the user clicks the "Logs" tab (Index 1), refresh the data first
          if (index == 1) {
            await context.read<HistoryController>().loadRecords();
          }

          // 4. Then, update the UI to show the selected tab
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined), 
            selectedIcon: Icon(Icons.home), 
            label: 'Home'
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_view_day_outlined), 
            selectedIcon: Icon(Icons.calendar_view_day), 
            label: 'Logs'
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline), 
            selectedIcon: Icon(Icons.chat_bubble), 
            label: 'Coach'
          ),
        ],
      ),
    );
  }
}