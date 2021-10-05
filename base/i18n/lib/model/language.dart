import 'dart:convert';
import 'dart:io';

import 'package:sprintf/sprintf.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class Language {
  final String displayName;
  final String flag;
  final String language;
  final String location;


  Language({
    required this.displayName,
    required this.flag,
    required this.language,
    required this.location,
  });


  final Map<String, String> _data = {};

  void readFromResources() async {
    // print('----- Read From Resources -----');

    final path = 'assets/i18n/$flag.json';

    ByteData i18nRawData = await rootBundle.load(path);
    final i18nStr = utf8.decode(i18nRawData.buffer.asUint8List(i18nRawData.offsetInBytes, i18nRawData.lengthInBytes));

    final i18nData = json.decoder.convert(i18nStr);
    if(i18nData is Map){
      _data.clear();
      i18nData.forEach((key, value) {
        _data[key.toString()] = value.toString();
        // print('$key -> $value');
      });
    }
  }

  String str(String key){
    return _data[key] ?? key;
  }

  String tr(String key, [dynamic p1, dynamic p2, dynamic p3, dynamic p4, dynamic p5]){
    final value = str(key);
    return sprintf.call(value, [p1, p2, p3, p4, p5]);
  }

}