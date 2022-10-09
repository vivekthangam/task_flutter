import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Task.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();
  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TaskDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Task ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "note TEXT,"
          "status TEXT,"
          "type TEXT,"
          "start_time TEXT,"
          "end_time TEXT"
          ")");
    });
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    List<Map> results =
        await db!.query("Task", columns: Task.columns, orderBy: "id ASC");
    List<Task> tasks = [];
    results.forEach((result) {
      Task task = Task.fromMap(result as Map<String, dynamic>);
      tasks.add(task);
    });
    return tasks;
  }

  Future<Object> getTaskById(int id) async {
    final db = await database;
    var result = await db!.query("Task", where: "id = ", whereArgs: [id]);
    return result.isNotEmpty ? Task.fromMap(result.first) : Null;
  }

  insert(Task task) async {
    final db = await database;
    var maxIdResult =
        await db!.rawQuery("SELECT MAX(id)+1 as last_inserted_id FROM Task");
    var id = maxIdResult.first["last_inserted_id"];
    var result = await db.rawInsert(
        "INSERT Into Task (id, name, note, status, type, start_time, end_time )"
        " VALUES (?, ?, ?, ?, ?, ?, ?)",
        [
          id,
          task.name,
          task.note,
          task.status,
          task.type,
          task.startTime,
          task.endTime
        ]);
    return result;
  }

  update(Task task) async {
    final db = await database;
    var result = await db!
        .update("Task", task.toMap(), where: "id = ?", whereArgs: [task.id]);
    return result;
  }

  delete(int id) async {
    final db = await database;
    db!.delete("Task", where: "id = ?", whereArgs: [id]);
  }
}
