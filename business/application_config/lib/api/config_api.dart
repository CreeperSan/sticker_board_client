
import 'package:i18n/i18n.dart';

abstract class ConfigApi {

  String getUID();
  void setUID(String uid);

  String getToken();
  void setToken(String token);

  String getPrevRunVersionCode();
  void setPrevRunVersionCode(String versionCode);

  Language getApplicationLanguage();
  void setApplicationLanguage(Language language);

}
