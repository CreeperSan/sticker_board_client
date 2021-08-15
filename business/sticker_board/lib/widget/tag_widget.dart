
import 'package:flutter/material.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class TagWidget extends StatelessWidget {

  TagModel tag;
  void Function(TagModel categoryModel)? onPressed;
  void Function(TagModel categoryModel)? onLongPressed;

  TagWidget(this.tag, {
    this.onPressed,
    this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed?.call(tag),
      onLongPress: () => onLongPressed?.call(tag),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        height: 50,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 16,
              ),
              child: Icon(Icons.tag,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: Text(tag.name,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
