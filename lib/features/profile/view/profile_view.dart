import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controller/goal_provider.dart';
import '../../../data/database/app_database.dart';
import '../../../data/services/sync_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../theme/theme_provider.dart';
import 'goal_settings_view.dart' show GoalSettingsView;

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final User? currentUser = AuthService().currentUser;
  bool _isSyncing = false;

  Future<void> _handleBackup() async {
    setState(() => _isSyncing = true);
    try {
      await SyncService(context.read<AppDatabase>()).backupToCloud();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Backup successful!"), backgroundColor: Colors.green));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Backup failed: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isSyncing = true);
    try {
      await SyncService(context.read<AppDatabase>()).restoreFromCloud();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data restored from cloud!"), backgroundColor: Colors.green));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Restore failed: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile & Settings"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User Info Card
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text("Logged in as"),
              subtitle: Text(currentUser?.email ?? "Unknown User"),
            ),
          ),
          const SizedBox(height: 24),

          const Text("Daily Targets", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Consumer<GoalProvider>(
            builder: (context, goalProvider, child) {
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.flag),
                      title: const Text("Goal Settings"),
                      trailing: _isSyncing ? const CircularProgressIndicator() : const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GoalSettingsView()),
                        );
                      },
                    ),
                    // ListTile(
                    //   leading: const Icon(Icons.directions_walk, color: Colors.teal),
                    //   title: const Text("Step Goal"),
                    //   trailing: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Text("${goalProvider.stepGoal} steps", style: const TextStyle(fontWeight: FontWeight.bold)),
                    //       const Icon(Icons.chevron_right, color: Colors.grey),
                    //     ],
                    //   ),
                    //   onTap: () => _showEditStepGoalDialog(context, goalProvider),
                    // ),
                    // const Divider(height: 1),
                    // ListTile(
                    //   leading: const Icon(Icons.bedtime, color: Colors.indigo),
                    //   title: const Text("Sleep Goal"),
                    //   trailing: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Text("${goalProvider.sleepGoal} hrs", style: const TextStyle(fontWeight: FontWeight.bold)),
                    //       const Icon(Icons.chevron_right, color: Colors.grey),
                    //     ],
                    //   ),
                    //   onTap: () => _showEditSleepGoalDialog(context, goalProvider),
                    // ),
                  ],
                ),
              );
            }
          ),
          const SizedBox(height: 24),

          const Text("App Settings", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                // dark mode toggler
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return SwitchListTile(
                      title: const Text("Dark Mode"),
                      secondary: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.teal),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                    );
                  }
                ),
                // const Divider(height: 1),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          const Text("Cloud Synchronization", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          
          // Sync Controls Card
          Card(
            child: Column(
              children: [

                ListTile(
                  leading: const Icon(Icons.cloud_upload, color: Colors.blue),
                  title: const Text("Backup to Cloud"),
                  subtitle: const Text("Save your local data to your account"),
                  trailing: _isSyncing ? const CircularProgressIndicator() : const Icon(Icons.chevron_right),
                  onTap: _isSyncing ? null : () {
                    // Always confirm before overwriting cloud data
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Backup Data?"),
                        content: const Text("This will overwrite current cloud data with your local data. Are you sure?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _handleBackup();
                            }, 
                            child: const Text("Backup", style: TextStyle(color: Colors.orange))
                          ),
                        ],
                      )
                    );
                  }
                ),
                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.cloud_download, color: Colors.green),
                  title: const Text("Restore from Cloud"),
                  subtitle: const Text("Overwrite local data with cloud backup"),
                  trailing: _isSyncing ? const CircularProgressIndicator() : const Icon(Icons.chevron_right),
                  onTap: _isSyncing ? null : () {
                    // Always confirm before overwriting local data
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Restore Data?"),
                        content: const Text("This will erase your current offline data and replace it with your cloud backup. Are you sure?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _handleRestore();
                            }, 
                            child: const Text("Restore", style: TextStyle(color: Colors.orange))
                          ),
                        ],
                      )
                    );
                  },
                ),

              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Logout Button with Safety Warning
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16)
            ),
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Wait! Did you sync?"),
                  content: const Text(
                    "Logging out will erase this device's offline data to protect your privacy. "
                    "Make sure you have backed up to the cloud first!"
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), 
                      child: const Text("Cancel")
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context); // Close dialog
                        
                        // // 1. Wipe the Communal Whiteboard (Daily Records AND Chat History)
                        // // comment out during authentication testing
                        // final db = context.read<AppDatabase>();
                        // await db.clearAllDailyRecords();
                        // await db.clearChatHistory();
                        
                        // 2. Hand back the keycard (Log out)
                        await AuthService().signOut();
                      }, 
                      child: const Text("Wipe & Logout", style: TextStyle(color: Colors.red))
                    ),
                  ],
                )
              );
            },
          )
        ],
      ),
    );
  }

  void _showEditStepGoalDialog(BuildContext context, GoalProvider provider) {
    final TextEditingController ctrl = TextEditingController(text: provider.stepGoal.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Set Step Goal"),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "e.g., 10000"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          FilledButton(
            onPressed: () {
              final newGoal = int.tryParse(ctrl.text);
              if (newGoal != null && newGoal > 0) {
                provider.updateStepGoal(newGoal);
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showEditSleepGoalDialog(BuildContext context, GoalProvider provider) {
    double tempSleep = provider.sleepGoal;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Set Sleep Goal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${tempSleep.toStringAsFixed(1)} hours", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Slider(
                value: tempSleep,
                min: 4,
                max: 12,
                divisions: 16,
                onChanged: (val) => setState(() => tempSleep = val),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            FilledButton(
              onPressed: () {
                provider.updateSleepGoal(tempSleep);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

}