
import 'package:i18n/i18n.dart';

class I18n {

  static I18n instance = I18n._();

  I18n._();

  final Map<String, Language> _localizations = {};
  Language? _currentLocalization;

  void registerLocalization(Language localization){
    _localizations[localization.flag] = localization;
  }

  void unregisterLocalization(Language localization){
    _localizations.remove(localization.flag);
    if(localization.flag == _currentLocalization?.flag){
      _currentLocalization = null;
    }
  }

  List<Language> getSupportedLocalizationList(){
    return _localizations.values.toList();
  }

  void setCurrentLocalization(Language language){
    final localization = _localizations[language.flag];
    localization?.readFromResources();
    _currentLocalization = localization;
  }

  String str(String key){
    return _currentLocalization?.str(key) ?? key;
  }

  String tr(String key, [dynamic p1, dynamic p2, dynamic p3, dynamic p4, dynamic p5]){
    return _currentLocalization?.tr(key, p1, p2, p3, p4, p5) ?? key;
  }

}
