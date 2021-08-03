
import 'package:account_api/model/account_model.dart';
import 'package:network/network.dart';

abstract class AccountInterface{

  // Network Request

  void login({
    required String account,
    required String password,
    required int platform,
    required String brand,
    required String deviceName,
    required String machineCode,
    void Function(AccountModel accountModel)? onSuccess,
    void Function(int code, String message)? onFail,
  });

  Future<dynamic> register({
    required String account,
    required String password,
    required String username,
    required String email,
  });

  Future<dynamic> authToken();

  // Get Current Login Info

  bool isLogin();

  AccountModel? getAccountInfo();

}
