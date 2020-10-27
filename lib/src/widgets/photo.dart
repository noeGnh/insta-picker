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

class _PhotoViewState extends State<PhotoView> {
  PhotoProvider photoProvider;

  @override
  void initState() {
    super.initState();

    photoProvider =  Provider.of<PhotoProvider>(context, listen: false);
    photoProvider.getAvailableCameras();
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

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (ctx, provider, child){
          return _cameraPreviewWidget(provider);
        }
    );
  }
}

