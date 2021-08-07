import 'package:account_api/interface/account_interface.dart';

class AccountManager{

  AccountManager._();

  static AccountInterface? _instance;

  static void install(AccountInterface accountApi){
    _instance = accountApi;
  }

  static void uninstall(){
    _instance = null;
  }


}

