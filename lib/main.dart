import 'package:flutter/material.dart';
import 'package:sticker_board_client/application/sticker_board_application.dart';
import 'package:toast/toast.dart';

void main() {
  // Enter Application
  runApp(ToastManager.initializeApplication(StickerBoardApplication()));
}

