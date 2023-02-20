// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterhw4/helpers/task_id.dart';
import 'package:flutterhw4/model/task.dart';
import 'package:flutterhw4/model/task_details_model.dart';
import 'package:flutterhw4/pages/add_relationship_page.dart';
import 'package:flutterhw4/pages/create_task_page.dart';
import 'package:flutterhw4/pages/home_page.dart';
import 'package:flutterhw4/pages/task_detials_page.dart';
import 'package:mockito/annotations.dart';
import 'package:flutterhw4/constants/status.dart' as status;
@GenerateMocks([HomePage])
void main() {
  ///starts out with no tasks listed.
  testWidgets('test home page layout', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: HomePage(title: 'title'),
    ));
    // Verify that our counter starts at 0.
    expect(find.text('title'), findsOneWidget);
    expect(find.byTooltip('Create'), findsOneWidget);

    // Testing that no tasks are listed
    expect(find.byWidget(ListView()), findsNothing);
  });

  ///has a button that when clicked tells the navigator/router to go to the widget for creating a new task*.
  testWidgets('test navigation to create task', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomePage(title: 'title'),
    ));


    // Tap the '+' icon and trigger the CreateTask page..
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.byType(CreateTask), findsOneWidget);
  });

  ///shows a separate widget for each task when there are tasks to list.
  ///Indicates the name of the task.
  ///
  testWidgets('test homepage with pre-populated tasks and title', (WidgetTester tester) async {
    final homepage = HomePage(title: 'title');
    final list = <Task>[TaskId.generateTestTask("1"), TaskId.generateTestTask("2")];
    homepage.items = list;
    await tester.pumpWidget(MaterialApp(
      home: homepage,
    ));

    expect(find.text('Test 1'), findsOneWidget);
    expect(find.text('Test 2'), findsOneWidget);

  });

  ///shows only some of the tasks when a filter is applied.
  testWidgets('test homepage with pre-populated tasks and filter change', (WidgetTester tester) async {
    final homepage = HomePage(title: 'title');
    final list = <Task>[TaskId.generateTestTask("1"), TaskId.generateTestTask("2")];
    list[0].status = status.complete;
    homepage.items = list;
    await tester.pumpWidget(MaterialApp(
      home: homepage,
    ));
    const key = Key(status.complete);
    expect(find.text('Test 1'), findsOneWidget);
    expect(find.text('Test 2'), findsOneWidget);
    
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
    expect(find.text('Test 1'), findsOneWidget);
    expect(find.text('Test 2'), findsNothing);
  });

  ///has a button that when clicked tells the navigator/router to go to the widget for editing an existing task*.
  testWidgets('test navigation to task details', (WidgetTester tester) async {
    final homepage = HomePage(title: 'title');
    final list = <Task>[TaskId.generateTestTask("1"), TaskId.generateTestTask("2")];
    homepage.items = list;
    final routerDelegate = BeamerDelegate(
        locationBuilder: RoutesLocationBuilder(
            routes: {
              '/': (context, state, data) => homepage,
              '/create': (context, state, data) => const CreateTask(),
              '/addRelationship': (context, state, data) {
                final info = (data as TaskDetailsModel);
                return BeamPage(
                    child: AddRelationshipPage(taskModel: info),
                    type: BeamPageType.slideRightTransition
                );
              },
              '/tasks/:taskId': (context, state, data) {
                final taskId = state.pathParameters['taskId'];
                final info = (data as TaskDetailsModel);
                return BeamPage(
                    key: ValueKey('task-$taskId'),
                    popToNamed: '/',
                    child: TaskDetails(taskModel: info),
                    type: BeamPageType.slideRightTransition
                );
              }
            }
        ));
    await tester.pumpWidget(MaterialApp.router(
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
    ));

    expect(find.text('Test 1'), findsOneWidget);
    await tester.tap(find.text('Test 1'));
    await tester.pumpAndSettle();
    expect(find.byType(TaskDetails), findsOneWidget);
    expect(find.text("Task Details"), findsOneWidget);
    expect(find.text("Open"), findsOneWidget);
  });
  ///The widget for editing an existing task*:
  // Fills out the title and description of the existing task
  /// ^^This is NOT a part of the requirements for HW1 or HW2
  /// therefore it cannot be tested.
  /// Updates the existing task instead of creating a new task.
  testWidgets('tests changing the task status', (WidgetTester tester) async {
    final testModel = TaskDetailsModel(
        TaskId.generateTestTask('1'),
        []
    );
    await tester.pumpWidget(MaterialApp(
      home: TaskDetails(taskModel: testModel),
    ));
    const statusButton = Key('status');
    const statusValue = Key(status.complete);
    expect(find.text("Open"), findsOneWidget);
    await tester.tap(find.byKey(statusButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Complete').last);
    await tester.pumpAndSettle();
    expect(find.text("Complete"), findsOneWidget);

  });
}
