import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/task.dart';

/// Data persistence service for raising state throughtout app startup.
class PersistenceService {

  static const _dbName = 'TasksApp.db';
  static const _dbVersion = 1;
  static const _table = 'tasks';

  late Database _db;

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_table (
            taskId TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            lastUpdated TEXT,
            status TEXT,
            imageUrl TEXT,
            relationships TEXT
          )
          ''');
      },
    );
  }

  Future<void> addTask(Task row) async {
    await _db.insert(
        _table,
        row.toJson()
    );
  }

  Future<List<Task>> getAllTasks() async {
    var response = await _db.query(_table);
    return response.map((e) => Task.fromJson(e)).toList();
  }

   Future<void> updateTask(Task task) async {
    await _db.update(
        _table,
        task.toJson(),
        where: "taskId = ?",
        whereArgs: [task.taskId])
    ;
  }

  Future<void> deleteAllTasks() async {
    await _db.delete(_table);
  }
}