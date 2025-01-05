import 'package:flutter/material.dart';
import '../components/study_rooms.dart';
import '../components/upcoming.dart';
import '../components/activity.dart';
import '../components/announcements.dart';
import '../components/subjects.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget _currentScreen = const _WelcomeScreen();

  void _selectScreen(Widget screen) {
    setState(() => _currentScreen = screen);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Dashboard'),
        elevation: 0,
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade900, Colors.blue.shade600],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 35, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Study Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Virtual Learning Space',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _currentScreen,
      ),
    );
  }
}

class _WelcomeScreen extends StatelessWidget {
  const _WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade900, Colors.blue.shade600],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: _DashboardCard(
                      title: 'Study Rooms',
                      subtitle: '5 Active Sessions',
                      icon: Icons.groups,
                      color: Colors.indigo,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StudyRoom()),
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: _DashboardCard(
                      title: 'Upcoming Events',
                      subtitle: '3 Events Today',
                      icon: Icons.event,
                      color: Colors.orange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Upcoming()),
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: _DashboardCard(
                      title: 'Activity',
                      subtitle: 'View Progress',
                      icon: Icons.timeline,
                      color: Colors.green,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Activity()),
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: _DashboardCard(
                      title: 'Programming',
                      subtitle: '8 Courses',
                      icon: Icons.code,
                      color: Colors.purple,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SubjectsScreen()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Latest Announcements',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _AnnouncementItem(
                          title: 'New Study Room Feature',
                          description:
                              'Share your screen during study sessions',
                          date: 'Today',
                          icon: Icons.new_releases,
                        ),
                        const Divider(height: 1),
                        _AnnouncementItem(
                          title: 'Upcoming Maintenance',
                          description: 'System update scheduled for tomorrow',
                          date: 'Yesterday',
                          icon: Icons.engineering,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnnouncementItem extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final IconData icon;

  const _AnnouncementItem({
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Icon(icon, color: Colors.blue.shade900),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(description),
      trailing: Text(
        date,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
    );
  }
}
