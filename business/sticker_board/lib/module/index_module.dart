
import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:sticker_board/operator/category_operator.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

import 'package:sticker_board/operator/tag_operator.dart';
import 'package:sticker_board/enum/network_loading_state.dart';

class IndexModule with ChangeNotifier{

  NetworkLoadingState tagLoadingState = NetworkLoadingState.Idle;
  List<TagModel> tagList = [];

  NetworkLoadingState categoryLoadingState = NetworkLoadingState.Idle;
  List<CategoryModel> categoryList = [];

  void loadTag(){
    tagLoadingState = NetworkLoadingState.Loading;
    notifyListeners();

    TagOperator.instance.getTagList(
      onSuccess: (networkTagList){
        tagList.clear();
        tagList.addAll(networkTagList);
        tagLoadingState = NetworkLoadingState.Success;
        notifyListeners();
      },
      onFail: (errCode, errMessage){
        tagLoadingState = NetworkLoadingState.Fail;
        notifyListeners();
      }
    );
  }

  void loadCategory(){
    categoryLoadingState = NetworkLoadingState.Loading;
    notifyListeners();

    CategoryOperator.instance.getCategoryList(
      onSuccess: (networkCategoryList){
        categoryList.clear();
        categoryList.addAll(networkCategoryList);
        categoryLoadingState = NetworkLoadingState.Success;
        notifyListeners();
      },
      onFail: (errCode, errMessage){
        categoryLoadingState = NetworkLoadingState.Fail;
        notifyListeners();
      }
    );
  }


}
