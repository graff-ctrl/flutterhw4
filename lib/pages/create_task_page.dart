import 'package:flutter/material.dart';
import 'package:flutterhw4/main.dart';
import 'package:flutterhw4/services/provider/provider.dart';
import 'package:provider/provider.dart';
import '../helpers/task_id.dart';
import '../constants//status.dart' as s;
import '../model/task.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);
  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  /// Creates task for task list.
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late String _status = "";
  late final DateTime _lastUpdated;

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _status = "";
    _lastUpdated = DateTime.now();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 36,
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                          child: Text(
                          "Create new task",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 27,
                              fontWeight: FontWeight.bold),
                        )),
                        label("Title"),
                        title(),
                        label("Description"),
                        description(),
                        date(_lastUpdated),
                        saveToLocalCache(),
                        saveToFirebase()
                      ],
                    ),
                  )
                ], // Children
              ),
            ),
          ),
        ));
  }

  Widget saveToLocalCache() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          /// Tasks are set to open by default.
          var result = Task(
            title: _titleController.text,
            description: _descriptionController.text,
            lastUpdated: DateTime.now(),
            status: s.open,
            taskId: TaskId.generateTaskId(_titleController.text + DateTime.now().toString()),
            imageUrl: 'image',
            relationships: null
          );
          Provider.of<TaskListModel>(context, listen: false).addTaskToCache(result);
          Navigator.pop(context, true);
        },
        child: Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.green,
            ),
            child: const Center(
              child: Text(
                'Save to local storage',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15
                ),
              ),
            )
        ),
      ),
    );
  }

  Widget saveToFirebase() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          /// Tasks are set to open by default.
          var result = Task(
              title: _titleController.text,
              description: _descriptionController.text,
              lastUpdated: DateTime.now(),
              status: s.open,
              taskId: TaskId.generateTaskId(_titleController.text + DateTime.now().toString()),
              imageUrl: 'image',
              relationships: null
          );
          Provider.of<TaskListModel>(context, listen: false).postTask(result);
          Navigator.pop(context, true);
        },
        child: Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.green,
            ),
            child: const Center(
              child: Text(
                'Save to Firebase',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15
                ),
              ),
            )
        ),
      ),
    );
  }

  /// Task description widget
  Widget description() {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: null,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        decoration: const InputDecoration(
            hintText: "Description",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
            contentPadding: EdgeInsets.only(left: 20, right: 20, top: 8)
        ),
      ),
    );
  }

  /// Title widget
  Widget title() {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        decoration: const InputDecoration(
            hintText: "Task Title",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
            contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 5)
        ),
      ),
    );
  }

  /// Label widget
  Widget label(String text) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 16.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2
          ),
        )
    );
  }

  /// Date formatting widget
  Widget date(DateTime dateTime) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: Text(
          'Last updated: ${dateTime.month}/${dateTime.day}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute}',
          style: const TextStyle(
              color: Colors.black,
              fontSize: 16.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2
          ),
        )
    );
  }
}