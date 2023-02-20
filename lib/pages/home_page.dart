import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterhw4/main.dart';
import 'package:flutterhw4/model/task_details_model.dart';
import '../model/task.dart';
import '../pages/create_task_page.dart';
import '../widgets/widget_label.dart';
import '../constants/filters.dart';
import 'package:beamer/beamer.dart';


class HomePage extends StatefulWidget {
  HomePage({super.key, required this.title});

  final String title;
  List<Task> items = <Task>[];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task>? filterItems = []; // Filtered list form items
  Filters? _filter = Filters.all;
  @override
  initState() {
    // at the beginning, all users are shown
    super.initState();
    _refresh();
    filterItems = widget.items;
    _filterList('');
  }

  void _refresh() async {
    final data = await dbHelper.getAllTasks();
    setState(() {
      widget.items = data;
      filterItems = widget.items;
      _sort();
    });
  }

  /// Sort widget.items list
  void _sort() {
    widget.items.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
  }

  /// Add item to list.
  void _addItem(Task task) {
    _addTaskToDB(task);
    _refresh();
  }
  void _filterList(String query) {
    List<Task>? results = [];
    if (query.isEmpty) {
      _sort();
      results = widget.items;
    } else {
      _sort();
      results = widget.items.where((element) => (element.status == query)).toList();
    }
    setState(() {
      filterItems = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            const WidgetLabel(text: 'Task filters:'),
            radioButton('All', Filters.all),
            radioButton('Open', Filters.open),
            radioButton('In Progress', Filters.inProgress),
            radioButton('Complete', Filters.complete),
            const WidgetLabel(text: 'Tasks:'),
            Expanded(
              child: ListView.builder(
                key: const Key('tasks'),
                itemCount: filterItems?.length,
                itemBuilder: (context, index) {
                  final task = filterItems![index];
                  return Card (
                      child: ListTile(
                        title: Text(filterItems![index].title),
                        onTap: () => context.beamToNamed('/tasks/${task.taskId}', data: TaskDetailsModel(task, widget.items)),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _newTaskCreation(context);
          },
          tooltip: 'Create',
          child: const Icon(Icons.add),
        ),
      );
  }

  /// Transitions to the Create Task Page passing context.
  Future<void> _newTaskCreation(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
        builder: (builder) => const CreateTask()),
    );

    if (!mounted) return;
    _addItem(result);
  }

  void _addTaskToDB(Task task) async {
    await dbHelper.addTask(task.toJson());
  }

  /// Label for fields on home screen.
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

  /// Radio button widget
  Widget radioButton(String title, Filters filter) {
    return ListTile(
      title: Text(title),
      leading: Radio<Filters>(
        key: Key(title),
        value: filter,
        groupValue: _filter,
        onChanged: (Filters? value) {
          setState(() {
            _filter = value;
            _filterList(filterString(_filter!));
          });
        },
      ),
    );
  }

  /// Filter for query based on enum of Filters.
  String filterString(Filters filter) {
    switch(filter) {
      case Filters.all:
        return '';
      case Filters.open:
        return 'Open';
      case Filters.inProgress:
        return 'In Progress';
      case Filters.complete:
        return 'Complete';
    }
  }
}