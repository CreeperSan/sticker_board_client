
import 'package:application_config/application_config.dart';
import 'package:flutter/material.dart';
import 'package:sticker_board/page/setting/dialog/language_select_dialog.dart';
import 'package:sticker_board/page/setting/widget/setting_group_widget.dart';
import 'package:sticker_board/page/setting/widget/setting_tile_widget.dart';
import 'package:toast/manager/toast_manager.dart';
import 'package:i18n/i18n.dart';

class SettingPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }

}

class _SettingPageState extends State<SettingPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Setting'),
        title: Text(i18n.str('Setting_SettingPage')),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Application Setting
            SettingGroupWidget(
              title: 'Setting_GroupApplication'.i18n(),
            ),
            SettingTileWidget(
              leading: Icon(Icons.translate),
              trailing: Text(config.getApplicationLanguage().displayName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              content: Text('Setting_GroupApplicationLanguage'.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              onClick: () => _onLanguageClick(context),
            ),

          ],
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Application language
  ///
  void _onLanguageClick(BuildContext context){
    showDialog(context: context, builder: (dialogContext){
      return LanguageSelectDialog(
        onLanguageSelected: _onLanguageSelected,
      );
    });
  }
  void _onLanguageSelected(Language language){
    Navigator.pop(context);

    i18n.setCurrentLocalization(language);
    config.setApplicationLanguage(language);

    setState(() { });

    ToastManager.show('Setting_GroupApplicationLanguageChangeHint'.tr);
  }
}
