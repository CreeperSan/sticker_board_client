
import 'package:flutter/material.dart';
import 'package:i18n/i18n.dart';

class SplashScreenPage extends StatefulWidget{
  Future<dynamic> Function()? onInitialize;
  void Function(dynamic initResponse) onInitializeFinish;    // If return ture , splash page will pop automatic

  SplashScreenPage({
    required this.onInitializeFinish,
    this.onInitialize,
  });

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenPageState();
  }

}

class _SplashScreenPageState extends State<SplashScreenPage>{



  @override
  void initState() {
    super.initState();
    Future.delayed(Duration( milliseconds: 300 ), () async {
      // init
      final onInitialize = widget.onInitialize;
      dynamic initResult;
      try {
        if(onInitialize != null){
          initResult = await onInitialize.call();
        }
      } catch (e) {
        initResult = e;
        print(e);
      }
      // init finish
      widget.onInitializeFinish.call(initResult);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.leaderboard_sharp,
              size: 48,
              color: Colors.white,
            ),
            Text('Application_AppName'.i18n(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
      ),
    );
  }

}
