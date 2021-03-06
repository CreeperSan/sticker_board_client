import 'package:flutter/material.dart';
import 'package:i18n/i18n.dart';
import 'package:sticker_board/model/page/tag_add_page_result_model.dart';
import 'package:sticker_board/module/tag_add_module.dart';
import 'package:provider/provider.dart';
import 'package:sticker_board/enum/network_loading_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui_lib/ui_lib.dart';
import 'package:toast/toast.dart';

class TagAddPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _TagAddPageState();
  }

}

class _TagAddPageState extends State<TagAddPage>{
  late TagAddModule _module;
  TextEditingController _nameTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _module = TagAddModule();

  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TagAddModule>.value(
      value: _module,
      builder: (providerContext, child){
        return Scaffold(
          appBar: AppBar(
            title: Text(i18n.str('CreateTag_Title')),
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
                      labelText: i18n.str('CreateTag_HintTagName'),
                    ),
                  ),
                  Divider(
                    height: 36,
                  ),
                  Consumer<TagAddModule>(
                    builder: (consumerContext, module, child){
                      return module.tagAddNetworkState == NetworkLoadingState.Loading ? CupertinoActivityIndicator() : StickerBoardActionButton(
                        name: i18n.str('CreateTag_ButtonCreateTag'),
                        onPressed: () => _onCreateTagPressed(module),
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

  void _onCreateTagPressed(TagAddModule module){
    final name = _nameTextController.text;

    print('name -> '+name);

    if(name.isEmpty){
      ToastManager.show(i18n.str('CreateTag_ToastEnterTagName'));
      return;
    }

    module.addTag(
      name: _nameTextController.text,
      onSuccess: (){
        Navigator.pop(context, TagAddPageResultModel(
          isSuccess: true,
        ));
      },
      onFail: (errCode, errMessage){
        ToastManager.show(i18n.tr('CreateTag_ToastTagCreateFailed', errMessage));
      },
    );

  }

}