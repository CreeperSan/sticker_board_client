import 'dart:io';
import 'package:file_selector/model/file_model.dart';

class DirectoryModel {
  List<FileModel> fileList = [];
  String path;
  late String name;

  DirectoryModel(this.path){
    final directory = Directory(path);

    // name
    name = directory.path;
    if(name.contains('/')){
      name = name.substring(name.lastIndexOf('/')+1);
    }

    // Files
    directory.listSync().forEach((element) {
      fileList.add(FileModel(element.path));
    });
  }

}
