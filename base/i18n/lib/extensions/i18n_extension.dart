import 'package:i18n/manager/i18n.dart';

extension I18nExtension on String{

  String i18n([dynamic p1, dynamic p2, dynamic p3, dynamic p4, dynamic p5]){
    return I18n.instance.tr(this, p1, p2, p3, p4, p5);
  }

  String get tr => I18n.instance.str(this);

}