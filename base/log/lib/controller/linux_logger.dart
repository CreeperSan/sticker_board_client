import 'package:log/interface/i_logger.dart';
import 'package:log/const/const.dart';

class LinuxLogger extends ILogger {

  @override
  void d(String content, String tag) {
    _print(content, tag, 'Debug  ');
  }

  @override
  void e(String content, String tag) {
    _print(content, tag, 'Error  ');
  }

  @override
  void i(String content, String tag) {
    _print(content, tag, 'Info   ');
  }

  @override
  void w(String content, String tag) {
    _print(content, tag, 'Warming');
  }

  void _print(String content, String tag, String level){
    if(!isRelease){
      print('【${DateTime.now()}】[$level] $tag : $content');
    }
  }

}
