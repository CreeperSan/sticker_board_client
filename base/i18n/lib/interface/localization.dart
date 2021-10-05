import 'dart:convert';
import 'dart:io';

import 'package:sprintf/sprintf.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

abstract class Localization {
  static const symbol = '%s';

  final Map<String, String> _data = {};

  String getName();

  String getPath();

  void readFromResources() async {
    // print('----- Read From Resources -----');

    ByteData i18nRawData = await rootBundle.load(getPath());
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
