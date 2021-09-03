
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:network/enum/request_method.dart';
import 'package:network/manager/network_manager.dart';
import 'package:provider/provider.dart';
import 'package:sticker_board/enum/network_loading_state.dart';
import 'package:sticker_board/model/page/category_add_page_result_model.dart';
import 'package:sticker_board/model/page/tag_add_page_result_model.dart';
import 'package:sticker_board/module/index_module.dart';
import 'package:sticker_board/operator/tag_operator.dart';
import 'package:sticker_board/page/sticker_type_select_to_create_page.dart';
import 'package:sticker_board/widget/category_widget.dart';
import 'package:sticker_board/widget/drawer_group_widget.dart';
import 'package:sticker_board/widget/drawer_hint_widget.dart';
import 'package:sticker_board/widget/index_create_sticker_header_widget.dart';
import 'package:sticker_board/widget/tag_widget.dart';
import 'package:sticker_board_api/model/tag_model.dart';
import 'package:sticker_board_api/sticker_board_api.dart';
import 'package:log/log.dart';
import 'package:sticker_board/widget/drawer_item_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class IndexPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }

}

class _IndexPageState extends State<IndexPage> with WidgetsBindingObserver {
  static const TAG = '_IndexPageState';

  late IndexModule _indexModule;

  @override
  void initState() {
    super.initState();

    _indexModule = IndexModule();

    WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance?.addPostFrameCallback(onInitStateFirstFrameCallback);
  }

