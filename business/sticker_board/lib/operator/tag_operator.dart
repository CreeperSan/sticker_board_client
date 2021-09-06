import 'package:log/log.dart';
import 'package:network/enum/request_method.dart';
import 'package:network/manager/network_manager.dart';
import 'package:sticker_board_api/sticker_board_api.dart';
import 'package:url_builder/url_builder.dart';

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
    NetworkManager.instance.fetch(URLBuilder.stickerListTag(),
      requestMethod: RequestMethod.Post,
      onSuccess: (response){
        LogManager.d('get tag list by network finish. response -> $response', TAG);
        List<TagModel> tagModelList = [];
        final responseCode = response['code'] ?? 0;
        final responseMessage = response['msg'] ?? 'Error while getting tags, please try again later.';
        if (200 == responseCode) {
          final responseData = response['data'] as List<dynamic>;
          responseData.forEach((dataItem) {
            TagModel tagModel = TagModel(
              id: dataItem['tag_id'] ?? '',
              createTime: dataItem['create_time'] ?? 0,
              updateTime: dataItem['update_time'] ?? 0,
              name: dataItem['name'] ?? '',
              icon: dataItem['icon'] ?? '',
              color: dataItem['color'] ?? 0,
              extra: dataItem['extra'] ?? '',
              sort: dataItem['sort'] ?? 10000,
            );
            tagModelList.add(tagModel);
          });
          onSuccess?.call(tagModelList);
        } else {
          onFail?.call(responseCode, responseMessage);
        }
      },
      onFail: (dynamic){
        LogManager.d('get tag list by network failed. err -> $dynamic', TAG);
        onFail?.call(0, 'Network connection failed.');
      }
    );
  }



}

