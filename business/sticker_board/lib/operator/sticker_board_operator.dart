
import 'package:sticker_board_api/sticker_board_api.dart';

class StickerBoardOperator extends StickerBoardInterface{

  // Singleton Pattern

  StickerBoardOperator._();

  static StickerBoardOperator? _instance;

  static _getInstance(){
    if(_instance == null){
      _instance = StickerBoardOperator._();
    }
    return _instance!;
  }

  factory StickerBoardOperator() => _getInstance();

  static StickerBoardOperator get instance => _getInstance();

  //


}
