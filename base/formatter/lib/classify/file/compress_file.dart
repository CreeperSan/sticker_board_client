const _extZip = 'zip';
const _extTar = 'tar';
const _extGz = 'gz';
const _extRar = 'rar';
const _ext7z = '7z';

bool isCompressFileExtension(String extension){
  return [
    _extZip, _extTar, _extGz, _extRar, _ext7z
  ].contains(extension.toLowerCase());
}
