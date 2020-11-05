import 'package:flutter/material.dart';
import 'package:insta_picker/src/providers/video_provider.dart';
import 'package:provider/provider.dart';

import '../../insta_picker.dart';

class Video extends StatelessWidget {
  final Options options;

  Video({this.options});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideoProvider>(
      create: (_) => VideoProvider(),
      child: VideoView(options: options),
    );
  }
}

class VideoView extends StatefulWidget {
  final Options options;

  VideoView({Key key, this.options}) : super(key: key);

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
