import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';
class DatabaseHelper{
  DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'notes.db');
    return await openDatabase(path,
        version: 1, onCreate: _onCreate);
  }
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static final _databaseName = "NotesDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'notes_table';

  static final columnId = '_id';
  static final columnTitle = 'title'; 
  static final columnContent = 'content'; 
  static final columnDate = 'date';
  static final columnPinned = 'pinned';

  

  Future<void> init() async{
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
  final _controller = StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get notesStream => _controller.stream;

  Future<int> saveNote(String title, String content) async {
    Database db = await instance.database;
    var date = DateTime.now().toIso8601String();
    int id = await db.insert('notes_table', {'title': title, 'content': content, 'date': date, 'pinned': 0,});
    print('Saved note with id: $id, notes: '); // print statement
  
    _controller.add(await fetchNotes()); // emit a new event
    return id;
  }
  // Future<int> saveNote(String title, String content) async {
  //   Database db = await instance.database;
  //   var date = DateTime.now().toIso8601String();
  //   return await db.insert('notes_table', {'$columnTitle': title, ' $columnContent': content, ' $columnDate': date, '$columnPinned': 0,});
  // }
  late Database _db;
Future<List<Map<String, dynamic>>> fetchNotes() async {
  Database db = await instance.database;
  return await db.query('notes_table');
}

//   Future<List<Map<String, dynamic>>> queryAllRows() async {
//     return await _db.query(table);
//   }
//   Future<int> queryRowCount() async {
//     final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
//     return Sqflite.firstIntValue(results) ?? 0;
//   }
//   Future<int> update(Map<String, dynamic> row) async {
//     int id = row[columnId];
//     return await _db.update(
//       table,
//       row,
//       where: '$columnId = ?',
//       whereArgs: [id],
//     );
//   }
//   Future<int> insert(Map<String, dynamic> row) async {
//     return await _db.insert(table, row);
//   }
//   Future<int> saveNote(String title, String content) async {
//   var dbClient = await _db;
//   var result = await dbClient.insert(
//     'notes_table',
//     {'title': title, 'content': content},
//   );
//   return result;
  
// }

}