
import 'package:log/log.dart';
import 'package:flutter/material.dart';
import 'package:sticker_board/cache/sticker_category_cache.dart';
import 'package:sticker_board/cache/sticker_tag_cache.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

import 'package:sticker_board/enum/network_loading_state.dart';

class IndexModule with ChangeNotifier{

  NetworkLoadingState tagLoadingState = NetworkLoadingState.Idle;
  List<TagModel> tagList = [];

  NetworkLoadingState categoryLoadingState = NetworkLoadingState.Idle;
  List<CategoryModel> categoryList = [];

  NetworkLoadingState stickerLoadingState = NetworkLoadingState.Idle;
  List<StickerModel> stickerList = [];

  StickerFilterModel _stickerFilterModel = StickerFilterModel();

  Future loadTag(){
    tagLoadingState = NetworkLoadingState.Loading;
    notifyListeners();

    return StickerTagCache.instance.fetch(forceRefresh: true).then((response){
      if(response.isFetchSuccess){
        tagList.clear();
        tagList.addAll(response.data);
      }
      return response;
    }).then((response){
      tagLoadingState = response.isFetchSuccess ? NetworkLoadingState.Success : NetworkLoadingState.Fail;
      notifyListeners();
    }).catchError((onError){
      tagLoadingState = NetworkLoadingState.Fail;
      notifyListeners();
    });
  }

  Future loadCategory(){
    categoryLoadingState = NetworkLoadingState.Loading;
    notifyListeners();

    return StickerCategoryCache.instance.fetch(forceRefresh: true).then((response){
      if(response.isFetchSuccess){
        categoryList.clear();
        categoryList.addAll(response.data);
      }
      return response;
    }).then((response){
      categoryLoadingState = response.isFetchSuccess ? NetworkLoadingState.Success : NetworkLoadingState.Fail;
      notifyListeners();
    }).catchError((onError){
      categoryLoadingState = NetworkLoadingState.Fail;
      notifyListeners();
    });
  }

  void loadStickerModel(){
    stickerLoadingState = NetworkLoadingState.Loading;
    notifyListeners();

    StickerBoardManager.instance.queryStickerList(0, 100, _stickerFilterModel,
      onSuccess: (responseList){
        LogManager.d('Query sticker list success. size=${responseList.length}', this.runtimeType);
        // stickerList.clear();
        // stickerList.addAll(responseList);
        stickerList = responseList;
        stickerLoadingState = NetworkLoadingState.Idle;
        notifyListeners();
      },
      onFail: (code, message){
        LogManager.w('Query sticker list fail. code=$code message=$message', this.runtimeType);
        stickerLoadingState = NetworkLoadingState.Idle;
        notifyListeners();
      }
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  void filterTag(String tagID){
    _stickerFilterModel.reset();
    if(_stickerFilterModel.filterTag(tagID)){
      stickerList.clear();
      notifyListeners();
      loadStickerModel();
    }
  }

  void filterCategory(String categoryID){
    _stickerFilterModel.reset();
    if(_stickerFilterModel.filterCategory(categoryID)){
      stickerList.clear();
      notifyListeners();
      loadStickerModel();
    }
  }

  void resetFilter(){
    stickerList.clear();
    _stickerFilterModel.reset();
    notifyListeners();
    loadStickerModel();
  }

  String getFilterText(){
    return _stickerFilterModel.getHintText();
  }

}

extension StickerFilterModelExtensions on StickerFilterModel {

  String getHintText(){
    String hintMessage = '';

    if(category.isNotEmpty){
      hintMessage += 'Category is ';
      for(int i=0; i<category.length; i++){
        final categoryID = category[i];
        final categoryModel = StickerCategoryCache.instance.getCategoryModel(categoryID);
        final hasNext = i < (category.length - 1);
        hintMessage += '${categoryModel?.name ?? '<id:$categoryID>'} ';
        if(hasNext){
          hintMessage += ', ';
        }
      }
    }

    if(tag.isNotEmpty){
      hintMessage += 'and Tag is ';
      for(int i=0; i<tag.length; i++){
        final tagID = tag[i];
        final tagModel = StickerTagCache.instance.getTagModel(tagID);
        final hasNext = i < (tag.length - 1);
        hintMessage += '${tagModel?.name ?? '<id:$tagID>'} ';
        if(hasNext){
          hintMessage += ', ';
        }
      }
    }

    if(hintMessage.isEmpty){
      return hintMessage;
    }
    return 'You are watching $hintMessage stickers.';
  }

}
