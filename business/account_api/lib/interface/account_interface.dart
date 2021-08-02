
import 'package:account_api/model/account_model.dart';

abstract class AccountInterface{

  Future<AccountModel> getAccount();

}
