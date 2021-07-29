
import 'package:kv_storage/interface/i_kv_storage.dart';

class ErrorKVStorage extends IKVStorage {
  final Map<String, dynamic> _data = {};

  @override
  Future<bool> initialize() => Future.value(true);

  @override
  bool getBool(String key, [bool defaultValue = false]) {
    return _data[key] ?? defaultValue;
  }

  @override
  double getDouble(String key, [double defaultValue = 0.0]) {
    return _data[key] ?? defaultValue;
  }

  @override
  int getInt(String key, [int defaultValue = 0]) {
    return _data[key] ?? defaultValue;
  }

  @override
  String getString(String key, [String defaultValue = '']) {
    return _data[key] ?? defaultValue;
  }

  @override
  void setBool(String key, bool value) {
    _data[key] = value;
  }

  @override
  void setDouble(String key, double value) {
    _data[key] = value;
  }

  @override
  void setInt(String key, int value) {
    _data[key] = value;
  }

  @override
  void setString(String key, String value) {
    _data[key] = value;
  }



}
