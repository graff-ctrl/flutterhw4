import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../constants/status.dart' as status;
import '../model/task.dart';

/// A service to mimic a backend id generation. A task would
/// ideally be stored with a unique id to avoid collisions.
class TaskId {

  static String generateTaskId(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static Task generateTestTask(String name) {
    late String title = "Test $name";
    const String description = "Test Description";

    return Task(
        title: title,
        description: description,
        lastUpdated: DateTime.now(),
        status: status.open,
        taskId: TaskId.generateTaskId(title + DateTime.now().toString()),
        imageUrl: "holder",
        relationships: null
        );
  }
}