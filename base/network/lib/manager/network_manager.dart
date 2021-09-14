
import 'dart:convert';
import 'dart:io';

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

  static NetworkManager get instance => _getInstance();

  ///

  late Dio _dio;
  late BaseOptions _dioBaseOptions;

  NetworkManager._internal(){
    _dio = Dio();
    _dioBaseOptions = BaseOptions();

    _dio.options = _dioBaseOptions;
  }

  @Deprecated('')
  CancelToken fetch(String url, {
    RequestMethod requestMethod = RequestMethod.Get,
    Map<String, dynamic> urlParams = const {},
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic> header = const {},
    void Function(dynamic data)? onSuccess,
    void Function(dynamic exception)? onFail,
    void Function(int count, int total)? onSendProgress,
    void Function(int count, int total)? onReceiveProgress,
  }){
    print('Network Request -> URL=$url');
    print('Network Request -> data=$data');
    print('Network Request -> form=${formData?.fields}');
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
          data: data ?? formData,
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

    return cancelToken;
  }

  void setCommonHeader(Map<String, dynamic> header){
    _dio.options.headers = header;
  }




  Future<Response> rawFetch(String url, {
    RequestMethod requestMethod = RequestMethod.Get,
    Map<String, dynamic>? urlData,
    Map<String, dynamic>? jsonData,
    Map<String, dynamic>? customHeader,
    FormData? formData,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    int? timeout,
  }){
    switch(requestMethod){
      case RequestMethod.Get:
        return _dio.get(url,
          queryParameters: urlData,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          options: Options(
            headers: customHeader,
            receiveTimeout: timeout,
            sendTimeout: timeout,
          ),
        );
      case RequestMethod.Post:
        return _dio.post(url,
          queryParameters: urlData,
          data: jsonData ?? formData,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          options: Options(
            headers: customHeader,
            receiveTimeout: timeout,
            sendTimeout: timeout,
          )
        );
    }
  }

}
