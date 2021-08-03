import 'dart:io';

import 'package:device_information/enum/device_platform.dart';
import 'package:flutter/foundation.dart';

class DeviceInformation{

  DeviceInformation._();

  static DevicePlatform get platform {
    if(kIsWeb){
      return DevicePlatform.Browser;
    }
    if(Platform.isAndroid){
      return DevicePlatform.Android;
    }
    if(Platform.isIOS){
      return DevicePlatform.iOS;
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

  static int get platformInt => convertDevicePlatformToInt(platform);

  static String get brand => 'brand'; // Todo

  static String get deviceName => 'device name'; // Todo

  static String get machineCode => '123456789012345678'; // Todo

}
