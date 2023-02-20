import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutterhw4/constants/relationship.dart';
import 'package:flutterhw4/helpers/task_sub_list.dart';
import 'package:flutterhw4/main.dart';
import 'package:flutterhw4/model/relationship_list_item.dart';
import 'package:flutterhw4/model/task_details_model.dart';
import 'package:flutterhw4/services/persistence_service.dart';
import 'package:flutterhw4/widgets/widget_label.dart';
import '../constants/status.dart' as status;

class TaskDetails extends StatefulWidget {
  // In the constructor, require a task.
  const TaskDetails({super.key, required this.taskModel});
  // Declare a field that holds the Todo.
  final TaskDetailsModel taskModel;
  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  late List<RelationshipListItem> relationshipItemList = TaskSubList.filter(widget.taskModel.task.relationships, widget.taskModel.allTasks);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Task Details")
        ),
        body: Column(
            children: <Widget>[
              Card(
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('Title: ${widget.taskModel.task.title}'),
                      subtitle: Text('Description:\n${widget.taskModel.task.description}'),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(8),
                        child: date(widget.taskModel.task.lastUpdated)
                      )
                    ),
                    Center(
                      child: DropdownButton<String>(
                        key: const Key('status'),
                        value: widget.taskModel.task.status,
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            widget.taskModel.task.status = value!;
                            widget.taskModel.task.lastUpdated = DateTime.now();
                            dbHelper.updateTask(widget.taskModel.task);
                          });
                        },
                        items: status.list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            key: Key(value),
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
              const WidgetLabel(text: "Sub-Tasks (swipe to delete):"),
              Expanded(
                  child: ListView.builder(
                      itemCount: relationshipItemList.length,
                      itemBuilder: (context, index) {
                        final item = relationshipItemList[index];
                        return Card (
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Dismissible(
                                key: Key(item.task.taskId),
                                onDismissed: (direction) {
                                  setState(() {
                                    widget.taskModel.task.relationships
                                        .removeAt(widget.taskModel.task.relationships.indexWhere((element) => element.taskId == item.task.taskId));
                                    dbHelper.updateTask( widget.taskModel.task);
                                    relationshipItemList.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text('${item.task.title} dismissed')));
                                },
                                background: Container(color: Colors.red),
                                child: ListTile(
                                  title: Text(item.task.title),
                                  // onTap: () => context.beamToNamed('/tasks/${test[index].taskId}', data: test[index]),
                                  trailing: SizedBox (
                                    width: 250,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: IconButton(
                                              onPressed: () => context.beamToNamed('/tasks/${item.task.taskId}', data: TaskDetailsModel(item.task, widget.taskModel.allTasks)),
                                              icon: const Icon(Icons.arrow_circle_right_sharp)
                                          ),
                                        ),
                                        Expanded(
                                          child: DropdownButton<String>(
                                            value: item.relationship.relationshipType,
                                            onChanged: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {

                                                // Update task relationships list to reflect changes.
                                                widget.taskModel.task.relationships.firstWhere(
                                                        (element) => element.taskId == item.task.taskId)
                                                    .relationshipType = value!;
                                                item.relationship.relationshipType = value!;
                                                widget.taskModel.task.lastUpdated = DateTime.now();
                                                dbHelper.updateTask(widget.taskModel.task);
                                              });
                                            },
                                            items: RelationshipType.list().map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    )
                                  )
                            ),
                              )
                          )
                        );
                      },
                  ),
              ),
            ],
          ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task),
              label: 'Add Sub-task',
            ),
          ],
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            switch(index){
              case 0:
                context.beamToNamed('/');
                break;
              case 1:
                context.beamToNamed('/addRelationship', data: widget.taskModel);
                break;
            }
          },
        )
        );
  }

  Widget field(String text) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2),
        ));
  }

  Widget date(DateTime dateTime) {
    return Text(
          'Last updated: ${dateTime.month}/${dateTime.day}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute}',
          style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
          ),
    );
  }
}