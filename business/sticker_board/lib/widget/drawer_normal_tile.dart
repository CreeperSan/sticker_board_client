
import 'package:flutter/material.dart';

class DrawerNormalTile extends StatelessWidget {
  final void Function()? onClick;
  final Widget? icon;
  final String title;
  final Widget? trailing;

  DrawerNormalTile({
    this.icon,
    this.onClick,
    this.title = '',
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if(icon != null) icon!,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: icon == null ? 0 : 16 ,
              ),
              child: Text(title),
            ),
          ),
          if(trailing != null) trailing!
        ],
      ),
    );

    if(onClick != null) {
      widget = GestureDetector(
        onTap: onClick,
        child: widget,
      );
    }

    return widget;
  }

}

