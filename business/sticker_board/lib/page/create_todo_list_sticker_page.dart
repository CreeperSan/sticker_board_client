
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formatter/extensions/collection/collection_operation_extensions.dart';
import 'package:i18n/i18n.dart';
import 'package:network/enum/request_method.dart';
import 'package:network/manager/network_manager.dart';
import 'package:sticker_board/cache/sticker_category_cache.dart';
import 'package:sticker_board/cache/sticker_tag_cache.dart';
import 'package:sticker_board/page/choose_sticker_category_page.dart';
import 'package:sticker_board/page/choose_sticker_tag_page.dart';
import 'package:sticker_board_api/model/sticker_todo_list_model.dart';
import 'package:sticker_board_api/sticker_board_api.dart';
import 'package:toast/toast.dart';
import 'package:url_builder/url_builder.dart';


class CreateTodoListStickerPage extends StatefulWidget{
  late StickerTodoListModel stickerModel;

  CreateTodoListStickerPage({
    StickerTodoListModel? sticker,
  }){
    stickerModel = sticker ?? StickerTodoListModel.createEmpty();
  }

  @override
  State<StatefulWidget> createState() {
    return _CreateTodoListStickerPageState();
  }

}

class _CreateTodoListStickerPageState extends State<CreateTodoListStickerPage> {
  List<TodoItem> _todoItemList = [];

  TextEditingController _titleEditController = TextEditingController();
  TextEditingController _descriptionEditController = TextEditingController();
  CategoryModel? _categoryModel;
  List<TagModel> _selectedTag = <TagModel>[];

  bool get isCreateSticker => widget.stickerModel.id.isEmpty;

