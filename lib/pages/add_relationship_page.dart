import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/relationship.dart';
import '../model/task_details_model.dart';
import '../widgets/widget_label.dart';
import '../model/task_relationship.dart';

class AddRelationshipPage extends StatelessWidget {
  final TaskDetailsModel taskModel;

  const AddRelationshipPage({super.key, required this.taskModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("Add Sub-task")
    ),
    body: Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: taskModel.allTasks.length,
                itemBuilder: (context, index) {
                  final task = taskModel.allTasks[index];
                  return Card(
                    child: ListTile (
                      title: Text(taskModel.allTasks[index].title),
                      onTap: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 300,
                                color: Colors.white,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const WidgetLabel(text: 'Select Relationship'),
                                      ElevatedButton(
                                        child: const Text(RelationshipType.clones),
                                        onPressed: () {
                                          addRelationship(taskModel.task.relationships, task.taskId, RelationshipType.clones);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ElevatedButton(
                                        child: const Text(RelationshipType.blocks),
                                        onPressed: () {
                                          addRelationship(taskModel.task.relationships, task.taskId, RelationshipType.blocks);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ElevatedButton(
                                        child: const Text(RelationshipType.child),
                                        onPressed: () {
                                          addRelationship(taskModel.task.relationships, task.taskId, RelationshipType.child);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ElevatedButton(
                                        child: const Text(RelationshipType.parent),
                                        onPressed: () {
                                          addRelationship(taskModel.task.relationships, task.taskId, RelationshipType.parent);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ElevatedButton(
                                        child: const Text(RelationshipType.depends),
                                        onPressed: () {
                                          addRelationship(taskModel.task.relationships, task.taskId, RelationshipType.depends);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          );
                      },
                      trailing: const Icon(Icons.add)
                    ),
                  );
                }
            )
        )
      ],
    )
    );
  }

  void addRelationship(List<dynamic> list, String relatedTaskId, String relationshipType) {
    /// For now this function only adds the relationship but does not do a check
    /// if it already exists in the list. Given the requirements there could be
    /// two relationships (child and blocks). Logic is outside of scope.
    list.add(TaskRelationship(relatedTaskId, relationshipType));
  }
}
