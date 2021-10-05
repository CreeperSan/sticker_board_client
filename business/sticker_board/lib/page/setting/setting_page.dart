
import 'package:flutter/material.dart';
import 'package:sticker_board/enum/language.dart';
import 'package:sticker_board/page/setting/dialog/language_select_dialog.dart';
import 'package:sticker_board/page/setting/widget/setting_group_widget.dart';
import 'package:sticker_board/page/setting/widget/setting_tile_widget.dart';
import 'package:toast/manager/toast_manager.dart';
import 'package:i18n/i18n.dart';

class SettingPage extends StatelessWidget {
  LanguageSelectDialog? _languageSelectDialog;

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
              title: 'Application',
            ),
            SettingTileWidget(
              leading: Icon(Icons.translate),
              trailing: Text('Auto Detect',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              content: Text('Language',
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

  /// Application language

  void _onLanguageClick(BuildContext context){
    _languageSelectDialog?.close();
    _languageSelectDialog = LanguageSelectDialog(
      onLanguageSelected: _onLanguageSelected,
    ).show(context);
  }

  void _onLanguageSelected(Language language){
    switch(language){
      case Language.SimplifyChinese: {
        i18n.setCurrentLocalization('简体中文');
        break;
      }
      case Language.English: {
        i18n.setCurrentLocalization('English');
        break;
      }
      case Language.AutoDetect: {
        ToastManager.show('TODO');
        break;
      }
    }
  }

}
