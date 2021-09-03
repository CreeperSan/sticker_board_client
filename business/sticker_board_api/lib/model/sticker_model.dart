


class StickerModel {
  String id;
  int status;
  List<String> tags;
  int star;
  bool isPinned;
  String background;
  int createTime;
  int type;
  int updateTime;
  String title;

  StickerModel({
    required this.id,
    required this.status,
    required this.tags,
    required this.star,
    required this.isPinned,
    required this.background,
    required this.createTime,
    required this.type,
    required this.updateTime,
    required this.title,
  });

  @override
  String toString() {
    return 'StickerModel(id=$id, title=$title)';
  }

}
