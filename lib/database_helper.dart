import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';

class DatabaseHelper {
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'notes.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  final _controller = StreamController<List<Map<String, dynamic>>>.broadcast();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor() {
    _controller.onListen = () async {
      _controller.add(await fetchNotes());
    };
  }
  static final _databaseName = "NotesDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'notes_table';

  static final columnId = '_id';
  static final columnTitle = 'title';
  static final columnContent = 'content';
  static final columnDate = 'date';
  static final columnPinned = 'pinned';

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE notes_table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnContent TEXT NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnPinned INTEGER NOT NULL
            
          )
          ''');
  }

  Stream<List<Map<String, dynamic>>> get notesStream => _controller.stream;

  Future<int> saveNote(String title, String content) async {
    Database db = await instance.database;
    var date = DateTime.now().toIso8601String();
    int id = await db.insert('notes_table', {
      'title': title,
      'content': content,
      'date': date,
      'pinned': 0,
    });
    print('Saved note with id: $id, notes: '); // print statement

    _controller.add(await fetchNotes()); // emit a new event
    return id;
  }

  late Database _db;
  Future<List<Map<String, dynamic>>> fetchNotes() async {
      
    Database db = await instance.database;
    return await db.query('notes_table');
  }

  Future<int> updateNote(int id, String title, String content, int isPinned) async {
    
    Database db = await instance.database;
    
    db.update(
      'notes_table',
      {
        'title': title,
        'content': content,
        'date': DateTime.now().toIso8601String(),
        'pinned': isPinned,
      },
      where: '_id = ?',
      whereArgs: [id],
    );
  _controller.add(await fetchNotes());
 
    return id;
  }
  Future<int> delete(int id) async {
    Database db = await instance.database;
    int result = await db.delete('notes_table', where: '_id = ?', whereArgs: [id]);
    _controller.add(await fetchNotes());
    return result;
  }
}
