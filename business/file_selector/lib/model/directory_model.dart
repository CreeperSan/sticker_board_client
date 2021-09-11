import 'dart:io';
import 'package:file_selector/model/file_model.dart';
import 'package:formatter/formatter.dart';

class DirectoryModel {
  List<FileModel> fileList = [];
  String path;
  late String name;

  DirectoryModel(this.path){
    final directory = Directory(path);

    // name
    name = directory.path.pathFileName();

    // Files
    final fileModelList = directory.listSync().map((e){
      return FileModel(e.path);
    }).toList();
    fileModelList.sort((a, b){
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    fileList.clear();
    fileList.addAll(fileModelList);
  }

}
