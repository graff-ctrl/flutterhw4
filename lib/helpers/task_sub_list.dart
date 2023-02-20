import 'dart:core';

import '../model/relationship_list_item.dart';
import '../model/task_relationship.dart';
import '../model/task.dart';

class TaskSubList {
  /// Helper class for filtering items from all tasks that are related.
  static List<RelationshipListItem> filter(List<dynamic> relationships, List<Task> tasks) {
    List<RelationshipListItem> result = [];
    Task item;
    for (var r in relationships) {
      item = tasks.firstWhere((element) => element.taskId == r.taskId);
      result.add(RelationshipListItem(item, r));
    }
    return result;
  }
}