import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class StudyRoom extends StatefulWidget {
  @override
  _StudyRoomState createState() => _StudyRoomState();
}

class _StudyRoomState extends State<StudyRoom> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final List<String> _notes = [];

  Future<void> _pickAndShareImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _messages.add(ChatMessage(
          type: MessageType.image,
          content: image.path,
          sender: "User",
        ));
      });
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          type: MessageType.text,
          content: _messageController.text,
          sender: "User",
        ));
        _messageController.clear();
      });
    }
  }

  void _saveNote() {
    if (_noteController.text.isNotEmpty) {
      setState(() {
        _notes.add(_noteController.text);
        _noteController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Study Room')),
      body: Row(
        children: [
          // Chat and Image Section
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _messages[index].type == MessageType.text
                          ? ListTile(
                              title: Text(_messages[index].content),
                              subtitle: Text(_messages[index].sender),
                            )
                          : Image.file(File(_messages[index].content));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: _pickAndShareImage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Notes Section
          Expanded(
            child: Column(
              children: [
                Text('Notes', style: Theme.of(context).textTheme.titleLarge),
                Expanded(
                  child: ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(_notes[index]),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _noteController,
                        decoration: InputDecoration(
                          hintText: 'Take a note...',
                        ),
                        maxLines: 3,
                      ),
                      ElevatedButton(
                        onPressed: _saveNote,
                        child: Text('Save Note'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum MessageType { text, image }

class ChatMessage {
  final MessageType type;
  final String content;
  final String sender;

  ChatMessage({
    required this.type,
    required this.content,
    required this.sender,
  });
}
