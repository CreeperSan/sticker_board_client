import 'package:flutter/material.dart';
import 'package:log/log.dart';
import 'package:network/network.dart';
import 'package:sticker_board/enum/network_loading_state.dart';

class TagAddModule with ChangeNotifier {
  static const TAG = 'TagAddModule';

  NetworkLoadingState tagAddNetworkState = NetworkLoadingState.Idle;

  void addTag({
    required String name,
    String icon = 'icon:tag_default',
    Color color = Colors.black,
    void Function()? onSuccess,
    void Function(int code, String message)? onFail,
  }){
    tagAddNetworkState = NetworkLoadingState.Loading;
    notifyListeners();

    NetworkManager.instance.fetch('http://localhost:8080/api/tag/v1/create',
        requestMethod: RequestMethod.Post,
        data: {
          'tag_name' : name,
          'icon' : icon,
          'color' : color.value,
        },
        onSuccess: (networkResponse){
          LogManager.i('Creating tag through network finish, response=$networkResponse', TAG);

          final responseCode = networkResponse['code'];
          final responseMessage = networkResponse['msg'];

          if(200 == responseCode){
            tagAddNetworkState = NetworkLoadingState.Success;
            notifyListeners();
            onSuccess?.call();
          } else {
            tagAddNetworkState = NetworkLoadingState.Fail;
            notifyListeners();
            onFail?.call(responseCode, responseMessage);
          }

        },
        onFail: (exception){
          LogManager.i('Creating tag through network finish, fail=$exception', TAG);

          tagAddNetworkState = NetworkLoadingState.Fail;
          notifyListeners();
          onFail?.call(0, 'Network error');
        }
    );
  }


}
