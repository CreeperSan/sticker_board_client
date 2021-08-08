
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class ToastManager{

  ToastManager._();

  static StatefulWidget initializeApplication(StatelessWidget app){
    return OKToast(
      child: app,
    );
  }

  static void show(String text){
    showToast(text);
  }

}
