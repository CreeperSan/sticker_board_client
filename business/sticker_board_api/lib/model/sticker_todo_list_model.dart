
import 'package:sticker_board_api/sticker_board_api.dart';

class StickerTodoListModel extends StickerModel{
  String description;
  List<StickerTodoListItemModel> todoList;

  factory StickerTodoListModel.createEmpty(){
    return StickerTodoListModel(
      description: '',
      todoList: [],
      id: '',
      status: StickerStatus.Pending,
      tags: [],
      star: 0,
      isPinned: false,
      background: '',
      createTime: 0,
      type: StickerType.TodoList,
      updateTime: 0,
      title: '',
      category: '',
    );
  }

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
    required String category,
    required this.description,
    required this.todoList,
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
    category: category,
  );

}

class StickerTodoListItemModel {
  static const STATE_PENDING = 0;
  static const STATE_FINISH = 1;

  int state;
  String message;
  String description;

  bool get isFinish => state == STATE_FINISH;

  StickerTodoListItemModel({
    required this.message,
    required this.state,
    this.description = '',
  });

}
