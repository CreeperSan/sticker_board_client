
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndexCreateStickerHeaderWidget extends StatelessWidget {
  final void Function()? onMainAreaClicked;
  final void Function()? onImageIconClicked;
  final void Function()? onVoiceIconClicked;

  final TextEditingController _controller = TextEditingController();

  IndexCreateStickerHeaderWidget({
    this.onMainAreaClicked,
    this.onImageIconClicked,
    this.onVoiceIconClicked,
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
              child: GestureDetector(
                onTap: onMainAreaClicked,
                child: Text('Write down a note...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            IconButton(
              color: Colors.grey,
              icon: Icon(Icons.image),
              onPressed: onImageIconClicked,
            ),
            IconButton(
              color: Colors.grey,
              icon: Icon(Icons.keyboard_voice),
              onPressed: onVoiceIconClicked,
            ),
          ],
        ),
      ),
    );
  }

}
