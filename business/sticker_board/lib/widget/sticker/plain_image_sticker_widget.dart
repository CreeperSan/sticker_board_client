
import 'package:flutter/material.dart';
import 'package:sticker_board/widget/sticker/common/sticker_widget_common_part_builder.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class PlainImageStickerWidget extends StatelessWidget{
  final StickerPlainImageModel model;
  final void Function()? onClick;

  PlainImageStickerWidget(this.model, {
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget = ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 6,
        ),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            // image: NetworkImage('http://bing.creepersan.com/bing-image/2021/09/04/400x240.jpg'),
            image: NetworkImage(model.imagePath),
            fit: BoxFit.cover,
          ),
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
              Expanded(
                child: Container(),
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
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: StickerWidgetCommonPartBuilder.buildCategoryAndTagPart(model),
              ),
            ],
          ),
        ),
      ),
    );

    if(onClick != null){
      widget = GestureDetector(
        onTap: () => onClick?.call(),
        child: widget,
      );
    }

    return widget;
  }

}
