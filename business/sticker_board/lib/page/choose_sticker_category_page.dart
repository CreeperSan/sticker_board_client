
import 'package:flutter/material.dart';
import 'package:i18n/i18n.dart';
import 'package:sticker_board/cache/sticker_category_cache.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class ChooseStickerCategoryPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ChooseStickerCategoryPageState();
  }

}

class _ChooseStickerCategoryPageState extends State<ChooseStickerCategoryPage>{
  final List<CategoryModel>  _categoryList = [];
  String _hintMessage = i18n.str('ChooseCategory_Loading');

  @override
  void initState() {
    super.initState();
    _onRefreshClick(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: _onBackPressed,
        ),
        title: Text(i18n.str('ChooseCategory_Title')),
        actions: [
          IconButton(
            icon: Text(i18n.str('ChooseCategory_ActionClear'),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: _onClearCategoryPicker,
          ),
          IconButton(
            icon: Icon(Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () => _onRefreshClick(true),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefreshClick(true),
        child: _hintMessage.isEmpty ? _buildSuccessWidget() : _buildFailWidget(),
      ),
    );
  }

  Widget _buildSuccessWidget(){
    return ListView.builder(
      itemCount: _categoryList.length,
      itemBuilder: (itemContext, index){
        final item = _categoryList[index];
        return ListTile(
          leading: Icon(Icons.category),
          title: Text(item.name,
            maxLines: 1,
          ),
          onTap: () => _onCategoryPick(item),
        );
      },
    );
  }

  Widget _buildFailWidget(){
    return Center(
      child: Text(_hintMessage),
    );
  }

  Future _onRefreshClick(bool forceRefresh) async {
    _hintMessage = i18n.str('ChooseCategory_Loading');
    setState(() { });
    return StickerCategoryCache.instance.fetch(
      forceRefresh: forceRefresh,
    ).then((response){
      _categoryList.clear();
      _hintMessage = response.message;
      if(response.isFetchSuccess){
        if(response.data.isEmpty){
          _hintMessage = i18n.str('ChooseCategory_EmptyCategory');
        } else {
          _hintMessage = '';
          _categoryList.addAll(response.data);
        }
      } else {
        _hintMessage = response.message;
      }
      setState(() { });
    });
  }

  void _onBackPressed(){
    Navigator.pop(context, ChooseStickerCategoryPageResponse(
      isChoose: false,
    ));
  }

  void _onCategoryPick(CategoryModel categoryModel){
    Navigator.pop(context, ChooseStickerCategoryPageResponse(
        isChoose: true,
        categoryModel: categoryModel,
    ));
  }

  void _onClearCategoryPicker(){
    Navigator.pop(context, ChooseStickerCategoryPageResponse(
      isChoose: true,
      categoryModel: null,
    ));
  }

}

class ChooseStickerCategoryPageResponse{
  bool isChoose;
  CategoryModel? categoryModel;

  ChooseStickerCategoryPageResponse({
    required this.isChoose,
    this.categoryModel,
  });

}
