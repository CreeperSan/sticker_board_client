
import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }

}

class _IndexPageState extends State<IndexPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sticker Board'),
      ),
      body: Center(
        child: Text('Sticker Board'),
      ),
    );
  }

}
