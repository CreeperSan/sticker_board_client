const _extEXE = 'exe';

bool isWindowsExecutableFileExtension(String extension){
  return [
    _extEXE,
  ].contains(extension.toLowerCase());
}
