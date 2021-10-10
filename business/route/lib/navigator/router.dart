
import 'package:account/account.dart';
import 'package:flutter/material.dart';
import 'package:application_config/application_config.dart';
import 'package:route/navigator/sticker_board_navigator.dart';
import 'package:sticker_board/sticker_board.dart';

class Router {

  StickerBoardNavigator buildLoginPage(BuildContext context, {
    bool autoLogin = false,
  }){
    return StickerBoardNavigator(
      context: context,
      pageBuilder: (routeContext){
        return LoginPage(
          onLoginSuccess: (successModel){
            buildHomePage(context).replace();
          },
          autoLogin: autoLogin,
        );
      }
    );
  }



  StickerBoardNavigator buildHomePage(BuildContext context){
    return StickerBoardNavigator(
      context: context,
      pageBuilder: (routeContext){
        return IndexPage();
      },
    );
  }

}
