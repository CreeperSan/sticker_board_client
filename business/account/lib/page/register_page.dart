import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }

}

class _RegisterPageState extends State<RegisterPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Account'),
      ),
      body: Center(
        child: Text('Developing...'),
      ),
    );
  }

}
