
import 'package:flutter/material.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class TagWidget extends StatelessWidget {

  TagModel tag;

  TagWidget(this.tag);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

}
