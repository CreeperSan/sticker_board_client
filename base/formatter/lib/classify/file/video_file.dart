const _extMP4 = 'mp4';
const _extAVI = 'avi';
const _extWMV = 'wmv';
const _extM4V = 'm4v';
const _extMOV = 'mov';
const _extFLV = 'flv';
const _extRM = 'rm';
const _ext3GP = '3gp';

bool isVideoExtension(String extension){
  return [
    _extMP4, _extAVI, _extWMV, _extWMV, _extM4V, _extMOV, _extFLV, _extRM,
    _ext3GP,
  ].contains(extension.toLowerCase());
}
