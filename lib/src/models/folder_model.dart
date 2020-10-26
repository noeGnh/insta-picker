class FolderModel{

  List<String> files;
  String folderName;

  FolderModel({this.files, this.folderName});

  FolderModel.fromJson(Map<String, dynamic> json) {
    files = json['files'].cast<String>();
    folderName = json['folderName'];
  }

}