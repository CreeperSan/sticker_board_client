
import 'package:network/enum/request_method.dart';
import 'package:network/manager/network_manager.dart';
import 'package:sticker_board/cache/base_cache.dart';
import 'package:sticker_board/cache/cache_state.dart';
import 'package:sticker_board/cache/component/time_expired_calculator.dart';
import 'package:sticker_board/cache/response/cache_fetch_response.dart';
import 'package:sticker_board/cache/response/cache_fetch_source.dart';
import 'package:sticker_board_api/sticker_board_api.dart';
import 'package:url_builder/url_builder.dart';

class StickerCategoryCache extends BaseCache<CategoryModel>{
  // Singleton
  static StickerCategoryCache instance = StickerCategoryCache._();

  StickerCategoryCache._();

  // Cache

  TimeExpiredCalculator _timeExpiredCalculator = TimeExpiredCalculator(1000 * 60 * 60 * 12); // 12 Hour
  CacheState _cacheState = CacheState.Idle;
  List<CategoryModel> _cache = [];

  @override
  Future<CacheFetchResponse<List<CategoryModel>>> fetch({
    bool forceRefresh = false,
  }) async {
    // TODO : Should consider prevent repeat fetch data

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
      _cacheState = CacheState.Fetching;
      try {
        final response = await NetworkManager.instance.rawFetch(URLBuilder.stickerListCategory(),
          requestMethod: RequestMethod.Post,
        );
        final responseCode = response.data['code'] ?? 0;
        final responseMessage = response.data['msg'] ?? 'Error while getting categories, please try again later.';
        if(responseCode == 200){
          List<CategoryModel> categoryModelList = [];
          final responseData = response.data['data'] as List<dynamic>;
          responseData.forEach((dataItem) {
            CategoryModel categoryModel = CategoryModel(
              parentID: dataItem['parent_id'] ?? '',
              id: dataItem['category_id'] ?? '',
              createTime: dataItem['create_time'] ?? 0,
              updateTime: dataItem['update_time'] ?? 0,
              name: dataItem['name'] ?? '',
              icon: dataItem['icon'] ?? '',
              color: dataItem['color'] ?? 0,
              extra: dataItem['extra'] ?? '',
              sort: dataItem['sort'] ?? 10000,
            );
            categoryModelList.add(categoryModel);
          });
          return CacheFetchResponse<List<CategoryModel>>(
            isFetchSuccess: true,
            message: responseMessage,
            source: CacheFetchSource.Network,
            data: categoryModelList,
          );
        } else {
          return CacheFetchResponse<List<CategoryModel>>(
            isFetchSuccess: false,
            message: responseMessage,
            source: CacheFetchSource.Network,
            data: [],
          );
        }
      } catch (e) {
        print(e);
        return CacheFetchResponse<List<CategoryModel>>(
          isFetchSuccess: false,
          message: 'Fetch category failed, please check your internet connection',
          source: CacheFetchSource.Network,
          data: [],
        );
      }
    }

    return CacheFetchResponse<List<CategoryModel>>(
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
