


import 'package:sticker_board_api/model/sticker_model.dart';

class StickerPlainTextModel extends StickerModel{
  String text;

  StickerPlainTextModel({
    required String id,
    required int status,
    required List<String> tags,
    required int star,
    required bool isPinned,
    required String background,
    required int createTime,
    required int type,
    required int updateTime,
    required String title,
    required this.text,
  }) : super (
    id: id,
    status: status,
    tags: tags,
    star: star,
    isPinned: isPinned,
    background: background,
    createTime: createTime,
    type: type,
    updateTime: updateTime,
    title: title,
  );

  @override
  String toString() {
    return 'StickerPlainTextModel(id=$id, title=$title)';
  }

}
