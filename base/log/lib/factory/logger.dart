
import 'package:device_information/device_information.dart';
import 'package:log/controller/android_logger.dart';
import 'package:log/controller/ios_logger.dart';
import 'package:log/controller/linux_logger.dart';
import 'package:log/controller/macos_logger.dart';
import 'package:log/controller/web_logger.dart';
import 'package:log/controller/windows_logger.dart';
import 'package:log/interface/i_logger.dart';

class LoggerFactory{

  LoggerFactory._();

  static ILogger? getLogger(){
    switch(DeviceInformation.platform){
      case DevicePlatform.Windows:
        return WindowsLogger();
      case DevicePlatform.MacOS:
        return MacOSLogger();
      case DevicePlatform.Linux:
        return LinuxLogger();
      case DevicePlatform.IOS:
        return IOSLogger();
      case DevicePlatform.Android:
        return AndroidLogger();
      case DevicePlatform.Browser:
        return WebLogger();
      default:
        return null;
    }

  }

}
