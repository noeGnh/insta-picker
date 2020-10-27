import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PhotoProvider extends ChangeNotifier{

  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;

  void getAvailableCameras(bool mounted){

    availableCameras().then((availableCameras) {

      cameras = availableCameras;
      if (cameras.length > 0) {

        selectedCameraIdx = 0;

        notifyListeners();

        _initCameraController(cameras[selectedCameraIdx], mounted).then((void v) {});

      }else{
        print("No camera available");
      }
    }).catchError((e) {
      print('Error: $e.code\nError Message: $e.message');
    });

  }

  Future _initCameraController(CameraDescription cameraDescription, bool mounted) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {

      if (mounted) {
        notifyListeners();
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      notifyListeners();
    }
  }

  void onSwitchCamera(bool mounted) {
    selectedCameraIdx = selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    _initCameraController(selectedCamera, mounted);
  }

  void onCapturePressed(context) async {

    try {

      final path = join(
        (await getTemporaryDirectory()).path, '${DateTime.now()}.png',
      );
      print(path);
      await controller.takePicture(path);

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => PreviewImageScreen(imagePath: path),
      //   ),
      // );
    } catch (e) {
      print(e);
    }
  }

}