
import 'package:flutter/material.dart';

class CreateTodoListStickerPage extends StatefulWidget{

  // CreateTodoListStickerPage({
  //
  // });

  @override
  State<StatefulWidget> createState() {
    return _CreateTodoListStickerPageState();
  }

}

class _CreateTodoListStickerPageState extends State<CreateTodoListStickerPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todo List Sticker'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }

}

