// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskRelationship _$TaskRelationshipFromJson(Map<String, dynamic> json) =>
    TaskRelationship(
      json['taskId'] as String,
      json['relationshipType'] as String,
    );

Map<String, dynamic> _$TaskRelationshipToJson(TaskRelationship instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'relationshipType': instance.relationshipType,
    };
