
import 'package:flutter/material.dart';

class StickerBoardActionButton extends StatefulWidget{
  String name;
  Color backgroundColor;
  Color backgroundColorPressed;
  Color textColor;
  int animateMillisecond;
  double borderRadius;
  void Function() onPressed;
  EdgeInsets padding;

  StickerBoardActionButton({
    required this.name,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.backgroundColorPressed = Colors.blueAccent,
    this.animateMillisecond = 300,
    this.textColor = Colors.white,
    this.borderRadius = 4,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 22,
      vertical: 8,
    )
  });

  @override
  State<StatefulWidget> createState() {
    return _StickerBoardActionButtonState();
  }

}

class _StickerBoardActionButtonState extends State<StickerBoardActionButton>{
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) => _onPanDown(),
      onPanStart: (_) => _onPanDown(),
      onPanEnd: (_) => _onPanUp(),
      onPanCancel: () => _onPanUp(),
      onTap: _onPressed,
      child: AnimatedContainer(
        padding: widget.padding,
        duration: Duration(
          milliseconds: widget.animateMillisecond,
        ),
        decoration: BoxDecoration(
          color: _isPressed ? widget.backgroundColorPressed : widget.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        ),
        child: Text(widget.name,
          style: TextStyle(
            color: widget.textColor,
          ),
        ),
      ),
    );
  }

  void _onPanDown(){
    if(!_isPressed){
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _onPanUp(){
    if(_isPressed){
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _onPressed(){
    widget.onPressed.call();
  }

}

