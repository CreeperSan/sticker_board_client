
import 'package:log/factory/logger.dart';
import 'package:log/interface/i_logger.dart';

class LogManager {

  LogManager._();

  static ILogger? _logger;

  static Future<bool> initialize() async {
    if(_logger == null){
      _logger = LoggerFactory.getLogger();
    }
    return true;
  }

  static void d(dynamic content, dynamic tag){
    _logger?.d(content.toString(), tag.toString());
  }

  static void i(dynamic content, dynamic tag){
    _logger?.i(content.toString(), tag.toString());
  }

  static void w(dynamic content, dynamic tag){
    _logger?.w(content.toString(), tag.toString());
  }

  static void e(dynamic content, dynamic tag){
    _logger?.e(content.toString(), tag.toString());
  }

}
