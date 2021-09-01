import 'package:kv_storage/kv_storage.dart';
import 'package:kv_storage/manager/kv_storage_manager.dart';

class Prefs{

  Prefs._();

  // Application
  static const UID = 'app_current_uid';
  static const Token = 'app_current_token';
  static const PrevVersionCode = 'app_prev_version_code';


}

class PrefsManager {

  PrefsManager._();

  static PrefsManager instance = PrefsManager._();

  // current login user id
  String get uid => KVStorageManager.getString(Prefs.UID, '');
  set uid(String uid) => KVStorageManager.setString(Prefs.UID, uid);

  // current login user token
  String get token => KVStorageManager.getString(Prefs.Token, '');
  set token(String token) => KVStorageManager.setString(Prefs.Token, token);

  // previously installed application version
  int get prevVersion => KVStorageManager.getInt(Prefs.PrevVersionCode, 0);
  set prevVersion(int prevVersion) => KVStorageManager.setInt(Prefs.PrevVersionCode, prevVersion);


}
