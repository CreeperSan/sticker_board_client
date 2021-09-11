import 'package:formatter/formatter.dart';
import 'dart:io';

enum FileType{
  Directory,
  File,
  Code,
  Text,
  Image,
  Sound,
  Video,
  CompressFile,
  Windows,
  Markdown,
  OfficeWord,
  OfficePowerPoint,
  OfficeExcel,
  Flash,
}

class FileModel {
  String path;
  late String name;
  late int size;
  late bool isExist;
  late bool isDirectory;
  late FileType fileType;

  FileModel(this.path){
    final file = File(path);

    // name
    name = file.path.pathFileName();

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

    // File Type
    final fileExtension = name.pathFileExtension();

    // File Type
    if(isDirectory){
      fileType = FileType.Directory;
    } else if (isCodeFileExtension(fileExtension)){
      fileType = FileType.Code;
    } else if (isCompressFileExtension(fileExtension)){
      fileType = FileType.CompressFile;
    } else if (isFlashExtension(fileExtension)){
      fileType = FileType.Flash;
    } else if (isImageFileExtension(fileExtension)){
      fileType = FileType.Image;
    } else if (isMarkdownFileExtension(fileExtension)){
      fileType = FileType.Markdown;
    } else if (isOfficeWordExtension(fileExtension)){
      fileType = FileType.OfficeWord;
    } else if (isOfficeExcelExtension(fileExtension)){
      fileType = FileType.OfficeExcel;
    } else if (isOfficePowerPointExtension(fileExtension)){
      fileType = FileType.OfficePowerPoint;
    } else if (isSoundExtension(fileExtension)){
      fileType = FileType.Sound;
    } else if (isTextExtension(fileExtension)){
      fileType = FileType.Text;
    } else if (isVideoExtension(fileExtension)){
      fileType = FileType.Video;
    } else if (isWindowsExecutableFileExtension(fileExtension)){
      fileType = FileType.Windows;
    } else {
      fileType = FileType.File;
    }


  }

}
