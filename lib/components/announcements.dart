import 'package:flutter/material.dart';

class Announcements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Announcements',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _buildAnnouncementCard(),
      ],
    );
  }

  Widget _buildAnnouncementCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: Colors.orange[50],
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Feature Available!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text('Try our new virtual whiteboard feature in study rooms.'),
            ],
          ),
        ),
      ),
    );
  }
}
