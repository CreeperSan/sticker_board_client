
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticker_board/module/index_module.dart';
import 'package:sticker_board/operator/tag_operator.dart';
import 'package:sticker_board/widget/category_widget.dart';
import 'package:sticker_board/widget/drawer_group_widget.dart';
import 'package:sticker_board/widget/drawer_hint_widget.dart';
import 'package:sticker_board/widget/tag_widget.dart';
import 'package:sticker_board_api/model/tag_model.dart';

class IndexPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }

}

class _IndexPageState extends State<IndexPage> with WidgetsBindingObserver {
  late IndexModule _indexModule;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance?.addPostFrameCallback(onInitStateFirstFrameCallback);

    _indexModule = IndexModule();
  }

  void onInitStateFirstFrameCallback(Duration timestamp){

  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  Widget _buildCategory(){
    return Consumer<IndexModule>(
      builder: (consumerContext, module, child){
        List<Widget> categoryWidgetList = [];
        categoryWidgetList.add(DrawerGroupWidget(
          name: 'Category',
          state: module.categoryLoadingState,
          onRefreshPress: () => module.loadCategory(),
          onAddPress: _onAddCategoryPressed,
        ));
        final categoryList = module.categoryList;
        if(categoryList.isEmpty){
          categoryWidgetList.add(DrawerHintWidget(
            message: 'No category',
          ));
        } else {
          module.categoryList.forEach((element) {
            categoryWidgetList.add(CategoryWidget(element));
          });
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: categoryWidgetList,
        );
      },
    );
  }

  Widget _buildTag(){
    return Consumer<IndexModule>(
      builder: (consumerContext, module, child){
        List<Widget> tagWidgetList = [];
        tagWidgetList.add(DrawerGroupWidget(
          name: 'Tag',
          state: module.tagLoadingState,
          onRefreshPress: () => module.loadTag(),
          onAddPress: _onAddTagPressed,
        ));
        final tagList = module.tagList;
        if(tagList.isEmpty){
          tagWidgetList.add(DrawerHintWidget(
            message: 'No tag',
          ));
        } else {
          module.tagList.forEach((element) {
            tagWidgetList.add(TagWidget(element));
          });
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: tagWidgetList,
        );
      },
    );
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
                  _buildCategory(),
                  _buildTag(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void _onAddTagPressed(){
    Navigator.pushNamed(context, '/sticker_board/tag/add');
  }

  void _onAddCategoryPressed(){
    Navigator.pushNamed(context, '/sticker_board/category/add');
  }


  IndexModule get watchIndexModule => context.watch<IndexModule>();
  IndexModule get readIndexModule => context.read<IndexModule>();

}
