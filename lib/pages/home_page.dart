import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterhw4/main.dart';
import 'package:flutterhw4/model/task_details_model.dart';
import 'package:flutterhw4/services/provider/provider.dart';
import 'package:flutterhw4/services/task/task_service.dart';
import 'package:provider/provider.dart';
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
  List<Task> filterItems = []; // Filtered list form items
  Filters? _filter = Filters.all;
  final TaskListModel taskListModel = TaskListModel();
  @override
  initState() {
    // at the beginning, all users are shown
    super.initState();
    // Load data from db at start.
    _loadFromDB();

  }

  void _refresh() async {
    setState(() {
      filterItems = taskListModel.tasks;
      _sort();
    });
  }

  /// Load from SQLite database.
  void _loadFromDB() async {
    await taskListModel.loadProvider();
    setState(() {
      filterItems = taskListModel.tasks;
      _sort();
    });
  }

  /// Sort widget.items list
  void _sort() {
    taskListModel.tasks.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
  }

  void _filterList(String query) {
    List<Task> results = [];
    if (query.isEmpty) {
      results = taskListModel.tasks;
      _sort();
    } else {
      results = taskListModel.tasks.where((element) => (element.status == query)).toList();
      _sort();
    }
    setState(() {
      print(results);
      filterItems = results;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /// ONLY SHOW DEBUG DRAWER WHEN NOT RELEASE
        drawer: kReleaseMode == false ? Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Debug Drawer'),
              ),
              ListTile(
                title: const Text('Clear Cache'),
                onTap: () {
                  localCacheService.deleteAllTasks();
                  _refresh();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ) : null,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.purpleAccent,
          shadowColor: Colors.orangeAccent,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WidgetLabel(text: 'Task filters:'),
            radioButton('All', Filters.all),
            radioButton('Open', Filters.open),
            radioButton('In Progress', Filters.inProgress),
            radioButton('Complete', Filters.complete),
            const WidgetLabel(text: 'Tasks:'),
            Consumer<TaskListModel>(
              builder: (context, list, child) {

                return Expanded(
                  child: ListView.builder(
                    key: const Key('tasks'),
                    itemCount: filterItems?.length,
                    itemBuilder: (context, index) {
                      final task = filterItems![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card (
                            child: ListTile(
                              title: Text(filterItems![index].title),
                              onTap: () => context.beamToNamed('/tasks/${task.taskId}', data: TaskDetailsModel(task, list.tasks)),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                            ),
                        ),
                      );
                    },
                  ),
                );
              }
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                builder: (builder) => const CreateTask())
            );
            if (mounted!) return;
            _refresh();
          },
          tooltip: 'Create',
          child: const Icon(Icons.add),
        ),
      );
  }

  void _addTaskToDB(Task task) async {
    await localCacheService.addTask(task);
  }

  /// Label for fields on home screen.
  Widget label(String text) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
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