
import 'package:sticker_board_api/model/sticker_model.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class StickerPlainSoundModel extends StickerModel{
  int duration;
  String description;
  String url;

  factory StickerPlainSoundModel.createEmpty(){
    return StickerPlainSoundModel(
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
      category: '',
      url: '',
      duration: 0,
    );
  }

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
    required String category,
    required this.duration,
    required this.description,
    required this.url,
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
    return 'StickerPlainSoundModel(id=$id, title=$title)';
  }

}
