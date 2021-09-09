import 'dart:convert';
import 'dart:io';
import 'package:lifecycle/lifecycle.dart';
import 'package:network/network.dart';
import 'package:device_information/device_information.dart';
import 'package:url_builder/url_builder.dart';
import 'package:formatter/formatter.dart';

class OSSUploader {

  static OSSUploader? _instance;

  OSSUploader._();

  static OSSUploader get instance {
    var tmpInstance = _instance;
    if(tmpInstance == null){
      tmpInstance = OSSUploader._();
      _instance = tmpInstance;
    }
    return tmpInstance;
  }

  bool _isCanUpload = false;

  void initialize(){
    LifecycleNotifier.instance.subscribe(LifecycleSubscriber(Lifecycle.OnLogin,
      onEvent: (lifeCycle){
        _isCanUpload = true;
      },
    ));
    LifecycleNotifier.instance.subscribe(LifecycleSubscriber(Lifecycle.OnLogout,
      onEvent: (lifeCycle){
        _isCanUpload = false;
      },
    ));
  }

  // TODO : make this method return a Future
  void uploadFile(File file, String uid, String token, String action,{
    void Function(String path, String bucket)? onSuccess,
    void Function(int code, String message)? onFail,
  }){
    // if(!_isCanUpload){
    //   return;
    // }
    // 1. Get key from server
    NetworkManager.instance.fetch(URLBuilder.ossGetSignature(action),
      header: {
        'sticker-board-version-code' : '1', // TODO : fix this value later
        'sticker-board-uid' : uid,
        'sticker-board-platform' : DeviceInformation.platform,
        'sticker-board-machine-code' :DeviceInformation.machineCode,
        'sticker-board-device-name' : DeviceInformation.deviceName,
        'sticker-board-brand' : DeviceInformation.brand,
        'sticker-board-token' : token,
      },
      onSuccess: (data){
        var signatureResult = json.decode(data);
        final accessID = signatureResult['accessid'];
        final host = signatureResult['host'];
        final signature = signatureResult['signature'];
        final policy = signatureResult['policy'];
        final dir = signatureResult['dir'];
        final callback = signatureResult['callback'];

        final fileKey = dir + DateTime.now().millisecondsSinceEpoch.toString() + '.' + file.path.pathFileExtension();

        final uploadFormParams = {
          'key' : fileKey,
          'policy': policy,
          'OSSAccessKeyId': accessID,
          'success_action_status' : '200', // make oss server return 200 or else oss server will return 204 by default
          'callback' : callback,
          'signature': signature,
          'contentType': 'multipart/form-data',
          'file': MultipartFile.fromFileSync(file.path),
        };

        // 2. Upload file to OSS directory
        NetworkManager.instance.fetch(host,
          requestMethod: RequestMethod.Post,
          formData: FormData.fromMap(uploadFormParams),
          onSuccess: (response){
            print("Upload File Finish");
            print(response);
            if(response['Status'] == 'OK'){
              onSuccess?.call(fileKey, host);
            } else {
              onFail?.call(0, 'Upload failed, please try again');
            }
          },
          onFail: (error){
            print("Upload File Fail");
            print(error);

            onFail?.call(0, 'Upload failed, please try again later');
          },
        );
      },
      onFail: (error){
        print('Upload Fail, can not get signature key.');
        onFail?.call(0, 'Upload failed, please try again later');
      },
    );
  }

}
