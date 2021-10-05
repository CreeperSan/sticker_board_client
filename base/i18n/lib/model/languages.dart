
import 'package:i18n/model/language.dart';

final languageAutoDetect = Language(
    displayName: 'Auto Detect',
    flag: '',
    language: '',
    location: '',
);

final languageEnglishAmerica = Language(
    displayName: 'English',
    flag: 'en_US',
    language: 'en',
    location: 'US',
);

final languageSimplifyChinese = Language(
    displayName: '简体中文',
    flag: 'zh_CN',
    language: 'zh',
    location: 'CN',
);

final languages = [
    languageAutoDetect,
    languageEnglishAmerica,
    languageSimplifyChinese,
];
