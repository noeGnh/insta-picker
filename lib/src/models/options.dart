import 'package:flutter/material.dart';

class Options{

  bool showGalleryTab;
  bool showPhotoTab;
  bool showVideoTab;
  CustomizationOptions customizationOptions;

  Options({
    this.showGalleryTab = true,
    this.showPhotoTab = true,
    this.showVideoTab = true,
    CustomizationOptions customizationOptions
  }) : this.customizationOptions = customizationOptions ?? CustomizationOptions();

}

class CustomizationOptions{

  Color bgColor;
  Color textColor;
  Color iconsColor;
  Color accentColor;
  Color appBarColor;
  Color tabBarColor;
  Color tabBarTextColor;
  Color tabBarIndicatorColor;
  GalleryCustomization galleryCustomization;
  PhotoCustomization photoCustomization;
  VideoCustomization videoCustomization;

  CustomizationOptions({
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
    this.accentColor = Colors.black,
    this.appBarColor = Colors.white,
    this.iconsColor = Colors.black,
    this.tabBarColor = Colors.white,
    this.tabBarTextColor = Colors.black,
    this.tabBarIndicatorColor = Colors.black,
    GalleryCustomization galleryCustomization,
    PhotoCustomization photoCustomization,
    VideoCustomization videoCustomization
  }) : this.galleryCustomization = galleryCustomization ?? GalleryCustomization(),
       this.photoCustomization = photoCustomization ?? PhotoCustomization(),
       this.videoCustomization = videoCustomization ?? VideoCustomization();

}

class GalleryCustomization{
  String title;
  Color gridBgColor;
  int maxSelectable;
  Color selectedFileContainerColor;

  GalleryCustomization({
    this.title = 'Gallery',
    this.maxSelectable = 1,
    this.gridBgColor = Colors.white,
    this.selectedFileContainerColor = Colors.white,
  }){
    if (this.maxSelectable != null && this.maxSelectable <= 0) {
      throw ArgumentError('The maximum gallery selectable items value must be greater than 0');
    }  
  }
}

class PhotoCustomization{
  String title;

  PhotoCustomization({this.title = 'Photo'});
}

class VideoCustomization{
  String title;
  Duration maximumRecordingDuration;

  VideoCustomization({
    this.title = 'Video',
    this.maximumRecordingDuration = const Duration(seconds: 30)
  }) : assert(maximumRecordingDuration.inSeconds > 0 && maximumRecordingDuration.inSeconds <= 60);
}