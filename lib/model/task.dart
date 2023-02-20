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

  // These deviate from the required json mapping due to sqflite unable to
  // store lists. See
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}