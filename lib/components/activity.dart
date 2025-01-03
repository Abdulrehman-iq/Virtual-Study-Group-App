import 'package:flutter/material.dart';

class Activity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Recent Activity',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) => _buildActivityItem(index),
        ),
      ],
    );
  }

  Widget _buildActivityItem(int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text('U${index + 1}'),
      ),
      title: Text('User ${index + 1} joined Math Group'),
      subtitle: Text('2 hours ago'),
    );
  }
}
