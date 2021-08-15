import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:sticker_board/enum/network_loading_state.dart';
import 'package:log/log.dart';

class CategoryAddModule with ChangeNotifier{
  static const TAG = 'CategoryAddModule';

  NetworkLoadingState addCategoryNetworkState = NetworkLoadingState.Idle;

  void addCategory({
    required String name,
    String icon = 'icon:category_default',
    Color color = Colors.black,
    void Function()? onSuccess,
    void Function(int code, String message)? onFail,
  }){
    addCategoryNetworkState = NetworkLoadingState.Loading;
    notifyListeners();

    NetworkManager.instance.fetch('http://localhost:8080/api/category/v1/create',
      requestMethod: RequestMethod.Post,
      data: {
        'category_name' : name,
        'icon' : icon,
        'color' : color.value,
      },
      onSuccess: (networkResponse){
        LogManager.i('Creating category through network finish, response=$networkResponse', TAG);

        final responseCode = networkResponse['code'];
        final responseMessage = networkResponse['msg'];

        if(200 == responseCode){
          addCategoryNetworkState = NetworkLoadingState.Success;
          notifyListeners();
          onSuccess?.call();
        } else {
          addCategoryNetworkState = NetworkLoadingState.Fail;
          notifyListeners();
          onFail?.call(responseCode, responseMessage);
        }

      },
      onFail: (exception){
        LogManager.i('Creating category through network finish, fail=$exception', TAG);

        addCategoryNetworkState = NetworkLoadingState.Fail;
        notifyListeners();
        onFail?.call(0, 'Network error');
      }
    );
  }


}
