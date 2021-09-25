
import 'package:flutter/material.dart';
import 'package:sticker_board/cache/sticker_category_cache.dart';
import 'package:sticker_board/cache/sticker_tag_cache.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class StickerWidgetCommonPartBuilder {

  StickerWidgetCommonPartBuilder._();


  /// Build bottom category and tag widget
  static Widget buildCategoryAndTagPart(StickerModel stickerModel){
    List<Widget> children = [];

    Widget wrapWithPadding(Widget child){
      return Padding(
        padding: EdgeInsets.only(
          right: 4,
        ),
        child: child,
      );
    }

    final categoryModel = StickerCategoryCache.instance.getCategoryModel(stickerModel.category);
    if(categoryModel != null){
      children.add(wrapWithPadding(Chip(
        label: Text(categoryModel.name),
        avatar: Icon(Icons.category),
        padding: EdgeInsets.only(
          top: 2,
          bottom: 2,
          right: 4,
        ),
      )));
    }

    for(var tagID in stickerModel.tags){
      final tagModel = StickerTagCache.instance.getTagModel(tagID);
      if(tagModel != null) {
        children.add(wrapWithPadding(Chip(
          label: Text(tagModel.name),
          avatar: Icon(Icons.tag),
          padding: EdgeInsets.only(
            top: 4,
            bottom: 4,
            right: 6,
            left: 6,
          ),
        )));
      }
    }

    return Wrap(
      direction: Axis.horizontal,
      children: children,
    );
  }

}
