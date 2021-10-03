
import 'package:flutter/material.dart';

class SettingTileWidget extends StatefulWidget {
  final Duration animationduration;
  final void Function()? onClick;
  final Widget? leading;
  final Widget? content;
  final Widget? trailing;

  SettingTileWidget({
    this.animationduration = const Duration(milliseconds: 150),
    this.onClick,
    this.leading,
    this.content,
    this.trailing,
  });

  @override
  State<StatefulWidget> createState() {
    return _SettingTileWidget();
  }

}

class _SettingTileWidget extends State<SettingTileWidget> {
  bool _isPressing = false;

  @override
  Widget build(BuildContext context) {
    final tmpLeading = widget.leading;
    final tmpContent = widget.content;
    final tmpTrailing = widget.trailing;

    Widget result = AnimatedContainer(
      duration: widget.animationduration,
      color: _isPressing ? Color(0xFFEEEEEE) : Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(tmpLeading != null) tmpLeading,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: tmpLeading != null ? 16 : 0,
                right: tmpTrailing != null ? 16 : 0,
              ),
              child: tmpContent,
            ),
          ),
          if(tmpTrailing != null) tmpTrailing,
        ],
      ),
    );

    if(widget.onClick != null){
      result = GestureDetector(
        onTap: widget.onClick,
        onTapDown: (_) => _onTagDown(),
        onTapUp: (_) => _onTagUp(),
        onTapCancel: () => _onTagUp(),
        child: result,
      );
    }


    return result;
  }


  void _onTagDown(){
    setState(() {
      _isPressing = true;
    });
  }

  void _onTagUp(){
    setState(() {
      _isPressing = false;
    });
  }

}
