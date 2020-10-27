import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PhotoProvider extends ChangeNotifier{

  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  bool mounted = false;

  void init(){

  }

  void getAvailableCameras(){

    availableCameras().then((availableCameras) {

      cameras = availableCameras;
      if (cameras.length > 0) {

        selectedCameraIdx = 0;

        notifyListeners();

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});

      }else{
        print("No camera available");
      }
    }).catchError((e) {
      print('Error: $e.code\nError Message: $e.message');
    });

  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      // 5
      if (mounted) {
        notifyListeners();
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    // 6
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      notifyListeners();
    }
  }



}