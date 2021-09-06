
import 'package:sticker_board_api/sticker_board_api.dart';

abstract class StickerBoardInterface {

  void queryStickerList(int page, int pageSize, {
    void Function(List<StickerModel> stickerList)? onSuccess,
    void Function(int code, String message)? onFail,
  });

}
