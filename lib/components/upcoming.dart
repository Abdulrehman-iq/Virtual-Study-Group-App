import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Session {
  final String title;
  final String time;

  Session({
    required this.title,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'time': time,
      };

  static Session fromJson(Map<String, dynamic> json) {
    return Session(
      title: json['title'],
      time: json['time'],
    );
  }
}

class Upcoming extends StatefulWidget {
  const Upcoming({super.key});

  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  final List<Session> _sessions = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedSessions = prefs.getStringList('sessions') ?? [];

      setState(() {
        _sessions.clear();
        for (var sessionJson in savedSessions) {
          final map = json.decode(sessionJson) as Map<String, dynamic>;
          _sessions.add(Session.fromJson(map));
        }
      });
    } catch (e) {
      debugPrint('Error loading sessions: $e');
    }
  }

  Future<void> _saveSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedSessions =
          _sessions.map((session) => json.encode(session.toJson())).toList();
      await prefs.setStringList('sessions', encodedSessions);
    } catch (e) {
      debugPrint('Error saving sessions: $e');
    }
  }

  void _addSession() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Session Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _titleController.clear();
              _timeController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty &&
                  _timeController.text.isNotEmpty) {
                final newSession = Session(
                  title: _titleController.text,
                  time: _timeController.text,
                );

                setState(() {
                  _sessions.insert(0, newSession);
                });

                await _saveSessions();
                _titleController.clear();
                _timeController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSession(int index) async {
    setState(() {
      _sessions.removeAt(index);
    });
    await _saveSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Sessions'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSession,
        child: const Icon(Icons.add),
      ),
      body: _sessions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No upcoming sessions',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _sessions.length,
              itemBuilder: (context, index) {
                final session = _sessions[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Colors.blue),
                    title: Text(
                      session.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(session.time),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                      onPressed: () => _deleteSession(index),
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}
