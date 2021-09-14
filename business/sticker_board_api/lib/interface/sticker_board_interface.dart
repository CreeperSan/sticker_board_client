
import 'package:sticker_board_api/sticker_board_api.dart';

abstract class StickerBoardInterface {

  void queryStickerList(int page, int pageSize, {
    void Function(List<StickerModel> stickerList)? onSuccess,
    void Function(int code, String message)? onFail,
  });

  void createStickerPlainImage({
    status = StickerStatus.Processing,
    String category = '',
    List<String> tags = const [],
    int star = 0,
    bool isPinned = false,
    String background = '',
    String title = '',
    String description = '',
    required String imagePath,
    void Function()? onSuccess,
    void Function(int code, String message)? onFail,
  });

  Future<CreatePlainSoundStickerResponse> createStickerPlainSound({
    required String soundPath,
    required int duration,
    status = StickerStatus.Processing,
    String category = '',
    List<String> tags = const [],
    int star = 0,
    bool isPinned = false,
    String background = '',
    String title = '',
    String description = '',
  });

}
