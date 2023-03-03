import 'package:flutter/foundation.dart';
import 'package:flutterhw4/main.dart';
import 'package:flutterhw4/services/task/task_service.dart';
import '../../../model/task.dart';

class TaskListModel extends ChangeNotifier {
  TaskService taskService = TaskService();
  List<Task> _tasks = [];
  // Returns course list
  List<Task> get tasks => _tasks;

  Future<void> loadProvider() async {
    var cache = await localCacheService.getAllTasks();
    var cloud = await taskService.fetchTasks();
    _tasks = cache;
    _tasks.addAll(cloud!);
    notifyListeners();
  }

  void addTaskToCache(Task task) {
    localCacheService.addTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  void postTask(Task task) {
    taskService.addTask(task);
    _tasks.add(task);
    notifyListeners();
  }

//add new task and notify
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

}