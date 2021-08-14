
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticker_board/enum/network_loading_state.dart';

class DrawerGroupWidget extends StatelessWidget{
  final String name;
  final NetworkLoadingState state;
  final void Function()? onRefreshPress;
  final void Function()? onAddPress;

  DrawerGroupWidget({
    required this.name,
    required this.state,
    this.onRefreshPress,
    this.onAddPress,
  });

  @override
  Widget build(BuildContext context) {
    Widget? refreshWidget = _buildRefreshIconWidget();
    
    return Container(
      height: 38,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(name,
              style: TextStyle(
                color: Colors.blueAccent,
              ),
            ),
          ),

          if(onAddPress != null) IconButton(
            icon: Icon(Icons.add),
            color: Colors.grey,
            onPressed: () => onAddPress?.call(),
          ),

          if(refreshWidget != null) refreshWidget
        ],
      ),
    );
  }
  
  Widget? _buildRefreshIconWidget(){
    if(state == NetworkLoadingState.Loading){
      return Container(
        width: 24,
        height: 24,
        child: CupertinoActivityIndicator(),
      );
    }

    if(onRefreshPress != null){
      return IconButton(
        icon: Icon(Icons.refresh,
          color: Colors.grey,
        ),
        onPressed: () => onRefreshPress?.call(),
      );
    }
  }


}
