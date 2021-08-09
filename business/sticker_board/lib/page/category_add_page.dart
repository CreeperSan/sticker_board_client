import 'package:flutter/material.dart';

class CategoryAddPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _CategoryAddPageState();
  }

}

class _CategoryAddPageState extends State<CategoryAddPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Add Page'),
      ),
      body: Center(
        child: Text('Category Add Page'),
      ),
    );
  }

}