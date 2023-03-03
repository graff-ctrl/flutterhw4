
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutterhw4/main.dart';

import '../../model/task.dart';

class TaskService {
  final taskChild = 'tasks';

  Future<void> addTask(Task t) async {
    firebaseDBService.createData(
        taskChild,
        t.toJson());
  }

  Future<List<Task>?> fetchTasks() async {
    final Map<dynamic, dynamic> map = await firebaseDBService.fetchData(taskChild) as Map;
    final list = map.values.toList();
    return list.map((e) => Task.fromJson(e)).toList();
  }

}