const _extMP3 = 'mp3';
const _extFLAC = 'flac';
const _extAMR = 'amr';
const _extWAV = 'wav';

bool isSoundExtension(String extension){
  return [
    _extMP3, _extFLAC, _extAMR, _extWAV,
  ].contains(extension.toLowerCase());
}
