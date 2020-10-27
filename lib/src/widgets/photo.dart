import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:insta_picker/src/providers/photo_provider.dart';
import 'package:provider/provider.dart';

class Photo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PhotoProvider>(
      create: (_) => PhotoProvider(),
      child: PhotoView(),
    );
  }
}

class PhotoView extends StatefulWidget {
  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> with AutomaticKeepAliveClientMixin{
  PhotoProvider photoProvider;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    photoProvider =  Provider.of<PhotoProvider>(context, listen: false);
    photoProvider.getAvailableCameras(mounted);
  }

  @override
  void dispose() {
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

  Widget _cameraPreviewWidget(PhotoProvider provider) {
    if (provider.controller == null || !provider.controller.value.isInitialized) {
      return const Text(
        'Chargement...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: provider.controller.value.aspectRatio,
      child: CameraPreview(provider.controller),
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
            FloatingActionButton(
                child: Icon(Icons.camera),
                backgroundColor: Colors.blueGrey,
                onPressed: () {
                  photoProvider.onCapturePressed(context);
                })
          ],
        ),
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    if (photoProvider.cameras == null || photoProvider.cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = photoProvider.cameras[photoProvider.selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: (){
              photoProvider.onSwitchCamera(mounted);
            },
            icon: Icon(_getCameraLensIcon(lensDirection)),
            label: Text(
                "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}")),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<PhotoProvider>(
        builder: (ctx, provider, child){
          return Container(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: _cameraPreviewWidget(provider),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _cameraTogglesRowWidget(),
                      _captureControlRowWidget(context),
                      Spacer()
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

