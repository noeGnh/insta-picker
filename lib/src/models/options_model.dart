import 'package:flutter/material.dart';

class Options{

  Color bgColor;
  Color textColor;
  Color iconsColor;
  Color accentColor;
  Color appBarColor;
  Color tabBarColor;
  Color tabBarTextColor;
  Color tabBarIndicatorColor;
  bool showGalleryTab;
  bool showPhotoTab;
  bool showVideoTab;
  bool allowMultiple;
  String galleryTabTitle;
  String photoTabTitle;
  String videoTabTitle;
  int videoDurationLimitInSeconds;

  Options({
    this.showVideoTab = true,
    this.showPhotoTab = true,
    this.showGalleryTab = true,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
    this.accentColor = Colors.black,
    this.appBarColor = Colors.white,
    this.iconsColor = Colors.black,
    this.tabBarColor = Colors.white,
    this.tabBarTextColor = Colors.black,
    this.tabBarIndicatorColor = Colors.black,
    this.galleryTabTitle = 'Galerie',
    this.photoTabTitle = 'Photo',
    this.videoTabTitle = 'Vidéo',
    this.allowMultiple = true,
    this.videoDurationLimitInSeconds = 30
  });

}