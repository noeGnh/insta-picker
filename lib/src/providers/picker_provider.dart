import 'package:flutter/material.dart';
import 'package:insta_picker/src/providers/photo_provider.dart';
import 'package:insta_picker/src/providers/video_provider.dart';
import 'package:provider/provider.dart';

class PickerProvider extends ChangeNotifier{

  PageController? pageController;
  TabController? tabController;

  bool pageIsChanging = false;

  void init(BuildContext context, Map<String, int> indexes){

    if (indexes['PHOTO_PAGE_INDEX'] == 0){

      PhotoProvider photoProvider = Provider.of<PhotoProvider>(context, listen: false);
      photoProvider.getAvailableCameras(true);

    } else if (indexes['VIDEO_PAGE_INDEX'] == 0){

      VideoProvider videoProvider = Provider.of<VideoProvider>(context, listen: false);
      videoProvider.getAvailableCameras(true);

    }

  }

  void onPageChange(BuildContext context, int index, Map<String, int> indexes) async {

    if (tabController == null || pageController == null || pageIsChanging) return;

    await pageController!.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);

    tabController!.animateTo(index);

    pageIsChanging = false;

    if (index == indexes['PHOTO_PAGE_INDEX']){

      PhotoProvider photoProvider = Provider.of<PhotoProvider>(context, listen: false);
      photoProvider.getAvailableCameras(true);

    } else if (index == indexes['VIDEO_PAGE_INDEX']){

      VideoProvider videoProvider = Provider.of<VideoProvider>(context, listen: false);
      videoProvider.getAvailableCameras(true);

    }

  }

}