
import 'package:flutter/material.dart';

class DrawerHintWidget extends StatelessWidget{
  final String message;

  DrawerHintWidget({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: 16
      ),
      child: Text(message,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }

}
