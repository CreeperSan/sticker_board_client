
import 'package:account_api/account_api.dart';
import 'package:network/network.dart';

class AccountManager extends AccountInterface {

  // Singleton Pattern

  AccountManager._();

  static AccountManager? _instance;

  static _getInstance(){
    if(_instance == null){
      _instance = AccountManager._();
    }
    return _instance!;
  }

  factory AccountManager() => _getInstance();

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
  Future authToken() {
    throw UnimplementedError();
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
    NetworkManager().fetch('http://localhost:8080/api/account/v1/login',
      requestMethod: RequestMethod.Post,
      header: {
        'version_code' : 1,
        'platform' : 1,
      },
      data: {
        "account" : account,
        "password" : password,
        "platform" : platform,
        "brand" : brand,
        "device_name" : deviceName,
        "machine_code" : machineCode,
      },
      onSuccess: (result){
        final code = result?['code'] ?? 0;
        if(code == 200){
          final token = result?['data']?['token']?.toString() ?? '';
          final effectiveTime = int.tryParse(result?['data']?['effective_time']?.toString() ?? '') ?? 0;
          onSuccess?.call(AccountModel(
            account: account,
            platform: platform,
            brand: brand,
            deviceName: deviceName,
            machineCode: machineCode,
            token: token,
            effectTime: effectiveTime,
          ));
        } else {
          final message = result?['msg'] ?? '';
          onFail?.call(code, message);
        }
      },
      onFail: (err){
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