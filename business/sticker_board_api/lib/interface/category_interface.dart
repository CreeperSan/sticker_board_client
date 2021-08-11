
import 'package:sticker_board_api/model/category_model.dart';

abstract class CategoryInterface{

  void getCategoryList({
    int page = 1,
    int pageSize = 20,
    void Function(List<CategoryModel> tagList)? onSuccess,
    void Function(int code, String message)? onFail,
  });

}