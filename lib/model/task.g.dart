// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      json['title'] as String,
      json['description'] as String?,
      DateTime.parse(json['lastUpdated'] as String),
      json['status'] as String,
      json['taskId'] as String,
      (jsonDecode(json['relationships']) as List<dynamic>)
          .map((e) => TaskRelationship.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'status': instance.status,
      'taskId': instance.taskId,
      'relationships': jsonEncode(instance.relationships.map((e) => e.toJson()).toList()),
    };
