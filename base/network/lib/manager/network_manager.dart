
import 'package:dio/dio.dart';
import 'package:network/enum/request_method.dart';
import 'package:network/model/network_response.dart';

class NetworkManager {

  /// Singleton Pattern

  factory NetworkManager() => _getInstance();

  static NetworkManager? _instance;

  static NetworkManager _getInstance(){
    if(_instance == null){
      _instance = NetworkManager._internal();
    }
    return _instance!;
  }

  ///

  late Dio _dio;

  NetworkManager._internal(){
    _dio = Dio();
  }

  Future<CancelToken> fetch(String url, {
    RequestMethod requestMethod = RequestMethod.Get,
    Map<String, dynamic> urlParams = const {},
    Map<String, dynamic> data = const {},
    Map<String, dynamic> header = const {},
    void Function(dynamic data)? onSuccess,
    void Function(dynamic exception)? onFail,
    void Function(int count, int total)? onSendProgress,
    void Function(int count, int total)? onReceiveProgress,
  }){
    CancelToken cancelToken = CancelToken();
    switch(requestMethod){
      case RequestMethod.Get: {
        _dio.get(url,
          queryParameters: urlParams,
          options: Options(
            headers: header,
          ),
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        ).then((value){
          onSuccess?.call(value.data);
        }).catchError((exception){
          onFail?.call(exception);
        });
        break;
      }
      case RequestMethod.Post: {
        _dio.post(url,
          data: data,
          queryParameters: urlParams,
          options: Options(
            headers: header,
          ),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ).then((value){
          onSuccess?.call(value.data);
        }).catchError((exception){
          onFail?.call(exception);
        });
        break;
      }
      default: {
        throw Exception('Request Method Not Yet Supported! method=$requestMethod');
      }
    }

    return Future.value(cancelToken);
  }

}
