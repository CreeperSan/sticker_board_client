

class StickerFilterModel{
  List<String> tag = [];
  List<String> category = [];

  void reset(){
    tag.clear();
    category.clear();
  }

  bool filterTag(String tagID){
    tagID = tagID.trim();
    if(tag.contains(tagID)){
      return false;
    }
    tag.add(tagID);
    return true;
  }

  bool filterCategory(String categoryID){
    categoryID = categoryID.trim();
    if(category.contains(categoryID)){
      return false;
    }
    category.add(categoryID);
    return true;
  }

}
