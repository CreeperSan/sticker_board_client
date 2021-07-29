
import 'package:log/factory/logger.dart';
import 'package:log/interface/i_logger.dart';

class LogManager {

  LogManager._();

  static ILogger? _logger;

  static Future<bool> initialize() async {
    _logger = LoggerFactory.getLogger();
    return true;
  }

  static void d(String content, String tag){
    _logger?.d(content, tag);
  }

  static void i(String content, String tag){
    _logger?.i(content, tag);
  }

  static void w(String content, String tag){
    _logger?.w(content, tag);
  }

  static void e(String content, String tag){
    _logger?.e(content, tag);
  }

}
