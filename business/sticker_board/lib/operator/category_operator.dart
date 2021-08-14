
import 'package:network/network.dart';
import 'package:sticker_board_api/sticker_board_api.dart';
import 'package:log/log.dart';

class CategoryOperator extends CategoryInterface{
  static const TAG = "TagOperator";

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
    void Function(List<CategoryModel> categoryList)? onSuccess,
    void Function(int code, String message)? onFail,
  }) {
    NetworkManager.instance.fetch('http://localhost:8080/api/category/v1/list',
        requestMethod: RequestMethod.Post,
        onSuccess: (response){
          LogManager.d('get category list by network finish. response -> $response', TAG);
          List<CategoryModel> categoryModelList = [];
          final responseCode = response['code'] ?? 0;
          final responseMessage = response['msg'] ?? 'Error while getting categories, please try again later.';
          if (200 == responseCode) {
            final responseData = response['data'] as List<dynamic>;
            responseData.forEach((dataItem) {
              CategoryModel categoryModel = CategoryModel(
                parentID: dataItem['parent_id'],
                id: dataItem['category_id'],
                createTime: dataItem['create_time'],
                updateTime: dataItem['update_time'],
                name: dataItem['name'],
                icon: dataItem['icon'],
                color: dataItem['color'],
                extra: dataItem['extra'],
                sort: dataItem['sort'],
              );
              categoryModelList.add(categoryModel);
            });
            onSuccess?.call(categoryModelList);
          } else {
            onFail?.call(responseCode, responseMessage);
          }
        },
        onFail: (dynamic){
          LogManager.d('get category list by network failed. err -> $dynamic', TAG);
          onFail?.call(0, 'Network connection failed.');
        }
    );
  }

}

