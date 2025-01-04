import 'package:flutter/material.dart';

class Announcements extends StatefulWidget {
  const Announcements({super.key});

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  // A list to hold the announcements
  List<String> announcements = [
    'New Feature Available! Try our new virtual whiteboard feature in study rooms.',
    'Maintenance scheduled for Sunday, please plan accordingly.',
  ];

  // Controller to handle text input for adding new announcements
  final TextEditingController _announcementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Announcements',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _buildAnnouncementInput(),
        Expanded(child: _buildAnnouncementList()),
      ],
    );
  }

  // Widget for adding new announcements
  Widget _buildAnnouncementInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _announcementController,
              decoration: const InputDecoration(
                labelText: 'Add a new announcement',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addAnnouncement,
          ),
        ],
      ),
    );
  }

  // Widget for displaying the list of announcements
  Widget _buildAnnouncementList() {
    return ListView.builder(
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        return _buildAnnouncementCard(index);
      },
    );
  }

  // Widget for displaying an individual announcement card
  Widget _buildAnnouncementCard(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: Colors.orange[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Announcement ${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(announcements[index]),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteAnnouncement(index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to add a new announcement
  void _addAnnouncement() {
    if (_announcementController.text.isNotEmpty) {
      setState(() {
        announcements.add(_announcementController.text);
        _announcementController.clear();
      });
    }
  }

  // Function to delete an announcement
  void _deleteAnnouncement(int index) {
    setState(() {
      announcements.removeAt(index);
    });
  }
}
