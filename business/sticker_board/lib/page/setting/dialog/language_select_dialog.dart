
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sticker_board/enum/language.dart';

class LanguageSelectDialog extends Dialog {
  BuildContext? dialogContext;
  void Function(Language language)? onLanguageSelected;

  LanguageSelectDialog({
    this.onLanguageSelected,
  });

  List<dynamic> _data = [
    ['Auto Detect' , Language.AutoDetect,],
    ['English' , Language.English,],
    ['简体中文' , Language.SimplifyChinese,],
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: screenWidth * 0.8,
            maxHeight: screenHeight * 0.8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 22,
                ),
                child: Text('Language Select',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (itemContext, index){
                    final item = _data[index];
                    final displayName = item[0].toString();
                    final language = item[1] as Language;
                    return ListTile(
                      title: Text('$displayName'),
                      onTap: () => _onSelected(language),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSelected(Language language){
    close();
    onLanguageSelected?.call(language);
  }

  LanguageSelectDialog show(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext){
        this.dialogContext = dialogContext;
        return build(context);
      },
    );
    return this;
  }

  void close(){
    final context = dialogContext;
    if(context != null){
      Navigator.pop(context);
      dialogContext = null;
    }
  }

}
