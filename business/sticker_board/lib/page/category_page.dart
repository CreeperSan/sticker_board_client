import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _CategoryPageState();
  }

}

class _CategoryPageState extends State<CategoryPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Page'),
      ),
      body: Center(
        child: Text('Category Page'),
      ),
    );
  }

}