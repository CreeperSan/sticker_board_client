
import 'package:flutter/material.dart';
import 'package:sticker_board/widget/sticker/common/sticker_widget_common_part_builder.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class PlainTextStickerWidget extends StatelessWidget{

  final StickerPlainTextModel model;
  final void Function()? onClick;

  PlainTextStickerWidget(this.model, {
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 6,
      ),
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          if(model.title.isNotEmpty) Padding(
            padding: EdgeInsets.only(
              bottom: 12,
              left: 12,
              right: 12,
            ),
            child: Text(model.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),

          // Message
          if(model.text.isNotEmpty) Padding(
            padding: EdgeInsets.only(
              bottom: 12,
              left: 12,
              right: 12,
            ),
            child: Text(model.text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ),

          // Category & Tags
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: StickerWidgetCommonPartBuilder.buildCategoryAndTagPart(model),
          ),

        ],
      ),
    );
  }

}

