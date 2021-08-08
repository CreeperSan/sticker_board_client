import 'package:account/account.dart';
import 'package:flutter/material.dart';
import 'package:account_api/account_api.dart';
import 'package:version/operator/version_operator.dart';
import 'package:version_api/version_api.dart';
import 'package:sticker_board_client/application/sticker_board_application.dart';
import 'package:toast/toast.dart';

void main() {
  // Initialize Modules
  AccountManager.install(AccountOperator.instance);
  VersionManager.install(VersionOperator.instance);

  // Enter Application
  runApp(ToastManager.initializeApplication(StickerBoardApplication()));
}

