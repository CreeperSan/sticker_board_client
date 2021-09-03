
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:log/log.dart';
import 'package:network/network.dart';
import 'package:toast/manager/toast_manager.dart';

class CreatePlainTextStickerPage extends StatelessWidget{
  final TextEditingController _titleEditController = TextEditingController();
  final TextEditingController _messageEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Plain Text Sticker'),
        actions: [
          CupertinoButton(
            child: Text('Create',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => _onCreateStickerClicked(context),
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            maxLines: 1,
            controller: _titleEditController,
            decoration: InputDecoration(
              hintText: 'Title',
            ),
          ),
          Expanded(
            child: TextField(
              maxLines: 999,
              controller: _messageEditController,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Message',
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Card(
      //   child: Text('Tool Bar'),
      // ),
    );
  }

  void _onCreateStickerClicked(BuildContext context){
    final titleText = _titleEditController.text;
    final messageText = _messageEditController.text;

    if(titleText.isEmpty && messageText.isEmpty){
      ToastManager.show('Please enter title or message');
      return;
    }

    NetworkManager.instance.fetch('http://localhost:8080/api/sticker/v1/plain_text/create',
      requestMethod: RequestMethod.Post,
      data: {
        'star' : 0,
        'status' : 0,
        'title' : titleText,
        'background' : '',
        'text' : messageText,
        'category_id' : '',
        'tag_id' : [],
        'is_pinned' : false,
      },
      onSuccess: (response) {
        LogManager.i('Create Plain Text Sticker Response : ', this.runtimeType.toString());
        LogManager.i(response, this.runtimeType.toString());
        final code = response['code'] ?? 0;
        final message = response['msg'] ?? 'Create sticker failed, please try again later';
        ToastManager.show(message);
        if(code == 200) {
          Navigator.pop(context);
        }
      },
      onFail: (error) {
        LogManager.i('Create Plain Text Sticker Fail : ', this.runtimeType.toString());
        LogManager.i(error.toString(), this.runtimeType.toString());
        ToastManager.show('Create sticker failed, network error');
      }
    );
  }

}
