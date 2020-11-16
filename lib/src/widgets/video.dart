import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:insta_picker/src/providers/video_provider.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:torch_compat/torch_compat.dart';

import '../../insta_picker.dart';

Options options;

class Video extends StatelessWidget {

  Video({@required Options videoViewOptions}){ options = videoViewOptions; }

  @override
  Widget build(BuildContext context) => VideoView();

}

class VideoView extends StatefulWidget {
  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoProvider videoProvider;

  @override
  void initState() {
    super.initState();

    videoProvider =  Provider.of<VideoProvider>(context, listen: false);
    videoProvider.getAvailableCameras(mounted);

    videoProvider.durationLimit = options.videoDurationLimitInSeconds;
  }

  @override
  void dispose() {
    videoProvider.cancelTimer();
    super.dispose();
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  Widget _cameraPreviewWidget() {
    if (videoProvider.controller == null || !videoProvider.controller.value.isInitialized) {
      return const Text(
        'Chargement...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: videoProvider.controller.value.aspectRatio,
      child: CameraPreview(videoProvider.controller),
    );
  }

  /// Display the control bar with buttons to take pictures
  Widget _captureControlRowWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            VideoCaptureButton(videoProvider)
          ],
        ),
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    if (videoProvider.cameras == null || videoProvider.cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = videoProvider.cameras[videoProvider.selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(left: 21),
              child: Icon(_getCameraLensIcon(lensDirection), color: options.iconsColor, size: 32,),
            ),
            onTap: (){
              videoProvider.onSwitchCamera(mounted);
            },
          )
      ),
    );
  }

  Widget _flashToggleRowWidget() {

    IconData iconData;

    switch(videoProvider.flashMode){
      case FlashMode.autoFlash:  iconData = Icons.flash_auto; break;

      case FlashMode.torch: iconData = Icons.flash_on; break;

      default:  iconData = Icons.flash_off;
    }

    return Expanded(
      child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(right: 21),
              child: Icon(iconData, color: options.iconsColor, size: 32,),
            ),
            onTap: (){
              if (videoProvider.controller != null && videoProvider.controller.value.isInitialized){
                videoProvider.onFlashButtonPressed();
              }
            },
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(
        builder: (ctx, provider, child){
          return Container(
            color: options.bgColor,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: _cameraPreviewWidget(),
                  ),
                  LinearProgressIndicator(
                    value: provider.getIndicatorProgress(),
                    valueColor: AlwaysStoppedAnimation<Color>(options.accentColor),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "00 : ${provider.showDuration()}",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _cameraTogglesRowWidget(),
                      _captureControlRowWidget(context),
                      FutureBuilder<bool>(
                          future: TorchCompat.hasTorch,
                          builder: (ctx, snapshot){
                            return snapshot.hasData && snapshot.data ? _flashToggleRowWidget() : Spacer();
                          }
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0)
                ],
              ),
            ),
          );
        }
    );
  }
}

class VideoCaptureButton extends StatefulWidget {
  final VideoProvider videoProvider;

  VideoCaptureButton(this.videoProvider, {Key key}) : super(key: key);

  @override
  _VideoCaptureButtonState createState() => _VideoCaptureButtonState();
}

class _VideoCaptureButtonState extends State<VideoCaptureButton> {

  SuperTooltip superTooltip = SuperTooltip(
    popupDirection: TooltipDirection.up,
    borderRadius: 3.0,
    borderWidth: 0.0,
    hasShadow: false,
    content: Material(
      child: Text(
        "Appuyez longuement pour enregistrer",
        softWrap: true,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (d) => widget.videoProvider.startVideoRecording(context, mounted),
      onLongPressEnd: (d) => widget.videoProvider.stopVideoRecording(context, mounted),
      child: FloatingActionButton(
        child: Icon(Icons.camera, color: options.bgColor,),
        backgroundColor: options.iconsColor,
        onPressed: () => widget.videoProvider.manageTooltip(context, superTooltip),
      ),
    );
  }
}

