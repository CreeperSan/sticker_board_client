
import 'package:network/network.dart';
import 'package:sticker_board/cache/base_cache.dart';
import 'package:sticker_board/cache/cache_state.dart';
import 'package:sticker_board/cache/component/time_expired_calculator.dart';
import 'package:sticker_board/cache/response/cache_fetch_response.dart';
import 'package:sticker_board/cache/response/cache_fetch_source.dart';
import 'package:sticker_board_api/sticker_board_api.dart';
import 'package:url_builder/url_builder.dart';

class StickerTagCache extends BaseCache<CacheFetchResponse<List<TagModel>>> {
  // Singleton
  static StickerTagCache instance = StickerTagCache._();

  StickerTagCache._();

  // Cache
  TimeExpiredCalculator _timeExpiredCalculator = TimeExpiredCalculator(1000 * 60 * 60 * 12); // 12 Hour
  CacheState _cacheState = CacheState.Idle;
  List<TagModel> _cache = [];

  @override
  Future<CacheFetchResponse<List<TagModel>>> fetch({
    bool forceRefresh = false,
  }) async {
    // Find out whether should fetch data from server
    bool shouldFetchFromInternet = false;
    if(forceRefresh){
      shouldFetchFromInternet = true;
    } else if ( _cacheState == CacheState.Idle ) {
      shouldFetchFromInternet = true;
    } else if (_timeExpiredCalculator.isExpired()) {
      shouldFetchFromInternet = true;
    }

    if(shouldFetchFromInternet){
      try {
        final response = await NetworkManager.instance.rawFetch(URLBuilder.stickerListTag(),
                requestMethod: RequestMethod.Post,
              );
        List<TagModel> tagModelList = [];
        final responseCode = response.data['code'] ?? 0;
        final responseMessage = response.data['msg'] ?? 'Error while getting tags, please try again later.';
        if (200 == responseCode) {
                final responseData = response.data['data'] as List<dynamic>;
                responseData.forEach((dataItem) {
                  TagModel tagModel = TagModel(
                    id: dataItem['tag_id'] ?? '',
                    createTime: dataItem['create_time'] ?? 0,
                    updateTime: dataItem['update_time'] ?? 0,
                    name: dataItem['name'] ?? '',
                    icon: dataItem['icon'] ?? '',
                    color: dataItem['color'] ?? 0,
                    extra: dataItem['extra'] ?? '',
                    sort: dataItem['sort'] ?? 10000,
                  );
                  tagModelList.add(tagModel);
                });
                return CacheFetchResponse<List<TagModel>>(
                  isFetchSuccess: true,
                  message: responseMessage,
                  source: CacheFetchSource.Network,
                  data: tagModelList,
                );
              } else {
                return CacheFetchResponse<List<TagModel>>(
                  isFetchSuccess: false,
                  message: responseMessage,
                  source: CacheFetchSource.Network,
                  data: _cache,
                );
              }
      } catch (e) {
        print(e);
        return CacheFetchResponse<List<TagModel>>(
          isFetchSuccess: false,
          message: 'Fetch category failed, please check your internet connection',
          source: CacheFetchSource.Network,
          data: [],
        );
      }
    }

    return CacheFetchResponse<List<TagModel>>(
      isFetchSuccess: true,
      message: 'Fetch success',
      source: CacheFetchSource.Cache,
      data: _cache,
    );
  }

  @override
  Future<bool> clear() {
    _cache.clear();
    return Future.value(true);
  }

}
