
import 'package:flutter/material.dart';
import 'package:kv_storage/interface/i_kv_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesKVStorage extends IKVStorage {
  late SharedPreferences _prefs;

  @override
  Future<bool> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }



  @override
  bool getBool(String key, [bool defaultValue = false]) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  @override
  double getDouble(String key, [double defaultValue = 0.0]) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  @override
  int getInt(String key, [int defaultValue = 0]) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  @override
  String getString(String key, [String defaultValue = '']) {
    return _prefs.getString(key) ?? defaultValue;
  }



  @override
  void setBool(String key, bool value) {
    _prefs.setBool(key, value);
  }

  @override
  void setDouble(String key, double value) {
    _prefs.setDouble(key, value);
  }

  @override
  void setInt(String key, int value) {
    _prefs.setInt(key, value);
  }

  @override
  void setString(String key, String value) {
    _prefs.setString(key, value);
  }

  @override
  void remove(String key) {
    _prefs.remove(key);
  }

}
