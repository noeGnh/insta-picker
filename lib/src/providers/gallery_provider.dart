import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:insta_picker/insta_picker.dart';
import 'package:insta_picker/src/models/file_model.dart';
import 'package:insta_picker/src/models/folder_model.dart';
import 'package:insta_picker/src/models/result_model.dart';
import 'package:insta_picker/src/utils/utils.dart';
import 'package:insta_picker/src/widgets/preview/image_preview.dart';
import 'package:insta_picker/src/widgets/preview/video_preview.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryProvider extends ChangeNotifier{

  FileModel _selectedFile;
  FolderModel _selectedFolder;
  List<FileModel> _files = [];
  List<FolderModel> _folders = [];

  int _multiSelectLimit = 5;
  bool _multiSelect = false;

  BetterPlayerController betterPlayerController;

  List<FileModel> get files => this._files;
  List<FolderModel> get folders => this._folders;
  FileModel get selectedFile => this._selectedFile;
  FolderModel get selectedFolder => this._selectedFolder;

  get multiSelect => this._multiSelect;
  get multiSelectLimit => this._multiSelectLimit;

  set multiSelect(bool b){
    this._files.clear();
    this._multiSelect = b;
    notifyListeners();
  }

  set multiSelectLimit(bool b){ this._multiSelect = b; }

  set selectedFile(FileModel file){ this._selectedFile = file; notifyListeners(); }

  getCheckNumber(FileModel file) => this._files.indexOf(file) + 1;

  getCheckState(FileModel file) => this._files.contains(file);

  toggleCheckState(FileModel file){
    if (getCheckState(file)){
      this._files.remove(file);
    }else{
      if (file.type == AssetType.video) {
        Utils.showToast('La multi-selection ne supporte pas les vidéos.');
        return;
      }

      if (this._files.length >= this._multiSelectLimit) {
        Utils.showToast('La limite est de ${this._multiSelectLimit} images.');
        return;
      }

      this._files.add(file);
    }
    notifyListeners();
  }

  initVideoController(File file) async {

    await disposeVideoController();

    if (betterPlayerController == null || !betterPlayerController.isVideoInitialized()){

      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.FILE, file.path);

      betterPlayerController = BetterPlayerController(BetterPlayerConfiguration(
            allowedScreenSleep: false,
            aspectRatio: 3 / 2,
            autoPlay: true,
            looping: false,
            controlsConfiguration: BetterPlayerControlsConfiguration(
                enableFullscreen: false,
                enableOverflowMenu: false,
                enableSkips: false,
            )
          ),
          betterPlayerDataSource: betterPlayerDataSource
      );

    }

  }

  pauseVideo() async {
    if (betterPlayerController != null && await betterPlayerController.isPlaying()) await betterPlayerController.pause();
  }

  playVideo() async {
    if (betterPlayerController != null && !(await betterPlayerController.isPlaying())) await betterPlayerController.play();
  }

  disposeVideoController(){
    try{

      if (betterPlayerController != null) betterPlayerController.dispose();

    }catch(e){
      print(e);
    }
  }

  getFilesPath() async {

    var result = await PhotoManager.requestPermission();
    if (result) {

      var paths = await PhotoManager.getAssetPathList(
          hasAll: false,
          filterOption: FilterOptionGroup()
            ..setOption(AssetType.video, FilterOption(
                durationConstraint: const DurationConstraint(
                  max: Duration(hours: 1),
                )
            ))
      );

      for(int i = 0; i < paths.length; i++){

        AssetPathEntity path = paths[i];

        List<FileModel> fileList = [];
        List<AssetEntity> assetList = await path.assetList;

        await Future.wait(
            assetList.map((asset) async {

              File f = await asset.file;

              if (asset.type != AssetType.image && asset.type != AssetType.video) return;

              fileList.add(FileModel(
                  file: f,
                  thumbBytes: asset.type == AssetType.video ? await asset.thumbData : null,
                  duration: asset.videoDuration,
                  type: asset.type,
                  size: asset.size,
                  width: asset.width,
                  height: asset.height,
                  createDt: asset.createDateTime,
                  modifiedDt: asset.modifiedDateTime,
                  latitude: asset.latitude,
                  longitude: asset.longitude,
                  ll: await asset.latlngAsync(),
                  mediaUrl: await asset.getMediaUrl(),
                  title: asset.title,
                  relativePath: asset.relativePath,
                  path: f.path
              ));

            }).toList()
        );

        if (fileList.isEmpty) return;

        this._folders.add(FolderModel(
            files: fileList,
            name: path.name,
            id: path.id,
            type: path.albumType,
            count: path.assetCount
        ));

        if (this._folders != null && this._folders.length == 1){

          this._selectedFolder = this._folders[0];
          this._selectedFile = this._folders[0].files[0];

        }

        notifyListeners();

      }

    }

  }

  List<DropdownMenuItem> getItems() {
    return this._folders.map((e) => DropdownMenuItem(
      child: SizedBox(
        width: 190,
        child: Text(e.name, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,),
      ),
      value: e,
    )
    ).toList() ?? [];
  }

  void onFolderSelected(FolderModel folder, {int index = 0}){
    assert(folder.files.length > 0);

    this._selectedFile = folder.files[index];

    this._selectedFolder = folder;

    notifyListeners();
  }

  void submit(BuildContext context, Options options) async {

    if (this._multiSelect) {

      this._returnImageResult(context, options);

    } else {
      
      if (this._selectedFile != null){

        this._files.clear();
        this._files.add(this._selectedFile);
        
        if (this._selectedFile.type == AssetType.video) {

          if (this._selectedFile.duration != null && this._selectedFile.duration.inMinutes < 10) {

            // bool findImage;
            //
            // for (int i = 0; i < this._folders.length; i++){
            //
            //   findImage = false;
            //
            //   if (this._folders[i].files.isNotEmpty){
            //
            //     for (int y = 0; y < this._folders[i].files.length; y++){
            //
            //       if (this._folders[i].files[y].type == AssetType.image) {
            //         this.onFolderSelected(this._folders[i], index: y);
            //         findImage = true;
            //         break;
            //       }
            //
            //     }
            //
            //   }
            //   if (findImage) break;
            // }

            Future.delayed(Duration(milliseconds: 1000), () async { pauseVideo(); });

            InstaPickerResult result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => VideoPreview(files: this._files, imagePreviewOptions: options,))
            );

            if (result != null) Navigator.pop(context, result);

          } else {
            Utils.showToast('Cette vidéo est trop longue !');
          }

        } else {

          this._returnImageResult(context, options);

        }

      }else{
        Utils.showToast('Aucun fichier sélectionné');
      }
      
    }

  }

  void _returnImageResult(BuildContext context, Options options) async {

    this.selectedFile = this._files[0];

    InstaPickerResult result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => ImagePreview(files: this._files, imagePreviewOptions: options, showAddButton: options.allowMultiple,))
    );

    if (result != null) Navigator.pop(context, result);

  }

}