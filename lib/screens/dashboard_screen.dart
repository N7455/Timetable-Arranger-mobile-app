import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'manage_screen.dart';
import 'timetable_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Classes & Sections', Icons.school, 'classes'),
      ('Teachers', Icons.person, 'teachers'),
      ('Subjects', Icons.menu_book, 'subjects'),
      ('Rooms / Labs', Icons.meeting_room, 'rooms'),
      ('Time Slots', Icons.schedule, 'slots'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Setup',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...items.map((e) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.redAccent.withOpacity(.15),
                    child: Icon(e.$2, color: Colors.redAccent),
                  ),
                  title: Text(e.$1),
                  subtitle: const Text('Add and manage data'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ManageScreen(
                        title: e.$1,
                        collection: e.$3,
                      ),
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 18),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.auto_awesome, color: Colors.redAccent),
              ),
              title: const Text('Generate Timetable'),
              subtitle: const Text('Automatically arrange lectures'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimetableScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
