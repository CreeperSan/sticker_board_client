
import 'package:sticker_board/cache/response/cache_fetch_response.dart';

abstract class BaseCache<T> {

  // Fetch data
  Future<CacheFetchResponse<dynamic>> fetch({
    bool forceRefresh = false,
  });

  // Clear cache
  Future<bool> clear();

}

