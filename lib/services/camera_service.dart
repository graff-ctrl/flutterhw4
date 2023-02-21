import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {

  late final cameras;
  late final firstCamera;

  init() async {
    // Obtain a list of the available cameras on the device.
    cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    firstCamera = cameras.first;
  }

}