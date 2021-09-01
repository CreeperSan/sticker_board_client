
import 'package:account/const/const_account.dart';
import 'package:account/operator/account_operator.dart';
import 'package:account_api/account_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:log/log.dart';
import 'package:device_information/device_information.dart';
import 'package:network/network.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget{
  void Function(LoginSuccessModel loginSuccessModel) onLoginSuccess;

  LoginPage({
    required this.onLoginSuccess,
  });

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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.padding,
              size: 64,
              color: Colors.lightBlue,
            ),
            TextField(
              controller: _accountController,
              decoration: InputDecoration(
                hintText: 'Your Account',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Your Password',
              ),
            ),
            CupertinoButton(
              child: Text('Login',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: _triggerLogin,
            ),
            CupertinoButton(
              child: Text('Register',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: _triggerRegister,
            ),
            CupertinoButton(
              child: Text('Test OSS Upload',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: _testOSSUploadPressed,
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

    // if(accountStr.isEmpty){
    //   ToastManager.show('Account can not be empty.');
    //   return;
    // }
    //
    // if(passwordStr.isEmpty){
    //   ToastManager.show('Password can not be empty.');
    //   return;
    // }

    AccountOperator.instance.login(
      // account: accountStr,
      // password: passwordStr,
      account: 'account_01',
      password: 'Aa888888',
      platform: DeviceInformation.platform,
      brand: DeviceInformation.brand,
      deviceName: DeviceInformation.deviceName,
      machineCode: DeviceInformation.machineCode,
      onSuccess: (accountModel){
        LogManager.i('Login Succeed. Token=${accountModel.token}', ConstAccount.TAG);

        widget.onLoginSuccess.call(LoginSuccessModel(
          account: accountModel.account,
          password: passwordStr,
          token: accountModel.token,
          effectTime: accountModel.effectTime,
          uid: accountModel.uid,
        ));
      },
      onFail: (code, message){
        LogManager.w('Login Failed. Message=$message', ConstAccount.TAG);
        ToastManager.show('Login Fail, $message');
      }
    );
  }

  void _triggerRegister(){
    Navigator.pushNamed(context, '/account/register');
  }

  void _testOSSUploadPressed(){
    NetworkManager.instance.testMethod();
  }

}
