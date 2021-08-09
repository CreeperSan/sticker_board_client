import 'package:flutter/material.dart';

class TagAddPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _TagAddPageState();
  }

}

class _TagAddPageState extends State<TagAddPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tag Add Page'),
      ),
      body: Center(
        child: Text('Tag Add Page'),
      ),
    );
  }

}