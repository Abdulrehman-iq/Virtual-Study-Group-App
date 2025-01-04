import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum MessageType { text, image }

class ChatMessage {
  final MessageType type;
  final String content;
  final String sender;
  final DateTime timestamp;

  ChatMessage({
    required this.type,
    required this.content,
    required this.sender,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'content': content,
        'sender': sender,
        'timestamp': timestamp.toIso8601String(),
      };

  static ChatMessage fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      type: json['type'] == 'MessageType.text'
          ? MessageType.text
          : MessageType.image,
      content: json['content'],
      sender: json['sender'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class StudyRoom extends StatefulWidget {
  const StudyRoom({super.key});

  @override
  _StudyRoomState createState() => _StudyRoomState();
}

class _StudyRoomState extends State<StudyRoom> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final List<String> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ---------------------------
  // SharedPreferences Operations
  // ---------------------------
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load messages
    final savedMessages = prefs.getStringList('messages') ?? [];
    _messages.clear();
    for (var msgJson in savedMessages) {
      final jsonMap = json.decode(msgJson) as Map<String, dynamic>;
      _messages.add(ChatMessage.fromJson(jsonMap));
    }

    // Load notes
    final savedNotes = prefs.getStringList('notes') ?? [];
    _notes.clear();
    _notes.addAll(savedNotes);

    setState(() {});
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedMessages =
        _messages.map((msg) => json.encode(msg.toJson())).toList();
    await prefs.setStringList('messages', encodedMessages);
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes', _notes);
  }

  // ---------------------------
  // UI Actions
  // ---------------------------
  Future<void> _pickAndShareImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _messages.add(
          ChatMessage(
            type: MessageType.image,
            content: image.path,
            sender: "User",
            timestamp: DateTime.now(),
          ),
        );
      });
      await _saveMessages();
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessage(
          type: MessageType.text,
          content: _messageController.text,
          sender: "User",
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
    });
    await _saveMessages();
  }

  void _saveNote() async {
    if (_noteController.text.isEmpty) return;
    setState(() {
      _notes.add(_noteController.text);
      _noteController.clear();
    });
    await _saveNotes();
  }

  void _deleteNote(int index) async {
    setState(() {
      _notes.removeAt(index);
    });
    await _saveNotes();
  }

  // ---------------------------
  // Build Method
  // ---------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Room'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Card(
                margin: const EdgeInsets.all(8),
                elevation: 4,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return Align(
                            alignment: message.sender == "User"
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6,
                              ),
                              decoration: BoxDecoration(
                                color: message.sender == "User"
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (message.type == MessageType.text)
                                    Text(
                                      message.content,
                                      style: TextStyle(
                                        color: message.sender == "User"
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    )
                                  else
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(message.content),
                                        width: 200,
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('HH:mm')
                                        .format(message.timestamp),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: message.sender == "User"
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, -2),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: _sendMessage,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.image,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: _pickAndShareImage,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(8),
                elevation: 4,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        children: [
                          const Icon(Icons.note, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Notes',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _notes.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            child: ListTile(
                              title: Text(_notes[index]),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteNote(index),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, -2),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _noteController,
                            decoration: InputDecoration(
                              hintText: 'Take a note...',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _saveNote,
                            icon: const Icon(Icons.save),
                            label: const Text('Save Note'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
