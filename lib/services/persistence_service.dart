import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/task.dart';

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
            relationships TEXT
          )
          ''');
      },
    );
  }

  Future<void> addTask(Map<String, dynamic> row) async {
    await _db.insert(
        _table,
        row
    );
  }

  Future<List<Task>> getAllTasks() async {
    var response = await _db.query(_table);
    print(response);
    return response.map((e) => Task.fromJson(e)).toList();
  }

  // static Future<void> updateTask(Task task) async {
  //   final db = await PersistenceService.getDatabaseInstance();
  //   await db.update(
  //       'task',
  //       task.toJson(),
  //       where: "taskId = ?",
  //       whereArgs: [task.taskId])
  //   ;
  // }

  // static Future<Task?> getTask(String taskId) async {
  //   final db = await PersistenceService.getDatabaseInstance();
  //   var response = await _db.query(
  //       'task',
  //       where: "taskId = ?",
  //       whereArgs: [taskId]);
  //   return response.isNotEmpty ? Task.fromJson(response.first) : null;
  // }

}