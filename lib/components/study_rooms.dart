import 'package:flutter/material.dart';

class StudyRooms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Active Study Rooms',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: 3,
            itemBuilder: (context, index) => _buildRoomCard(index),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomCard(int index) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text('Calculus Group ${index + 1}'),
        subtitle: Text('4 members active'),
        leading: Icon(Icons.group, color: Colors.blue),
      ),
    );
  }
}
