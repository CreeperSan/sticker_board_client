
import 'package:flutter/material.dart';
import 'package:sticker_board/widget/sticker/common/sticker_widget_common_part_builder.dart';
import 'package:sticker_board_api/model/sticker_todo_list_model.dart';
import 'package:sticker_board_api/sticker_board_api.dart';

class TodoListStickerWidget extends StatelessWidget{

  final StickerTodoListModel model;
  final void Function()? onClick;

  TodoListStickerWidget(this.model, {
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget = Container(
      margin: EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 6,
      ),
      padding: EdgeInsets.only(
        top: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          if(model.title.isNotEmpty) Padding(
            padding: EdgeInsets.only(
              bottom: 12,
              left: 12,
              right: 12,
            ),
            child: Text(model.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),

          // Message
          if(model.description.isNotEmpty) Padding(
            padding: EdgeInsets.only(
              bottom: 12,
              left: 12,
              right: 12,
            ),
            child: Text(model.description,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ),

          // Items
          // IgnorePointer(
          //   child: ListView.builder(
          //     itemCount: model.todoList.length,
          //     shrinkWrap: true,
          //     itemBuilder: (itemContext, index){
          //       return Container(
          //         height: 30,
          //
          //       );
          //     },
          //   ),
          // ),
          if(model.todoList.length > 0) IgnorePointer(
            child: Column(
              children: model.todoList.map((e){
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: e.isFinish,
                        onChanged: (_){},
                      ),
                      Text(e.message),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),


          // Category & Tags
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: StickerWidgetCommonPartBuilder.buildCategoryAndTagPart(model),
          ),
        ],
      ),
    );

    if(onClick != null){
      widget = GestureDetector(
        onTap: () => onClick?.call(),
        child: widget,
      );
    }

    return widget;
  }

}

