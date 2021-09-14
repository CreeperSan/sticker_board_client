
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sticker_board/page/create_plain_image_sticker_page.dart';
import 'package:sticker_board/page/create_plain_sound_sticker_page.dart';
import 'package:sticker_board/page/create_plain_text_sticker_page.dart';
import 'package:sticker_board/page/create_todo_list_sticker_page.dart';

class StickerTypeSelectToCreatePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x33FFFFFF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.6],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Card(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: min(MediaQuery.of(context).size.width, 320),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.message_outlined),
                          title: Text('Plain Text'),
                          onTap: () => _onCreatePlainTextClicked(context),
                        ),
                        ListTile(
                          leading: Icon(Icons.image_outlined),
                          title: Text('Plain Image'),
                          onTap: () => _onCreatePlainImageClicked(context),
                        ),
                        ListTile(
                          leading: Icon(Icons.keyboard_voice_outlined),
                          title: Text('Plain Sound'),
                          onTap: () => _onCreatePlainSoundClicked(context),
                        ),
                        ListTile(
                          leading: Icon(Icons.list),
                          title: Text('Todo List'),
                          onTap: () => _onCreateTodoListClicked(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 120,
              child: Center(
                child: FloatingActionButton(
                  child: Icon(Icons.close),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCreatePlainTextClicked(BuildContext context){
    // TODO replace this with named router
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (routeContext) {
        return CreatePlainTextStickerPage();
      }
    ));
  }

  void _onCreatePlainImageClicked(BuildContext context){
    // TODO replace this with named router
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (routeContext) {
          return CreatePlainImageStickerPage();
        }
    ));
  }

  void _onCreatePlainSoundClicked(BuildContext context){
    // TODO replace this with named router
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (routeContext) {
          return CreatePlainSoundStickerPage();
        }
    ));
  }

  void _onCreateTodoListClicked(BuildContext context){
    // TODO replace this with named router
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (routeContext) {
          return CreateTodoListStickerPage();
        }
    ));
  }

}
