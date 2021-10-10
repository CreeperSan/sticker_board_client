
import 'package:flutter/material.dart';

class StickerBoardNavigator{
  Widget Function(BuildContext) pageBuilder;
  BuildContext context;

  StickerBoardNavigator({
    required this.pageBuilder,
    required this.context,
  });

  push(){
    return Navigator.push(context, MaterialPageRoute(
      builder: (routeContext){
        return pageBuilder.call(routeContext);
      },
    ));
  }

  replace(){
    return Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (routeContext){
        return pageBuilder.call(routeContext);
      },
    ));
  }

}
