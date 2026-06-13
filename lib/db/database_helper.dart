import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/toto_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  final String tableName = "todos";

  Future<Database> get database async { 
    if (_database != null) return _database!; 
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE todos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            description TEXT NOT NULL,
            status INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
      onOpen: (db) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS todos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            description TEXT NOT NULL,
            status INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }
  // insert
  Future<int> insertData(Todo todo) async {
    final db = await instance.database;
    return await db.insert(tableName, todo.toMap());
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await instance.database;
    return await db.update(
      tableName,
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<List<Todo>> getAllTodo() async {
    final db = await instance.database;
    final result = await db.query(tableName, orderBy: 'id DESC');
    return result.map((map) => Todo.fromMap(map)).toList();
  }



}

 