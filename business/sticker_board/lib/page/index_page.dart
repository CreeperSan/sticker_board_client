
import 'package:flutter/material.dart';
import 'package:sticker_board/operator/tag_operator.dart';

class IndexPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }

}

class _IndexPageState extends State<IndexPage>{

  @override
  void initState() {
    super.initState();
    TagOperator.instance.getTagList();
  }

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
