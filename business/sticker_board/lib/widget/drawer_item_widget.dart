
import 'package:flutter/material.dart';

class DrawerItemWidget extends StatelessWidget{

  Widget? icon;
  String name;
  void Function()? onPressed;
  void Function()? onLongPressed;

  DrawerItemWidget({
    this.icon,
    required this.name,
    this.onPressed,
    this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      onLongPress: onLongPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          children: [
            if(icon != null) Padding(
              padding: EdgeInsets.only(
                right: 16,
              ),
              child: icon,
            ),
            Text(name,
              style: TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

}
