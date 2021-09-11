const _extTxt = 'txt';

bool isTextExtension(String extension){
  return [
    _extTxt,
  ].contains(extension.toLowerCase());
}
