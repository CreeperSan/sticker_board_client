
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndexCreateStickerHeaderWidget extends StatelessWidget {
  final void Function(void Function() clearAction, String content)? onSubmitText;
  final void Function()? onCreatePlainImageStickerPressed;
  final void Function()? onCreatePlainSoundStickerPressed;

  final TextEditingController _controller = TextEditingController();

  IndexCreateStickerHeaderWidget({
    this.onSubmitText,
    this.onCreatePlainImageStickerPressed,
    this.onCreatePlainSoundStickerPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      elevation: 6,
      shadowColor: Color(0x33000000),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 16,
              ),
              child: Icon(Icons.edit,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write down a note...',
                ),
                textInputAction: TextInputAction.done,
                controller: _controller,
                onSubmitted: _onSubmittedText,
              ),
            ),
            IconButton(
              color: Colors.grey,
              icon: Icon(Icons.image),
              onPressed: onCreatePlainImageStickerPressed,
            ),
            IconButton(
              color: Colors.grey,
              icon: Icon(Icons.keyboard_voice),
              onPressed: onCreatePlainSoundStickerPressed,
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmittedText(String content){
    onSubmitText?.call((){
      _controller.clear();
    }, content);
  }

}
