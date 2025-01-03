import 'package:flutter/material.dart';
import '../components/study_rooms.dart';
import '../components/upcoming.dart';
import '../components/activity.dart';
import '../components/announcements.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget _currentScreen = _WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Virtual Study Group',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Learn Together, Grow Together',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.groups,
              title: 'Study Rooms',
              onTap: () => _updateScreen(StudyRooms()),
            ),
            _buildDrawerItem(
              icon: Icons.event,
              title: 'Upcoming Sessions',
              onTap: () => _updateScreen(Upcoming()),
            ),
            _buildDrawerItem(
              icon: Icons.history,
              title: 'Recent Activity',
              onTap: () => _updateScreen(Activity()),
            ),
            _buildDrawerItem(
              icon: Icons.announcement,
              title: 'Announcements',
              onTap: () => _updateScreen(Announcements()),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _currentScreen,
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
    );
  }

  void _updateScreen(Widget screen) {
    setState(() {
      _currentScreen = screen;
    });
  }
}

class _WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school,
            size: 80,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 24),
          Text(
            'Welcome to Virtual Study Group',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Open the menu to explore study resources,\njoin rooms, and connect with peers',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
