
class CategoryModel {
  String id;
  String parentID;
  String name;
  int createTime;
  int updateTime;
  String icon;
  int color;
  String extra;
  int sort;

  CategoryModel({
    required this.id,
    required this.parentID,
    required this.name,
    required this.createTime,
    required this.updateTime,
    required this.icon,
    required this.color,
    required this.extra,
    required this.sort,
  });

  @override
  String toString() {
    return 'Category(id=$id, name=$name)';
  }

}
