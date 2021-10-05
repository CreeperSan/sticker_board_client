
import 'package:flutter/material.dart';
import 'package:i18n/i18n.dart';
import 'package:sticker_board/widget/sticker/common/sticker_widget_common_part_builder.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class NotSupportStickerWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(i18n.str('Index_StickerEmptyHint')),
    );
  }

}

