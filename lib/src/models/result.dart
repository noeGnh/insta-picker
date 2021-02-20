import 'dart:io';

class InstaPickerResult{

  List<PickedFile> pickedFiles;
  ResultType resultType;

  InstaPickerResult({this.pickedFiles, this.resultType});

}

class PickedFile{

  File file;
  String path;
  String name;

  PickedFile({this.file, this.path, this.name});

}

enum ResultType{
  IMAGE,
  VIDEO
}