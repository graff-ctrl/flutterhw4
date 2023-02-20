import 'dart:convert';

import '../model/task_relationship.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable(explicitToJson: true)
class Task {
  /// Data class for Task that store the title, description, lastUpdated
  /// and status.
  String title;
  String? description;
  DateTime lastUpdated;
  String status;
  String taskId;
  List<TaskRelationship> relationships;

  Task(
      this.title,
      this.description,
      this.lastUpdated,
      this.status,
      this.taskId,
      List<TaskRelationship>? relationships
      ) : relationships = relationships ?? <TaskRelationship>[];

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  static Task fromSQLite(Map<String, dynamic> json) {
    return _$TaskFromJson(json);
  }

  Map<String, dynamic> toSQLite() {
    var response = _$TaskToJson(this);
    response['relationships'] = jsonEncode(response['relationships']);
    return response;
  }

}