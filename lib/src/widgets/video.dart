import 'package:flutter/material.dart';
import 'package:insta_picker/src/providers/video_provider.dart';
import 'package:provider/provider.dart';

class Video extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideoProvider>(
      create: (_) => VideoProvider(),
      child: VideoView(),
    );
  }
}

class VideoView extends StatefulWidget {
  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container();
  }
}
