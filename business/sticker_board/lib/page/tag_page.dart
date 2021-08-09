import 'package:flutter/material.dart';

class TagPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _TagPageState();
  }

}

class _TagPageState extends State<TagPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tag Page'),
      ),
      body: Center(
        child: Text('Tag Page'),
      ),
    );
  }

}