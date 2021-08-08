import 'package:account_api/account_api.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:sticker_board_client/const/application_const.dart';
import 'package:account/account.dart';
import 'package:toast/manager/toast_manager.dart';
import 'package:version/version.dart';
import 'package:splash_screen/splash_screen.dart';

class StickerBoardApplication extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print(DeviceInformation.platform);

    return MaterialApp(
      title: ApplicationConst.ApplicationName,
      initialRoute: '/',
      routes: {
        '/' : (context, [params]) => SplashScreenPage(
          onInitialize: _onSplashScreenPageInitialize,
          onInitializeFinish: (response) => _onSplashScreenPageInitializeFinish(context, response),
        ),
        '/version' : (context, [params]) => VersionHistoryPage(),
        '/account' : (context, [params]) => LoginPage(
          onLoginSuccess: _onLoginSuccess,
        ),
        '/account/register' : (context, [params]) => RegisterPage(),
      },
    );
  }

  /// Splash Screen

  /// Initialize
  Future<dynamic> _onSplashScreenPageInitialize() async {
    await Future.delayed(Duration(seconds: 1));
    return 0;
  }

  /// Finish Initialize
  void _onSplashScreenPageInitializeFinish(BuildContext context, dynamic initResponse){
    Navigator.pushReplacementNamed(context, '/account');
  }

  /// Login

  /// Login Success
  void _onLoginSuccess(LoginSuccessModel loginSuccessModel){
    ToastManager.show('Login Success, Token = ${loginSuccessModel.token}');
  }

}



