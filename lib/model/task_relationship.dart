import 'package:json_annotation/json_annotation.dart';

part 'task_relationship.g.dart';

@JsonSerializable()
class TaskRelationship {
  /// Class for storing a task id and relationship type to the containing task object
  String taskId;
  String relationshipType;

  TaskRelationship(this.taskId, this.relationshipType);
  factory TaskRelationship.fromJson(Map<String, dynamic> json) => _$TaskRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$TaskRelationshipToJson(this);
}