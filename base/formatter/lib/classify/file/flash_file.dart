const _extSWF = 'swf';

bool isFlashExtension(String extension){
  return [
    _extSWF,
  ].contains(extension.toLowerCase());
}
