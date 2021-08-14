
import 'package:flutter/material.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class CategoryWidget extends StatelessWidget {

  CategoryModel category;

  CategoryWidget(this.category);

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
            child: Icon(Icons.category,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(category.name,
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
