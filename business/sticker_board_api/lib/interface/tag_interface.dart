
import 'package:sticker_board_api/model/tag_model.dart';

abstract class TagInterface{

  void getTagList({
    int page = 1,
    int pageSize = 20,
    void Function(List<TagModel> tagList)? onSuccess,
    void Function(int code, String message)? onFail,
  });

}
