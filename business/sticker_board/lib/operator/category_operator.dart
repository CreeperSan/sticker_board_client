
import 'package:sticker_board_api/sticker_board_api.dart';

class CategoryOperator extends CategoryInterface{

  // Singleton Pattern

  CategoryOperator._();

  static CategoryOperator? _instance;

  static _getInstance(){
    if(_instance == null){
      _instance = CategoryOperator._();
    }
    return _instance!;
  }

  factory CategoryOperator() => _getInstance();

  static CategoryOperator get instance => _getInstance();

  //

  @override
  void getCategoryList({
    int page = 1,
    int pageSize = 20,
    void Function(List<CategoryModel> tagList)? onSuccess,
    void Function(int code, String message)? onFail,
  }) {

  }

}

