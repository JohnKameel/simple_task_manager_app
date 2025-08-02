import 'package:sqflite/sqflite.dart';

class SqfLiteHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      print('Db is already open');
      return _database!;
    }
    _database = await startDb();
    print('db is open');
    return _database!;
  }

  Future<Database> startDb() async {
    final dbPath = await getDatabasesPath();
    final currentPath = '$dbPath/mytasks.db';

    return await openDatabase(currentPath, version: 1,
        onCreate: (db, version) async {
          return await db.execute('''
          CREATE TABLE tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          dec TEXT,
          isCompleted INTEGER NOT NULL DEFAULT 0
          )
          ''');
        });
  }

  Future<void> insertTask(String title, String dec) async {
    Database db = await database;
    await db.insert("tasks", {'title': title, 'dec': dec, 'isCompleted': 0});
  }

  Future<void> updateTask(int id, String title, String dec) async {
    final db = await database;
    await db.update(
      "tasks",
      {'title': title, 'dec': dec},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleTaskCompletion(int id, int isCompleted) async {
    Database db = await database;
    await db.update(
      "tasks",
      {'isCompleted': isCompleted == 0 ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTask(int id) async {
    Database db = await database;
    await db.delete("tasks", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllTasks() async {
    final db = await database;
    return await db.delete("tasks");
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    Database db = await database;
    return await db.query("tasks");
  }
}
