import 'package:flutter/material.dart';

class Upcoming extends StatelessWidget {
  final List<Map<String, String>> sessions = [
    {'title': 'Physics Study Group', 'time': 'Today, 4:00 PM'},
    {'title': 'Math Review Session', 'time': 'Tomorrow, 2:00 PM'},
    {'title': 'History Discussion', 'time': 'Friday, 5:00 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return _buildSessionCard(session['title']!, session['time']!);
          },
        ),
      ],
    );
  }

  Widget _buildSessionCard(String title, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Icon(Icons.event, color: Colors.blue),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(time),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Add navigation or action for session card
          },
        ),
      ),
    );
  }
}
