
import 'package:sticker_board/cache/response/cache_fetch_source.dart';

class CacheFetchResponse<T> {
  bool isFetchSuccess;
  CacheFetchSource source;
  T data;
  String message;

  CacheFetchResponse({
    required this.isFetchSuccess,
    required this.message,
    required this.source,
    required this.data,
  });

}
