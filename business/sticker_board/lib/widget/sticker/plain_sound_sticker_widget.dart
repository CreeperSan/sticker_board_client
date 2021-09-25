
import 'package:flutter/material.dart';
import 'package:sticker_board/widget/sticker/common/sticker_widget_common_part_builder.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class PlainSoundStickerWidget extends StatelessWidget{
  final StickerPlainSoundModel model;

  PlainSoundStickerWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                child: Center(
                  child: Icon(Icons.music_note),
                ),
              ),
              Text(model.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 4,
                  bottom: 6,
                ),
                child: Text(model.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),

              // Category & Tags
              StickerWidgetCommonPartBuilder.buildCategoryAndTagPart(model),
            ],
          ),
        ),
      ),
    );
  }

}
