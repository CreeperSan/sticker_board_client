
import 'package:sticker_board_api/interface/tag_interface.dart';
import 'package:sticker_board_api/interface/category_interface.dart';
import 'package:sticker_board_api/interface/sticker_board_interface.dart';

class TagManager{

  TagManager._();

  static TagInterface? _instance;

  static void install(TagInterface tagApi){
    _instance = tagApi;
  }

  static void uninstall(){
    _instance = null;
  }

  static TagInterface get instance {
    final tmpInstance = _instance;
    if(tmpInstance == null){
      throw Exception('Tag has not been install yet!');
    }
    return tmpInstance;
  }

}


class CategoryManager{

  CategoryManager._();

  static CategoryInterface? _instance;

  static void install(CategoryInterface categoryApi){
    _instance = categoryApi;
  }

  static void uninstall(){
    _instance = null;
  }

  static CategoryInterface get instance {
    final tmpInstance = _instance;
    if(tmpInstance == null){
      throw Exception('Category has not been install yet!');
    }
    return tmpInstance;
  }

}


class StickerBoardManager{

  StickerBoardManager._();

  static StickerBoardInterface? _instance;

  static void install(StickerBoardInterface stickerBoardInterface){
    _instance = stickerBoardInterface;
  }

  static void uninstall(){
    _instance = null;
  }

  static StickerBoardInterface get instance {
    final tmpInstance = _instance;
    if(tmpInstance == null){
      throw Exception('Sticker has not been install yet!');
    }
    return tmpInstance;
  }

}
