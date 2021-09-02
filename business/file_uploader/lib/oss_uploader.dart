import 'dart:convert';
import 'dart:io';
import 'package:lifecycle/lifecycle.dart';
import 'package:network/network.dart';
import 'package:device_information/device_information.dart';

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

  //

  void uploadFile(File file, String uid, String token){
    if(!_isCanUpload){
      return;
    }
    // 1. Get key from server
    NetworkManager.instance.fetch('http://localhost:8080/api/oss/v1/get_signature',
      header: {
        'sticker-board-version-code' : '1',
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

        String fileName = 'rock.jpg';
        String fileAbsolutePath = file.absolute.path;
        if(fileAbsolutePath.contains('/')){
          final splitFilePath = fileAbsolutePath.split('/');
          if(splitFilePath.length > 0){
            fileName = splitFilePath.last;
          }
        }

        final uploadFormParams = {
          'key' : dir + DateTime.now().millisecondsSinceEpoch.toString() + fileName,
          'policy': policy,
          'OSSAccessKeyId': accessID,
          'success_action_status' : '200', //让服务端返回200,不然，默认会返回204
          'callback' : callback,
          'signature': signature,
          'contentType': 'multipart/form-data',
          'file': MultipartFile.fromFileSync(file.path),
        };

        NetworkManager.instance.fetch(host,
          formData: FormData.fromMap(uploadFormParams),
          onSuccess: (response){
            print("Upload File Finish");
            print(response);
          },
          onFail: (error){
            print("Upload File Fail");
            print(error);
          },
        );
      },
      onFail: (error){
        print('Upload Fail');
      },
    );
    // 2. Upload file to OSS directory
  }

}
