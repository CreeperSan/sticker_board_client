
import 'dart:io';

class FileModel {
  String path;
  late String name;
  late int size;
  late bool isExist;
  late bool isDirectory;

  FileModel(this.path){
    final file = File(path);

    // name
    name = file.path;
    if(name.contains('/')){
      name = name.substring(name.lastIndexOf('/') + 1);
    }

    // isDirectory
    isDirectory = FileSystemEntity.isDirectorySync(path);

    // size
    if(isDirectory) {
      size = Directory(path).listSync().length;
    } else {
      size = file.lengthSync();
    }

    // isExist
    isExist = file.existsSync();

  }

}
