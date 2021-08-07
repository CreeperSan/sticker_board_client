
import 'package:account/const/const_account.dart';
import 'package:account/operator/account_operator.dart';
import 'package:flutter/material.dart';
import 'package:log/log.dart';
import 'package:device_information/device_information.dart';

class LoginPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }

}

class _LoginPageState extends State<LoginPage>{
  late TextEditingController _accountController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    LogManager.initialize();

    _accountController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _accountController,
            ),
            TextField(
              controller: _passwordController,
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_rounded),
              onPressed: _triggerLogin,
            ),
          ],
        ),
      ),
    );
  }

  void _triggerLogin(){
    LogManager.i('Trigger Login', ConstAccount.TAG);
    LogManager.i('Logging in', ConstAccount.TAG);

    final accountStr = _accountController.text;
    final passwordStr = _passwordController.text;

    AccountOperator().login(
      account: accountStr,
      password: passwordStr,
      platform: DeviceInformation.platformInt,
      brand: DeviceInformation.brand,
      deviceName: DeviceInformation.deviceName,
      machineCode: DeviceInformation.machineCode,
      onSuccess: (accountModel){
        LogManager.i('Login Succeed. Token=${accountModel.token}', ConstAccount.TAG);
      },
      onFail: (code, message){
        LogManager.w('Login Failed. Message=$message', ConstAccount.TAG);
      }
    );
  }

}
