import 'package:flutter/material.dart';

class SimpleTextAddPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _SimpleTextAddPageState();
  }

}

class _SimpleTextAddPageState extends State<SimpleTextAddPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sticker Board Simple Text Add'),
      ),
      body: Center(
        child: Text('Sticker Board Simple Text Add'),
      ),
    );
  }

}