import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:sticker_board_client/const/application_const.dart';
import 'package:account/account.dart';
import 'package:version/version.dart';
import 'package:splash_screen/splash_screen.dart';

class StickerBoardApplication extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print(DeviceInformation.platform);

    return MaterialApp(
      title: ApplicationConst.ApplicationName,
      initialRoute: '/account',
      routes: {
        '/' : (context, [params]) => SplashScreenPage(),
        '/version' : (context, [params]) => VersionHistoryPage(),
        '/account' : (context, [params]) => LoginPage(),
      },
    );
  }

}



