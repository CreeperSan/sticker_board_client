
import 'package:kv_storage/controller/error_kv_storage.dart';
import 'package:kv_storage/controller/shared_preferences_kv_storage.dart';
import 'package:kv_storage/interface/i_kv_storage.dart';

class KVStorageManager{

  KVStorageManager._();

  static IKVStorage? _storage;

  static Future<bool> initialize() async {
    try {
      final spStorage = SharedPreferencesKVStorage();
      final initializeResult = await spStorage.initialize();
      if(initializeResult){
        throw Exception('KVStorage initialize error.');
      }
      _storage = spStorage;
      return true;
    } catch (e) {
      print(e);
      final errorKVStorage = ErrorKVStorage();
      final initializeResult = await errorKVStorage.initialize();
      if(initializeResult){
        _storage = errorKVStorage;
      }
      return false;
    }
  }

  static void setBool(String key, bool value){
    _storage?.setBool(key, value);
  }

  static void setInt(String key, int value){
    _storage?.setInt(key, value);
  }

  static void setDouble(String key, double value){
    _storage?.setDouble(key, value);
  }

  static void setString(String key, String value){
    _storage?.setString(key, value);
  }

  static bool getBool(String key, bool value){
    return _storage?.getBool(key, value) ?? value;
  }

  static int getInt(String key, int value){
    return _storage?.getInt(key, value) ?? value;
  }

  static double getDouble(String key, double value){
    return _storage?.getDouble(key, value) ?? value;
  }

  static String getString(String key, String value){
    return _storage?.getString(key, value) ?? value;
  }


}

