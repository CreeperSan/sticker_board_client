
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

  CancelToken fetch(String url, {
    RequestMethod requestMethod = RequestMethod.Get,
    Map<String, dynamic> urlParams = const {},
    Map<String, dynamic>? data = const {},
    FormData? formData,
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

  // void testMethod(){
  //   print('Test OSS Upload');
  //
  //   final file = File('/Users/creepersan/Desktop/rock.jpg');
  //   // final file = File('/Users/creepersan/test.kotlin');
  //   print(file.path);
  //   print(file.absolute.path);
  //   print(file.existsSync());
  //
  //   NetworkManager.instance.fetch('http://localhost:8080/api/oss/v1/get_signature',
  //     header: {
  //       'sticker-board-version-code' : '1',
  //       'sticker-board-uid' : '6126e612a9192b1b0c9628be',
  //       'sticker-board-platform' : '1',
  //       'sticker-board-machine-code' : '123456789012345678',
  //       'sticker-board-device-name' : 'Test Device',
  //       'sticker-board-brand' : 'Test Brand',
  //       'sticker-board-token' : '96941ef6-23fd-4752-a3c4-aa3700dea3d6',
  //     },
  //     onSuccess: (data){
  //       print('onSuccess #1');
  //       print(data.runtimeType);
  //       print(data);
  //
  //       print('Uploading file to OSS');
  //
  //       var signatureResult = json.decode(data);
  //       final accessID = signatureResult['accessid'];
  //       final host = signatureResult['host'];
  //       final signature = signatureResult['signature'];
  //       final policy = signatureResult['policy'];
  //       final dir = signatureResult['dir'];
  //       final callback = signatureResult['callback'];
  //
  //       final uploadFormParams = {
  //         'key' : dir + 'rock.jpg',
  //         'policy': policy,
  //         'OSSAccessKeyId': accessID,
  //         'success_action_status' : '200', //让服务端返回200,不然，默认会返回204
  //         'callback' : callback,
  //         'signature': signature,
  //         'contentType': 'multipart/form-data',
  //         'file': MultipartFile.fromFileSync(file.path),
  //       };
  //
  //       NetworkManager.instance._dio.post(
  //           host,
  //           data: FormData.fromMap(uploadFormParams),
  //       ).then((value){
  //         print("Upload File Finish");
  //         print(value);
  //       }).catchError((onError){
  //         print("Upload File Fail");
  //         print(onError);
  //       });
  //     },
  //     onFail: (err){
  //       print('onError #1');
  //       print(err);
  //     }
  //   );
  // }

}
