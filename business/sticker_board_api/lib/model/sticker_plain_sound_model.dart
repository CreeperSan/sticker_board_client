
import 'package:sticker_board_api/model/sticker_model.dart';

class StickerPlainSoundModel extends StickerModel{
  int duration;
  String description;
  String imagePath;

  StickerPlainSoundModel({
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
    required this.duration,
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
  );

  @override
  String toString() {
    return 'StickerPlainSoundModel(id=$id, title=$title)';
  }

}