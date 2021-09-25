
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:log/log.dart';
import 'package:network/network.dart';
import 'package:sticker_board/page/choose_sticker_category_page.dart';
import 'package:sticker_board/page/choose_sticker_tag_page.dart';
import 'package:sticker_board_api/sticker_board_api.dart';
import 'package:toast/manager/toast_manager.dart';
import 'package:formatter/formatter.dart';
import 'package:url_builder/url_builder.dart';

class CreatePlainTextStickerPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _CreatePlainTextStickerPageState();
  }

}

class _CreatePlainTextStickerPageState extends State<CreatePlainTextStickerPage>{

  final TextEditingController _titleEditController = TextEditingController();
  final TextEditingController _messageEditController = TextEditingController();
  CategoryModel? _categoryModel;
  List<TagModel> _selectedTag = <TagModel>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Plain Text Sticker'),
        actions: [
          CupertinoButton(
            child: Text('Create',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => _onCreateStickerClicked(context),
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            maxLines: 1,
            controller: _titleEditController,
            decoration: InputDecoration(
              hintText: 'Title',
            ),
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Category'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(_categoryModel != null) Text(_categoryModel?.name ?? '<Unnamed Category>'),
                Icon(Icons.chevron_right),
              ],
            ),
            onTap: _onCategoryClick,
          ),
          ListTile(
            leading: Icon(Icons.tag),
            title: Text('Tag'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(_selectedTag.isNotEmpty) Text(_selectedTag.combineAll((index, item, result){
                    if(result == null || result.toString().trim().isEmpty){
                      return item.name;
                    } else {
                      return '$result, ${item.name}';
                    }
                  }),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Icon(Icons.chevron_right),
              ],
            ),
            onTap: _onTagClick,
          ),
          Expanded(
            child: TextField(
              maxLines: 999,
              controller: _messageEditController,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Message',
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Card(
      //   child: Text('Tool Bar'),
      // ),
    );
  }

  void _onCreateStickerClicked(BuildContext context){
    final titleText = _titleEditController.text;
    final messageText = _messageEditController.text;

    if(titleText.isEmpty && messageText.isEmpty){
      ToastManager.show('Please enter title or message');
      return;
    }

    NetworkManager.instance.fetch(URLBuilder.stickerCreatePlainText(),
        requestMethod: RequestMethod.Post,
        data: {
          'star' : 0,
          'status' : 0,
          'title' : titleText,
          'background' : '',
          'text' : messageText,
          'category_id' : _categoryModel?.id ?? '',
          'tag_id' : _selectedTag.map((e) => e.id).toList(),
          'is_pinned' : false,
        },
        onSuccess: (response) {
          LogManager.i('Create Plain Text Sticker Response : ', this.runtimeType.toString());
          LogManager.i(response, this.runtimeType.toString());
          final code = response['code'] ?? 0;
          final message = response['msg'] ?? 'Create sticker failed, please try again later';
          ToastManager.show(message);
          if(code == 200) {
            Navigator.pop(context);
          }
        },
        onFail: (error) {
          LogManager.i('Create Plain Text Sticker Fail : ', this.runtimeType.toString());
          LogManager.i(error.toString(), this.runtimeType.toString());
          ToastManager.show('Create sticker failed, network error');
        }
    );
  }

  void _onCategoryClick(){
    Navigator.push(context, MaterialPageRoute(
        builder: (routeContext){
          return ChooseStickerCategoryPage();
        }
    )).then((value){
      if(value == null){
        return;
      }
      if(value is ChooseStickerCategoryPageResponse){
        if(value.isChoose) {
          _categoryModel = value.categoryModel;
          setState(() { });
        }
      }
    });
  }

  void _onTagClick(){
    Navigator.push(context, MaterialPageRoute(
        builder: (routeContext){
          return ChooseStickerTagPage(
            selectedTags: _selectedTag.map((e) => e.id).toList(),
          );
        }
    )).then((value){
      if(value == null){
        return;
      }
      if(value is ChooseStickerTagResponse){
        if(value.isConfirm) {
          _selectedTag = value.tagList;
          setState(() { });
        }
      }
    });
  }

}
