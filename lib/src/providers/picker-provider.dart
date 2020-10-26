import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insta_picker/src/models/folder-model.dart';
import 'package:storage_path/storage_path.dart';

class PickerProvider extends ChangeNotifier{

  String _image;
  List<FolderModel> _folders;
  FolderModel _selectedFolder;

  get image => this._image;
  get folders => this._folders;
  get selectedFolder => this._selectedFolder;

  set image(String img){
    this._image = img;
    notifyListeners();
  }

  getImagesPath() async {

    var paths = await StoragePath.imagesPath;
    var images = jsonDecode(paths) as List;

    this._folders = images.map<FolderModel>((e) => FolderModel.fromJson(e)).toList();

    if (this._folders != null && this._folders.length > 0){

      this._selectedFolder = this._folders[0];
      this._image = folders[0].files[0];

      notifyListeners();
    }

  }

  List<DropdownMenuItem> getItems() {
    return this._folders.map((e) => DropdownMenuItem(
      child: Text(
        e.folderName,
        style: TextStyle(color: Colors.black),
      ),
      value: e,
    )
    ).toList() ?? [];
  }

  void onFolderSelected(FolderModel folder){
    assert(folder.files.length > 0);

    this._image = folder.files[0];

    this._selectedFolder = folder;

    notifyListeners();
  }

}