
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

}
