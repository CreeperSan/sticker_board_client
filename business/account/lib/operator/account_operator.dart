
import 'dart:developer';

import 'package:account_api/account_api.dart';
import 'package:network/network.dart';
import 'package:log/log.dart';
import 'package:url_builder/builder/url_builder.dart';

class AccountOperator extends AccountInterface {
  static const TAG = 'AccountOperation';

  // Singleton Pattern

  AccountOperator._();

  static AccountOperator? _instance;

  static _getInstance(){
    if(_instance == null){
      _instance = AccountOperator._();
    }
    return _instance!;
  }

  factory AccountOperator() => _getInstance();

  static AccountOperator get instance => _getInstance();

  // Data

  AccountModel? _accountModel;

  @override
  AccountModel? getAccountInfo() {
    return _accountModel;
  }

  @override
  bool isLogin() {
    return _accountModel == null;
  }


  @override
  Future authToken({
    required String token,
    required String uid,
    required int platform,
    required String brand,
    required String deviceName,
    required String machineCode,
    void Function()? onAuthSuccess,
    void Function()? onAuthFailTokenExpired,
    void Function()? onAuthFailOther,
  }) {
    NetworkManager.instance.fetch(URLBuilder.accountAuthToken(),
      requestMethod: RequestMethod.Post,
      header: {
        'sticker-board-version-code' : '1',
        'sticker-board-uid' : uid,
        'sticker-board-platform' : platform,
        'sticker-board-machine-code' :machineCode,
        'sticker-board-device-name' : deviceName,
        'sticker-board-brand' : brand,
        'sticker-board-token' : token,
      },
      onSuccess: (response){
        print(response);
        print(response.runtimeType);
        if(response['code'] == 200){
          onAuthSuccess?.call();
        } else {
          onAuthFailTokenExpired?.call();
        }
      },
      onFail: (error){
        print(error);
        onAuthFailOther?.call();
      }
    );
    return Future.value();
  }

  @override
  void login({
    required String account,
    required String password,
    required int platform,
    required String brand,
    required String deviceName,
    required String machineCode,
    void Function(AccountModel accountModel)? onSuccess,
    void Function(int code, String message)? onFail,
  }) {
    NetworkManager().fetch(URLBuilder.accountLogin(),
      requestMethod: RequestMethod.Post,
      data: {
        "account" : account,
        "password" : password,
        "platform" : platform,
        "brand" : brand,
        "device_name" : deviceName,
        "machine_code" : machineCode,
      },
      onSuccess: (result){
        LogManager.i('Login network request finish. result = $result', TAG);
        final code = result?['code'] ?? 0;
        if(code == 200){
          final token = result?['data']?['token']?.toString() ?? '';
          final effectiveTime = int.tryParse(result?['data']?['effective_time']?.toString() ?? '') ?? 0;
          final uid = result?['data']?['uid']?.toString() ?? '';
          onSuccess?.call(AccountModel(
            account: account,
            platform: platform,
            brand: brand,
            deviceName: deviceName,
            machineCode: machineCode,
            token: token,
            effectTime: effectiveTime,
            uid: uid,
          ));
        } else {
          final message = result?['msg'] ?? '';
          onFail?.call(code, message);
        }
      },
      onFail: (err){
        LogManager.e('Login network request failed, error = $err', TAG);
        onFail?.call(400, 'Can not connect to server');
      }
    );
  }

  @override
  Future register({
    required String account,
    required String password,
    required String username,
    required String email,
  }) {
    throw UnimplementedError();
  }

}