  @override
  void initState() {
    super.initState();
    // Init Data
    // init title
    _titleEditController.text = widget.stickerModel.title;
    // init description
    _descriptionEditController.text = widget.stickerModel.description;
    // init category
    _categoryModel = StickerCategoryCache.instance.getCategoryModel(widget.stickerModel.category);
    // init tag
    widget.stickerModel.tags.forEach((tagID) {
      final tagModel = StickerTagCache.instance.getTagModel(tagID);
      if(tagModel != null){
        _selectedTag.add(tagModel);
      }
    });
    // init item list
    _todoItemList.clear();
    _todoItemList.addAll(widget.stickerModel.todoList.map((itemModel){
      return TodoItem(
        status: itemModel.state,
        title: itemModel.message,
        description: itemModel.description,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((isCreateSticker ? 'CreateTodoListSticker_TitleCreate' : 'CreateTodoListSticker_TitleEdit').i18n()),
        actions: [
          CupertinoButton(
            child: Text((isCreateSticker ? 'CreateTodoListSticker_ActionCreate' : 'CreateTodoListSticker_ActionEdit').i18n(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: _onCreatePressed,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _titleEditController,
              decoration: InputDecoration(
                hintText: 'CreateTodoListSticker_ParamsTitle'.i18n(),
              ),
            ),
            TextField(
              controller: _descriptionEditController,
              decoration: InputDecoration(
                hintText: 'CreateTodoListSticker_PlaceHolderDescription'.i18n(),
              ),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('CreateTodoListSticker_ParamsCategory'.i18n()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(_categoryModel != null) Text(_categoryModel?.name ?? 'CreateTodoListSticker_ValueCategoryUnknown'.i18n()),
                  Icon(Icons.chevron_right),
                ],
              ),
              onTap: _onCategoryClick,
            ),
            ListTile(
              leading: Icon(Icons.tag),
              title: Text('CreateTodoListSticker_ParamsTag'.i18n()),
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: _todoItemList.length,
              itemBuilder: (itemContext, index){
                final todoItem = _todoItemList[index];
                return Container(
                  height: 50,
                  child: Row(
                    children: [
                      Checkbox(
                        value: todoItem.status == TodoItem.STATUS_FINISH,
                        onChanged: (isCheck) => _onTodoItemCheckChanged(index, isCheck ?? false),
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) => _onTodoItemValueChange(index, value),
                          controller: TextEditingController(text: todoItem.title),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _onTodoItemRemove(index),
                      ),
                    ],
                  ),
                );
              },
            ),
            CupertinoButton(
              child: Container(
                height: 50,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: 16,
                        ),
                        child: Icon(Icons.add),
                      ),
                      Text('CreateTodoListSticker_ActionAddItem'.i18n()),
                    ],
                  ),
                ),
              ),
              onPressed: _onTodoItemCreate,
            ),
          ],
        ),
      ),
    );
  }

  void _onTodoItemCheckChanged(int index, bool isCheck){
    final todoItem = _todoItemList[index];
    todoItem.status = isCheck ? TodoItem.STATUS_FINISH : TodoItem.STATUS_PENDING;
    setState(() {});
  }

  void _onTodoItemValueChange(int index, String title){
    final todoItem = _todoItemList[index];
    todoItem.title = title;
  }

  void _onTodoItemCreate(){
    _todoItemList.add(TodoItem(
      status: TodoItem.STATUS_PENDING,
      title: '',
    ));
    setState(() {});
  }

  void _onTodoItemRemove(int index){
    _todoItemList.removeAt(index);
    setState(() {});
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

  void _onCreatePressed(){
    final paramsTitle = _titleEditController.text.trim();
    final paramsDescription = _descriptionEditController.text.trim();

    List<Map<String, dynamic>> todoList = [];
    for(var element in _todoItemList){
      if(element.title.isEmpty){
        ToastManager.show('CreateTodoListSticker_HintItemEmpty'.i18n());
        return;
      }
      todoList.add({
        'state' : element.status,
        'message' : element.title,
        'description' : element.description,
      });
    }

    if(todoList.isEmpty){
      ToastManager.show('CreateTodoListSticker_HintListEmpty'.i18n());
      return;
    }

    if(isCreateSticker){
      // Create todo sticker
      NetworkManager.instance.rawFetch(URLBuilder.stickerCreateTodoList(),
        requestMethod: RequestMethod.Post,
        jsonData: {
          'star' : 0,
          'status' : 0,
          'title' : paramsTitle,
          'description' : paramsDescription,
          'background' : '',
          'category_id' : _categoryModel?.id ?? '',
          'tag_id' : _selectedTag.map((e) => e.id).toList(),
          'is_pinned' : false,
          'todos' : todoList,
        },
      ).then((value){
        print(value.runtimeType);
        print(value);
        final code = value.data['code'];
        final message = value.data['msg'];
        if(code == 200){
          ToastManager.show('CreateTodoListSticker_HintCreateSuccess'.i18n());
          Navigator.pop(context);
        }else{
          ToastManager.show(i18n.tr('CreateTodoListSticker_HintCreateFailMessage', message));
        }
      }).catchError((error){
        ToastManager.show('CreateTodoListSticker_HintCreateFailNetwork'.i18n());
      });
    } else {
      // Update todo sticker
      NetworkManager.instance.rawFetch(URLBuilder.stickerUpdateTodoList(),
        requestMethod: RequestMethod.Post,
        jsonData: {
          'sticker_id' : widget.stickerModel.id,
          'star' : 0,
          'status' : 0,
          'title' : paramsTitle,
          'description' : paramsDescription,
          'background' : '',
          'category_id' : _categoryModel?.id ?? '',
          'tag_id' : _selectedTag.map((e) => e.id).toList(),
          'is_pinned' : false,
          'todos' : todoList,
        },
      ).then((value){
        print(value.runtimeType);
        print(value);
        final code = value.data['code'];
        final message = value.data['msg'];
        if(code == 200){
          ToastManager.show('CreateTodoListSticker_HintCreateSuccessUpdate'.i18n());
          Navigator.pop(context);
        }else{
          ToastManager.show(i18n.tr('CreateTodoListSticker_HintCreateFailMessageUpdate', message));
        }
      }).catchError((error){
        ToastManager.show('CreateTodoListSticker_HintCreateFailNetworkUpdate'.i18n());
      });
    }
  }

}


class TodoItem{
  static const STATUS_FINISH = 1;
  static const STATUS_PENDING = 0;

  int status;
  String title;
  String description;

  TodoItem({
    required this.status,
    required this.title,
    this.description = ''
  });

}
