import 'package:log/log.dart';
import 'package:network/enum/request_method.dart';
import 'package:network/manager/network_manager.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class TagOperator extends TagInterface{
  static const TAG = "TagOperator";

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
    NetworkManager.instance.fetch('http://localhost:8080/api/tag/v1/list',
      requestMethod: RequestMethod.Post,
      onSuccess: (dynamic){
        LogManager.d('get tag list by network finish. response -> $dynamic', TAG);
      },
      onFail: (dynamic){
        LogManager.d('get tag list by network failed. err -> $dynamic', TAG);
      }
    );
  }



}

