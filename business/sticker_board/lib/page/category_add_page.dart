import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i18n/i18n.dart';
import 'package:provider/provider.dart';
import 'package:sticker_board/enum/network_loading_state.dart';
import 'package:sticker_board/model/page/category_add_page_result_model.dart';
import 'package:ui_lib/ui_lib.dart';
import 'package:sticker_board/module/catrgory_add_module.dart';
import 'package:toast/toast.dart';

class CategoryAddPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _CategoryAddPageState();
  }

}

class _CategoryAddPageState extends State<CategoryAddPage>{
  late CategoryAddModule _module;
  TextEditingController _nameTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _module = CategoryAddModule();

  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryAddModule>.value(
      value: _module,
      builder: (providerContext, child){
        return Scaffold(
          appBar: AppBar(
            title: Text(i18n.str('CreateCategory_Title')),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 26,
                horizontal: 16,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nameTextController,
                    decoration: InputDecoration(
                      labelText: i18n.str('CreateCategory_CategoryNameHint'),
                    ),
                  ),
                  Divider(
                    height: 36,
                  ),
                  Consumer<CategoryAddModule>(
                    builder: (consumerContext, module, child){
                      return module.addCategoryNetworkState == NetworkLoadingState.Loading ? CupertinoActivityIndicator() : StickerBoardActionButton(
                        name: i18n.str('CreateCategory_CreateCategory'),
                        onPressed: () => _onCreateCategoryPressed(module),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onCreateCategoryPressed(CategoryAddModule module){
    final name = _nameTextController.text;

    print('name -> '+name);

    if(name.isEmpty){
      ToastManager.show(i18n.str('CreateCategory_ToastEnterCategoryName'));
      return;
    }

    module.addCategory(
      name: _nameTextController.text,
      onSuccess: (){
        Navigator.pop(context, CategoryAddPageResultModel(
          isSuccess: true,
        ));
      },
      onFail: (errCode, errMessage){
        ToastManager.show(i18n.tr('CreateCategory_ToastCategoryCreateFailed', errMessage));
      },
    );
  }



}