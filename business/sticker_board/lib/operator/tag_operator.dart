import 'package:network/manager/network_manager.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class TagOperator extends TagInterface{

  // Singleton Pattern

  TagOperator._();

  static TagOperator? _instance;

  static _getInstance(){
    if(_instance == null){
      _instance = TagOperator._();
    }
    return _instance!;
  }

  factory TagOperator() => _getInstance();

  static TagOperator get instance => _getInstance();

  //

  @override
  void getTagList({
    int page = 1,
    int pageSize = 20,
    void Function(List<TagModel> tagList)? onSuccess,
    void Function(int code, String message)? onFail
  }) {
    NetworkManager.instance.fetch('http://localhost:8080/api/account/v1/login');
  }



}

