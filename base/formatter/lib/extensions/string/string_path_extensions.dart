import 'dart:io';

final String _pathSeparator = Platform.isWindows ? '\\' : '/';
final String _pathExtensionFlag = '.';

extension StringPathExtenstions on String {

  String pathFileName(){
    if(!this.contains(_pathSeparator)){
      return this;
    }
    return this.substring(this.lastIndexOf(_pathSeparator) + _pathSeparator.length);
  }

  bool pathIsHidden(){
    var fileName = this.pathFileName();
    if(Platform.isWindows){
      // TODO : I don't known, find a way later
      return false;
    } else {
      return fileName.startsWith(_pathExtensionFlag);
    }
  }

  String pathFileExtension(){
    var fileName = this.pathFileName();
    if(!fileName.contains(_pathExtensionFlag)){
      return '';
    }
    // if is UNIX system, "." in the first position of file means it is a hidden file;
    if(!Platform.isWindows){
      if(fileName.startsWith(_pathExtensionFlag)){
        fileName = fileName.substring(_pathExtensionFlag.length);
      }
    }
    return fileName.substring(fileName.lastIndexOf(_pathExtensionFlag) + _pathExtensionFlag.length);
  }

  String pathFileNameWithoutExtension(){
    final fileName = this.pathFileName();
    final fileExtensionFlagLastIndex = fileName.lastIndexOf(_pathExtensionFlag);
    if(fileName.contains(_pathExtensionFlag) && fileExtensionFlagLastIndex > 0){
      // means it really has an extension
      return fileName.substring(0, fileExtensionFlagLastIndex);
    } else {
      // means it don't has an extension
      return fileName;
    }
  }

}