
import 'package:i18n/interface/localization.dart';

class I18n {

  static I18n instance = I18n._();

  I18n._();

  Map<String, Localization> _localizations = {};
  Localization? _currentLocalization;

  void registerLocalization(Localization localization){
    localization.readFromResources();
    _localizations[localization.getName()] = localization;
  }

  void unregisterLocalization(String name){
    _localizations.remove(name);
    if(name == _currentLocalization?.getName()){
      _currentLocalization = null;
    }
  }

  List<Localization> getSupportedLocalizationList(){
    return _localizations.values.toList();
  }

  void setCurrentLocalization(String name){
    _currentLocalization = _localizations[name];
  }

  String str(String key){
    return _currentLocalization?.str(key) ?? key;
  }

  String tr(String key, [dynamic p1, dynamic p2, dynamic p3, dynamic p4, dynamic p5]){
    return _currentLocalization?.tr(key, p1, p2, p3, p4, p5) ?? key;
  }

}
