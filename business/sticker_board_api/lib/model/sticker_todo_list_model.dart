
import 'package:sticker_board_api/sticker_board_api.dart';

class StickerTodoListModel extends StickerModel{
  String description;

  StickerTodoListModel({
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
    required this.description,
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

}

class StickerTodoListItemModel {
  int state;
  String message;
  String description;

  StickerTodoListItemModel({
    required this.message,
    required this.state,
    this.description = '',
  });

}
