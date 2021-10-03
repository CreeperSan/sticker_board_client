

import 'package:flutter/material.dart';

class SettingGroupWidget extends StatelessWidget {
  final Widget? titleWidget;
  final String title;

  SettingGroupWidget({
    this.title = '',
    this.titleWidget,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: titleWidget ?? Text(title,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 14,
        ),
      ),
    );
  }

}
