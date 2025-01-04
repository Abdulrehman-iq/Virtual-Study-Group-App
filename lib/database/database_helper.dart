import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

// Database helper class
class DatabaseHelper {
  static Database? _database;

  // Singleton pattern for DatabaseHelper
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'studyroom.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE messages(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT,
            content TEXT,
            sender TEXT,
            timestamp TEXT)''');
        db.execute('''CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            note TEXT)''');
      },
      version: 1,
    );
  }

  // Insert a message into the database
  static Future<void> insertMessage(Map<String, dynamic> message) async {
    final db = await database;
    await db.insert(
      'messages',
      message,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all messages from the database
  static Future<List<Map<String, dynamic>>> getMessages() async {
    final db = await database;
    return await db.query('messages');
  }

  // Insert a note into the database
  static Future<void> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    await db.insert(
      'notes',
      note,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all notes from the database
  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query('notes');
  }

  // Delete a note by ID
  static Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
