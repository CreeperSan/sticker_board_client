
import 'package:application_config/api/config_api.dart';
import 'package:application_config/const/const.dart';
import 'package:i18n/i18n.dart';
import 'package:i18n/model/language.dart';
import 'package:kv_storage/kv_storage.dart';

class Config extends ConfigApi {
  static var instance = Config._();

  Config._();


  @override
  String getUID() => KVStorageManager.getString(Const.applicationUID, '');
  @override
  void setUID(String uid) => KVStorageManager.setString(Const.applicationUID, uid);



  @override
  String getToken() => KVStorageManager.getString(Const.applicationToken, '');
  @override
  void setToken(String token) => KVStorageManager.setString(Const.applicationToken, token);


  @override
  String getPrevRunVersionCode() => KVStorageManager.getString(Const.applicationPrevRunVersionCode, '');
  @override
  void setPrevRunVersionCode(String versionCode) => KVStorageManager.setString(Const.applicationPrevRunVersionCode, versionCode);


  @override
  Language getApplicationLanguage() {
    final languageFlag = KVStorageManager.getString(Const.applicationLanguage, languageAutoDetect.flag);
    for(var tmpLanguage in languages){
      if(languageFlag == tmpLanguage.flag){
        return tmpLanguage;
      }
    }
    return languageAutoDetect;
  }
  @override
  void setApplicationLanguage(Language language) {
    KVStorageManager.setString(Const.applicationLanguage, language.flag);
  }



}
