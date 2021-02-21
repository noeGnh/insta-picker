import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:insta_picker/src/models/options.dart';
import 'package:insta_picker/src/models/result.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:super_tooltip/super_tooltip.dart';

class VideoProvider extends ChangeNotifier{

  final Logger logger = Logger();

  CameraController controller;
  int selectedCameraIdx;
  String videoPath;
  List cameras;

  Timer _timer;
  int _duration;
  int _durationLimit;

  Translations _translations;

  set translations(Translations translations){
    this._translations = translations;
  }

  FlashMode flashMode = FlashMode.off;

  Future<void> onFlashButtonPressed() async {
    switch (flashMode){
      case FlashMode.torch: flashMode = FlashMode.auto; break;

      case FlashMode.off: flashMode = FlashMode.torch; break;

      default: flashMode = FlashMode.off;
    }

    await controller.setFlashMode(flashMode);

    notifyListeners();
  }

  void getAvailableCameras(bool mounted){

    availableCameras().then((availableCameras) {

      cameras = availableCameras;
      if (cameras.length > 0) {

        selectedCameraIdx = 0;

        notifyListeners();

        _initCameraController(cameras[selectedCameraIdx], mounted).then((void v) {});

      }else{
        logger.w("No camera available");
      }

    }).catchError((e) {
      logger.e('Error: ${e.code}\nError Message: $e.message');
    });

  }

  Future _initCameraController(CameraDescription cameraDescription, bool mounted) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {

      if (mounted) notifyListeners();

      if (controller.value.hasError) {
        logger.e('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      logger.e(e);
    }

    if (mounted) notifyListeners();
  }

  void refreshCamera(bool mounted) {
    Future.delayed(Duration(milliseconds: 1000), () async {
      _initCameraController(cameras[0], mounted);
    });
  }

  void onSwitchCamera(bool mounted) {
    selectedCameraIdx = selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    _initCameraController(selectedCamera, mounted);
  }

  void startVideoRecording(BuildContext context, bool mounted) async {

    if (!controller.value.isInitialized) return null;

    if (controller.value.isRecordingVideo) return null;

    try {

      _startTimer(context, mounted);
      await controller.startVideoRecording();

    } on CameraException catch (e) {

      logger.e(e);
      videoPath = null;

    }

    if (mounted) notifyListeners();

  }

  void stopVideoRecording(BuildContext context, bool mounted) async {

    if (!controller.value.isRecordingVideo) return null;

    try {

      await controller.stopVideoRecording().then((XFile file){
        videoPath = file.path;
      });

      cancelTimer();

    } on CameraException catch (e) {
      logger.e(e);
    }

    if (mounted) notifyListeners();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

        return AlertDialog(
          title: new Text(this._translations.recordedVideo, style: TextStyle(fontWeight: FontWeight.bold),),
          content: new Text(this._translations.whatDoYouWantToDo),
          actions: <Widget>[
            new FlatButton(
                child: new Text(this._translations.delete),
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop();
                }
            ),
            new FlatButton(
                child: new Text(this._translations.validate),
                onPressed: (){

                  Navigator.of(context, rootNavigator: true).pop();

                  Navigator.pop(
                      context,
                      InstaPickerResult(
                          pickedFiles: [
                            PickedFile(
                                path: videoPath,
                                name: basename(videoPath)
                            )
                          ],
                          resultType: ResultType.VIDEO
                      )
                  );

                }
            ),
          ],
        );
      },
    );

  }

  void manageTooltip(BuildContext context, SuperTooltip tooltip){

    if (tooltip != null) {
      if (tooltip.isOpen){
        tooltip.close();
      }else {
        tooltip.show(context);
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (tooltip != null && tooltip.isOpen) tooltip.close();
        });
      }
    }

  }

  void _startTimer(BuildContext context, bool mounted) {

    _duration = 0;
    _timer = null;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          notifyListeners();
          if (_duration >= _durationLimit) {

            stopVideoRecording(context, mounted);

          } else {
            _duration += 1;
          }
        },
    );

  }

  void cancelTimer(){
    if (_timer != null) _timer.cancel(); _timer = null;
    _duration = 0;
  }

  double getIndicatorProgress() {
    return _duration != null && _durationLimit != null ? _duration / _durationLimit : 0.0;
  }

  String showDuration() {
    if (_duration == null) return '00';

    return _duration.toString().length < 2 ? '0$_duration' : '$_duration';
  }

  set durationLimit(int d) { _durationLimit = d <= 60 ? d : 60; }

}