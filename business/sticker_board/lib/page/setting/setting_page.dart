
import 'package:flutter/material.dart';
import 'package:sticker_board/enum/language.dart';
import 'package:sticker_board/page/setting/dialog/language_select_dialog.dart';
import 'package:sticker_board/page/setting/widget/setting_group_widget.dart';
import 'package:sticker_board/page/setting/widget/setting_tile_widget.dart';
import 'package:toast/manager/toast_manager.dart';

class SettingPage extends StatelessWidget {
  LanguageSelectDialog? _languageSelectDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
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
    ToastManager.show(language.toString());
  }

}
