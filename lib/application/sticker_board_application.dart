import 'package:account_api/account_api.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:sticker_board_client/const/application_const.dart';
import 'package:account/account.dart';
import 'package:sticker_board_client/const/router_const.dart';
import 'package:toast/manager/toast_manager.dart';
import 'package:version/version.dart';
import 'package:splash_screen/splash_screen.dart';
import 'package:sticker_board/sticker_board.dart' as StickerBoard;

class StickerBoardApplication extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print(DeviceInformation.platform);

    return MaterialApp(
      title: ApplicationConst.ApplicationName,
      initialRoute: RouterConst.SplashScreen,
      routes: {
        // Splash Screen
        RouterConst.SplashScreen : (context, [params]) => SplashScreenPage(
          onInitialize: _onSplashScreenPageInitialize,
          onInitializeFinish: (response) => _onSplashScreenPageInitializeFinish(context, response),
        ),

        // Version
        RouterConst.VersionHistory : (context, [params]) => VersionHistoryPage(),

        // Login
        RouterConst.AccountLogin : (context, [params]) => LoginPage(
          onLoginSuccess: (model) => _onLoginSuccess(context, model),
        ),
        RouterConst.AccountRegister : (context, [params]) => RegisterPage(),

        // Sticker Board
        RouterConst.StickerBoardIndex : (context, [params]) => StickerBoard.IndexPage(),
        RouterConst.StickerBoardCategoryList : (context, [params]) => StickerBoard.CategoryPage(),
        RouterConst.StickerBoardCategoryAdd : (context, [params]) => StickerBoard.CategoryAddPage(),
        RouterConst.StickerBoardTagList : (context, [params]) => StickerBoard.TagPage(),
        RouterConst.StickerBoardTagAdd : (context, [params]) => StickerBoard.TagAddPage(),
        RouterConst.StickerBoardSimpleTextAdd : (context, [params]) => StickerBoard.SimpleTextAddPage(),
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
    Navigator.pushReplacementNamed(context, RouterConst.AccountLogin);
  }

  /// Login

  /// Login Success
  void _onLoginSuccess(BuildContext context, LoginSuccessModel loginSuccessModel){
    ToastManager.show('Login Success, Token = ${loginSuccessModel.token}');
    Navigator.pushReplacementNamed(context, RouterConst.StickerBoardIndex);
  }

}



