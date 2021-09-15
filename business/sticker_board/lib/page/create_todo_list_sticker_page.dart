
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network/enum/request_method.dart';
import 'package:network/manager/network_manager.dart';
import 'package:toast/toast.dart';
import 'package:url_builder/url_builder.dart';

class CreateTodoListStickerPage extends StatefulWidget{

  // CreateTodoListStickerPage({
  //
  // });

  @override
  State<StatefulWidget> createState() {
    return _CreateTodoListStickerPageState();
  }

}

class _CreateTodoListStickerPageState extends State<CreateTodoListStickerPage> {
  List<TodoItem> _todoItemList = [];

  late TextEditingController _titleEditController;
  late TextEditingController _descriptionEditController;

  @override
  void initState() {
    super.initState();
    _titleEditController = TextEditingController();
    _descriptionEditController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todo List Sticker'),
        actions: [
          CupertinoButton(
            child: Text('Create',
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
                hintText: 'Title',
              ),
            ),
            TextField(
              controller: _descriptionEditController,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
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
                      Text('Add Item'),
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

  void _onCreatePressed(){
    final paramsTitle = _titleEditController.text.trim();
    final paramsDescription = _descriptionEditController.text.trim();

    List<Map<String, dynamic>> todoList = [];
    for(var element in _todoItemList){
      if(element.title.isEmpty){
        ToastManager.show('Todo item content can not be empty');
        return;
      }
      todoList.add({
        'state' : element.status,
        'message' : element.title,
        'description' : element.description,
      });
    }

    if(todoList.isEmpty){
      ToastManager.show('Todo list can not be empty');
      return;
    }

    NetworkManager.instance.rawFetch(URLBuilder.stickerCreateTodoList(),
      requestMethod: RequestMethod.Post,
      jsonData: {
        'star' : 0,
        'status' : 0,
        'title' : paramsTitle,
        'description' : paramsDescription,
        'background' : '',
        'category_id' : '',
        'tag_id' : [],
        'is_pinned' : false,
        'todos' : todoList,
      },
    ).then((value){
      print(value.runtimeType);
      print(value);
      final code = value.data['code'];
      final message = value.data['msg'];
      if(code == 200){
        ToastManager.show('Create success');
        Navigator.pop(context);
      }else{
        ToastManager.show('Create failed, $message');
      }
    }).catchError((error){
      ToastManager.show('Create failed, please check your internet connection');
    });
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
