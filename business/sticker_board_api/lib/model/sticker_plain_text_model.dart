


import 'package:sticker_board_api/const/sticker_status.dart';
import 'package:sticker_board_api/const/sticker_type.dart';
import 'package:sticker_board_api/model/sticker_model.dart';

class StickerPlainTextModel extends StickerModel{
  String text;
  
  factory StickerPlainTextModel.createEmpty(){
    return StickerPlainTextModel(
      id: '',
      status: StickerStatus.Pending,
      tags: [],
      star: 0,
      isPinned: false,
      background: '',
      createTime: 0,
      type: StickerType.PlainText,
      updateTime: 0,
      title: '',
      text: '',
      category: '',
    );
  }

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
    required String category,
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

  @override
  String toString() {
    return 'StickerPlainTextModel(id=$id, title=$title)';
  }

}
