
import 'package:flutter/material.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class CategoryWidget extends StatelessWidget {

  CategoryModel category;
  void Function(CategoryModel categoryModel)? onPressed;
  void Function(CategoryModel categoryModel)? onLongPressed;

  CategoryWidget(this.category, {
    this.onPressed,
    this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed?.call(category),
      onLongPress: () => onLongPressed?.call(category),
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
      ),
    );
  }

}
