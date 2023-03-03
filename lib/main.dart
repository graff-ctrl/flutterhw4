import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterhw4/services/provider/provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterhw4/services/platform/camera_service.dart';
import 'package:flutterhw4/services/firebase/firebase_auth_service.dart';
import 'package:flutterhw4/services/firebase/firebase_db_service.dart';
import 'package:flutterhw4/services/platform/persistence_service.dart';
import 'package:flutterhw4/widgets/take_picture.dart';
import '../model/task_details_model.dart';
import '../pages/add_relationship_page.dart';
import '../pages/create_task_page.dart';
import '../pages/home_page.dart';
import '../pages/task_detials_page.dart';

final PersistenceService localCacheService = PersistenceService();
final CameraService cameraHelper = CameraService();
final FirebaseAuthService authService = FirebaseAuthService();
late final RealtimeDatabaseService firebaseDBService;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await authService.getUser();
  firebaseDBService = RealtimeDatabaseService(uuid: authService.currentUser?.uid);
  await localCacheService.init();
  await cameraHelper.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TaskListModel())
        ],
        child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  final routerDelegate = BeamerDelegate(
      locationBuilder: RoutesLocationBuilder(
        routes: {
          '/': (context, state, data) => HomePage(title: 'Andrew Graff'),
          '/create': (context, state, data) => const CreateTask(),
          '/takePicture': (context, state, data) => TakePictureScreen(camera: cameraHelper.firstCamera),
          '/addRelationship': (context, state, data) {
            final info = (data as TaskDetailsModel);
            return BeamPage(
                key: ValueKey('add-${info.task.taskId}'),
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
  /// Not enough time to get back navigation working for beamer history. Followed
  /// docs on implementing with Android back button but was not able to navigate correctly
  /// Pop action is back to home.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "App",
      debugShowCheckedModeBanner: false,
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routerDelegate),
    );
  }
}

