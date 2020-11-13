import 'package:flutter/material.dart';
import 'package:insta_picker/src/providers/gallery_provider.dart';
import 'package:provider/provider.dart';

class PickerProvider extends ChangeNotifier{

  static const GALLERY_PAGE_INDEX = 0;
  static const PHOTO_PAGE_INDEX = 1;
  static const VIDEO_PAGE_INDEX = 2;

  PageController pageController;
  TabController tabController;

  void addTabListener(BuildContext context){

    if (tabController == null) return;

    tabController.addListener(() {

      if (tabController.indexIsChanging) onPageChange(context, tabController.index);

    });

  }

  void onPageChange(BuildContext context, int index) async {

    if (tabController == null || pageController == null) return;

    await pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);

    tabController.animateTo(index);

    GalleryProvider galleryProvider = Provider.of<GalleryProvider>(context, listen: false);

    switch(index){
      case GALLERY_PAGE_INDEX:
        galleryProvider.playVideo();
        break;

      case PHOTO_PAGE_INDEX:
        galleryProvider.pauseVideo();
        break;

      case VIDEO_PAGE_INDEX:
        galleryProvider.pauseVideo();
        break;
    }

  }

}