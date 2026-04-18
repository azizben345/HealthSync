import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/database/app_database.dart';
import '../../../data/services/sync_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../theme/theme_provider.dart';

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
          const SizedBox(height: 8),
          
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
                  onTap: _isSyncing ? null : _handleBackup,
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
                            child: const Text("Restore", style: TextStyle(color: Colors.red))
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
                        
                        // 1. Wipe the Communal Whiteboard (Daily Records AND Chat History)
                        final db = context.read<AppDatabase>();
                        await db.clearAllDailyRecords();
                        await db.clearChatHistory();
                        
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
}