
import 'package:flutter/material.dart';
import 'package:i18n/i18n.dart';

class LanguageSelectDialog extends StatelessWidget {
  BuildContext? dialogContext;
  void Function(Language language)? onLanguageSelected;

  LanguageSelectDialog({
    this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Widget dialogWidget = Material(
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
              Container(
                height: 64,
                child: Center(
                  child: Text('Setting_GroupApplicationLanguageDialogTitle'.i18n(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (itemContext, index){
                    final item = languages[index];
                    final displayName = item.displayName;
                    final language = item;
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

    dialogWidget = Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 24,
      ),
      child: dialogWidget,
    );

    return dialogWidget;
  }

  void _onSelected(Language language){
    onLanguageSelected?.call(language);
  }

}
