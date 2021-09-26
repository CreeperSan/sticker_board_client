


import 'package:sticker_board_api/sticker_board_api.dart';

class StickerPlainImageModel extends StickerModel{
  String description;
  String imagePath;

  factory StickerPlainImageModel.createEmpty(){
    return StickerPlainImageModel(
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
      description: '',
      imagePath: '',
      category: '',
    );
  }

  StickerPlainImageModel({
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
    required this.imagePath,
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
    return 'StickerPlainImageModel(id=$id, title=$title)';
  }

}
