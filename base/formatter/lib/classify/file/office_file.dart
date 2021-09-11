const _extWord03 = 'doc';
const _extWord = 'docx';

const _extPPT03 = 'pptx';
const _extPPT = 'pptx';

const _extExcel03 = 'xls';
const _extExcel = 'xlsx';

bool isOfficeWordExtension(String extension){
  return [
    _extWord03, _extWord,
  ].contains(extension.toLowerCase());
}

bool isOfficePowerPointExtension(String extension){
  return [
    _extPPT03, _extPPT,
  ].contains(extension.toLowerCase());
}

bool isOfficeExcelExtension(String extension){
  return [
    _extExcel03, _extExcel,
  ].contains(extension.toLowerCase());
}