import 'package:flutter/material.dart';
import '../components/study_rooms.dart';
import '../components/upcoming.dart';
import '../components/activity.dart';
import '../components/announcements.dart';
import '../components/subjects.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Default screen
  Widget _currentScreen = const _WelcomeScreen();

  // Drawer navigation
  void _selectScreen(Widget screen) {
    setState(() => _currentScreen = screen);
    Navigator.pop(context); // Close drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => _selectScreen(const _WelcomeScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Study Rooms'),
              onTap: () => _selectScreen(const StudyRoom()),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Upcoming'),
              onTap: () => _selectScreen(const Upcoming()),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Activity'),
              onTap: () => _selectScreen(const Activity()),
            ),
            ListTile(
              leading: const Icon(Icons.announcement),
              title: const Text('Announcements'),
              onTap: () => _selectScreen(const Announcements()),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('Programming Courses'),
              onTap: () => _selectScreen(const SubjectsScreen()),
            ),
          ],
        ),
      ),
      body: _currentScreen,
    );
  }
}

// Simple welcome screen placeholder
class _WelcomeScreen extends StatelessWidget {
  const _WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Welcome to the Dashboard',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