  void onInitStateFirstFrameCallback(Duration timestamp){
    _indexModule.loadTag();
    _indexModule.loadCategory();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<IndexModule>.value(
      value: _indexModule,
      builder: (providerContext, child){
        return Scaffold(
          appBar: AppBar(
            title: Text('Sticker Board'),
          ),
          drawer: Drawer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                    ),
                    child: Center(
                      child: Text('Sticker Board',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                  _buildDrawerCommonGroup(),
                  _buildDrawerCategoryGroup(),
                  _buildDrawerTagGroup(),
                ],
              ),
            ),
          ),
          body: _onBuildBody(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add,),
            onPressed: _onCreateStickerClicked,
          ),
        );
      },
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  /// The code below is about Drawer

  Widget _buildDrawerCommonGroup(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DrawerGroupWidget(
          name: 'Sticker Board',
          state: NetworkLoadingState.Idle,
        ),
        DrawerItemWidget(
          icon: Icon(Icons.inbox),
          name: 'All',
          onPressed: _onStickerBoardAllPressed,
        ),
        DrawerItemWidget(
          icon: Icon(Icons.archive),
          name: 'Archive',
          onPressed: _onStickerBoardArchivePressed,
        ),
      ],
    );
  }

  Widget _buildDrawerCategoryGroup(){
    return Consumer<IndexModule>(
      builder: (consumerContext, module, child){
        List<Widget> categoryWidgetList = [];
        categoryWidgetList.add(DrawerGroupWidget(
          name: 'Category',
          state: module.categoryLoadingState,
          onRefreshPress: () => module.loadCategory(),
          onAddPress: () => _onAddCategoryPressed(module),
        ));
        final categoryList = module.categoryList;
        if(categoryList.isEmpty){
          categoryWidgetList.add(DrawerHintWidget(
            message: 'No category',
          ));
        } else {
          module.categoryList.forEach((element) {
            categoryWidgetList.add(CategoryWidget(element,
              onPressed: _onCategoryPressed,
              onLongPressed: _onCategoryLongPressed,
            ));
          });
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: categoryWidgetList,
        );
      },
    );
  }

  Widget _buildDrawerTagGroup(){
    return Consumer<IndexModule>(
      builder: (consumerContext, module, child){
        List<Widget> tagWidgetList = [];
        tagWidgetList.add(DrawerGroupWidget(
          name: 'Tag',
          state: module.tagLoadingState,
          onRefreshPress: () => module.loadTag(),
          onAddPress: () => _onAddTagPressed(module),
        ));
        final tagList = module.tagList;
        if(tagList.isEmpty){
          tagWidgetList.add(DrawerHintWidget(
            message: 'No tag',
          ));
        } else {
          module.tagList.forEach((element) {
            tagWidgetList.add(TagWidget(element,
              onPressed: _onTagPressed,
              onLongPressed: _onTagLongPressed,
            ));
          });
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: tagWidgetList,
        );
      },
    );
  }

  void _onAddTagPressed(IndexModule module){
    Navigator.pushNamed(context, '/sticker_board/tag/add').then((response){
      if(response is TagAddPageResultModel){
        if(response.isSuccess){
          module.loadTag();
        }
      }
    });
  }

  void _onAddCategoryPressed(IndexModule module){
    Navigator.pushNamed(context, '/sticker_board/category/add').then((response){
      if(response is CategoryAddPageResultModel){
        if(response.isSuccess){
          module.loadCategory();
        }
      }
    });
  }

  void _onCategoryPressed(CategoryModel categoryModel){
    LogManager.d('Category has been pressed. category=$categoryModel', TAG);
  }

  void _onCategoryLongPressed(CategoryModel categoryModel){
    LogManager.d('Category has been long pressed. category=$categoryModel', TAG);

  }

  void _onTagPressed(TagModel tagModel){
    LogManager.d('Tag has been pressed. category=$tagModel', TAG);

  }

  void _onTagLongPressed(TagModel tagModel){
    LogManager.d('Tag has been pressed. category=$tagModel', TAG);

  }

  void _onStickerBoardAllPressed(){
    LogManager.d('All sticker board has been pressed.', TAG);

  }

  void _onStickerBoardArchivePressed(){
    LogManager.d('Archive sticker board has been pressed.', TAG);

  }

  //////////////////////////////////////////////////////////////////////////////
  /// The code below is about Content

  Widget _onBuildBody(){
    // This will cause stack overflow exception from StaggeredGridView when expanding the width of whe window
    // var axisCount = max(1, MediaQuery.of(context).size.width ~/ 160);
    var axisCount = 3;
    return RefreshIndicator(
      child: StaggeredGridView.countBuilder(
        crossAxisCount: axisCount,
        itemCount: 160,
        itemBuilder: (itemContext, index) {
          if(index == 0) {
            return IndexCreateStickerHeaderWidget(
              onMainAreaClicked: _onSubmitPlainTextSticker,
              onImageIconClicked: _onCreatePlainImageStickerPressed,
              onVoiceIconClicked: _onCreatePlainSoundStickerPressed,
            );
          } else {
            return Container(
              height: 30 + (index * 10) % 150 ,
              color: Colors.cyan,
              margin: EdgeInsets.all(16),
              child: Center(
                child: Text('#$index'),
              ),
            );
          }
        },
        staggeredTileBuilder: (int index) {
          if(index == 0){
            return StaggeredTile.extent(axisCount, 72);
          } else if (index == 1) {
            return StaggeredTile.extent(2, 260);
          } else if (index == 19) {
            return StaggeredTile.extent(2, 260);
          }
          return StaggeredTile.fit(1);
        },
      ),
      onRefresh: (){
        // Test Code
        NetworkManager.instance.fetch('http://localhost:8080/api/sticker/v1/query',
          requestMethod: RequestMethod.Post,
          data: {
            'page' : 0,
            'page_size' : 100,
          },
          onSuccess: (response){
            LogManager.d('Get sticker list onSuccess:', this.runtimeType.toString());
            LogManager.d(response, this.runtimeType.toString());
          },
          onFail: (onFail){
            LogManager.d('Get sticker list onFail:', this.runtimeType.toString());
            LogManager.d(onFail, this.runtimeType.toString());
          }
        );
        return Future.delayed(Duration(seconds: 1,));
      },
    );
  }

  void _onSubmitPlainTextSticker(){

  }

  void _onCreatePlainImageStickerPressed(){

  }

  void _onCreatePlainSoundStickerPressed(){

  }

  //////////////////////////////////////////////////////////////////////////////
  /// The code below is about create sticker

  void _onCreateStickerClicked(){
    // TODO replace with named router
    Navigator.push(context, PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) {
        return StickerTypeSelectToCreatePage();
      }
    ));
  }

}
