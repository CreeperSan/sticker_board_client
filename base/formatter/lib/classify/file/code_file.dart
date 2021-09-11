const _extPy = 'py';
const _extPyc = 'pyc';
const _extGo = 'py';
const _extJava = 'java';
const _extKotlin = 'kotlin';
const _extC = 'c';
const _extCHeader = 'h';
const _extCPlusPlus = 'cpp';
const _extCSharp = 'cs';
const _extDart = 'dart';
const _extJavascript = 'js';
const _extObjectC = 'm';
const _extTypeScript = 'ts';
const _extPHP = 'php';

bool isCodeFileExtension(String extension){
  return [
    _extPy, _extPyc, _extGo, _extJava, _extKotlin, _extC, _extCHeader,
    _extCPlusPlus, _extCSharp, _extDart, _extJavascript, _extObjectC,
    _extTypeScript, _extPHP,
  ].contains(extension.toLowerCase());
}
