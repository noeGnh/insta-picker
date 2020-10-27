import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_picker/src/models/options_model.dart';
import 'package:insta_picker/src/providers/photo_provider.dart';
import 'package:provider/provider.dart';
import 'package:torch_compat/torch_compat.dart';

class Photo extends StatelessWidget {
  final Options options;

  Photo({this.options});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PhotoProvider>(
      create: (_) => PhotoProvider(),
      child: PhotoView(options: options),
    );
  }
}

class PhotoView extends StatefulWidget {
  final Options options;

  PhotoView({Key key, this.options}) : super(key: key);

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

  Widget _cameraPreviewWidget() {
    if (photoProvider.controller == null || !photoProvider.controller.value.isInitialized) {
      return const Text(
        'Chargement...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: photoProvider.controller.value.aspectRatio,
      child: CameraPreview(photoProvider.controller),
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
                backgroundColor: widget.options.iconsColor,
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
        child: GestureDetector(
              child: Padding(
                  padding: EdgeInsets.only(left: 21),
                  child: Icon(_getCameraLensIcon(lensDirection), color: widget.options.iconsColor, size: 32,),
              ),
              onTap: (){
                photoProvider.onSwitchCamera(mounted);
              },
            )
      ),
    );
  }

  Widget _flashToggleRowWidget() {
    return Expanded(
      child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            child: Padding(
                padding: EdgeInsets.only(right: 21),
                child: Icon(photoProvider.flashOn ? Icons.flash_on : Icons.flash_off, color: widget.options.iconsColor, size: 32,),
            ),
            onTap: (){
              photoProvider.switchFlashState(!photoProvider.flashOn);
            },
          )
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
                    child: _cameraPreviewWidget(),
                  ),
                  SizedBox(height: 10.0),
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

