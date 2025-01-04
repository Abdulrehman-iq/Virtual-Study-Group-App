import 'package:flutter/material.dart';

/// Global feed handler (can be replaced by any data storage)
class ActivityFeed {
  static final List<String> _feed = [];

  static void addEntry(String activity) {
    _feed.insert(0, activity);
    // Insert at index 0 to show the latest at the top
  }

  static List<String> getFeed() => _feed;
}

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  List<String> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    // In a real scenario, you might load this data asynchronously
    setState(() {
      _activities = ActivityFeed.getFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Activity'),
        elevation: 0,
      ),
      body: _activities.isEmpty
          ? const Center(
              child: Text(
                'No recent activities',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _activities.length,
              itemBuilder: (context, index) =>
                  _buildActivityItem(_activities[index], index),
            ),
    );
  }

  Widget _buildActivityItem(String activity, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text('U${index + 1}'),
        ),
        title: Text(activity),
        subtitle: const Text('Just now'),
      ),
    );
  }
}
