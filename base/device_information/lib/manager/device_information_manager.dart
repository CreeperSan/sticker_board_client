import 'dart:io';

import 'package:device_information/enum/device_platform.dart';
import 'package:flutter/foundation.dart';

class DeviceInformation{

  DeviceInformation._();

  static int get platform {
    if(kIsWeb){
      return DevicePlatform.Browser;
    }
    if(Platform.isAndroid){
      return DevicePlatform.Android;
    }
    if(Platform.isIOS){
      return DevicePlatform.IOS;
    }
    if(Platform.isLinux){
      return DevicePlatform.Linux;
    }
    if(Platform.isMacOS){
      return DevicePlatform.MacOS;
    }
    if(Platform.isWindows){
      return DevicePlatform.Windows;
    }
    return DevicePlatform.Unsupported;
  }

  static String get brand => 'brand'; // Todo

  static String get deviceName => 'device name'; // Todo

  static String get machineCode => '123456789012345678'; // Todo

}
