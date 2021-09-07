const _extJpg = 'jpg';
const _extJpeg = 'jpeg';
const _extBmp = 'bmp';
const _extPng = 'png';
const _extGif = 'gif';


bool isImageFileExtension(String extension){
  return [
    _extJpg, _extJpeg, _extBmp, _extPng, _extGif
  ].contains(extension.toLowerCase());
}
