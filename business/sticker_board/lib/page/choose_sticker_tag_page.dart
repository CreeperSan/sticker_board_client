
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sticker_board_api/model/tag_model.dart';

class ChooseStickerTagPage extends StatefulWidget{
  final List<String> selectedTags;

  ChooseStickerTagPage({
    this.selectedTags = const [],
  });

  @override
  State<StatefulWidget> createState() {
    return _ChooseStickerTagPageState();
  }

}

class _ChooseStickerTagPageState extends State<ChooseStickerTagPage>{
  List<TagModel> _tagModelList = [];
  Set<String> _selectedTagIDSet = HashSet<String>();
  String _hintMessage = '';

  @override
  void initState() {
    super.initState();

    // Init data
    _selectedTagIDSet.addAll(widget.selectedTags);

    // Trigger load data
    _onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Tag'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: _onBackPressed,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check,
              color: Colors.white,
            ),
            onPressed: _onConfirmPressed,
          ),
        ],
      ),
      body: _hintMessage.isNotEmpty ? _buildHintBody() : _buildContentBody(),
    );
  }

  Widget _buildHintBody(){
    return Center(
      child: Text(_hintMessage),
    );
  }

  Widget _buildContentBody(){
    return RefreshIndicator(
      onRefresh: () => _onLoad(loadFromInternet: true),
      child: ListView.builder(
        itemCount: _tagModelList.length,
        itemBuilder: (itemContext, index){
          final item = _tagModelList[index];
          return ListTile(
            leading: Icon(Icons.tag),
            title: Text(item.name),
            trailing: IgnorePointer(
              child: Checkbox(
                onChanged: null,
                value: _selectedTagIDSet.contains(item.id),
              ),
            ),
            onTap: () => _onSelectTag(item.name),
          );
        },
      ),
    );
  }

  Future _onLoad({
    bool loadFromInternet = false,
  }){
    _hintMessage = 'Loading...';
    setState(() { });


    return Future.value();
  }

  void _onSelectTag(String tagID){
    if(_selectedTagIDSet.contains(tagID)){
      _selectedTagIDSet.remove(tagID);
    } else {
      _selectedTagIDSet.add(tagID);
    }
    setState(() { });
  }

  void _onBackPressed(){
    Navigator.pop(context, ChooseStickerTagResponse(
      isConfirm: false,
      tagList: [],
    ));
  }

  void _onConfirmPressed(){
    Navigator.pop(context, ChooseStickerTagResponse(
      isConfirm: true,
      tagList: _selectedTagIDSet.toList(),
    ));
  }

}

class ChooseStickerTagResponse {
  bool isConfirm;
  List<String> tagList;

  ChooseStickerTagResponse({
    required this.isConfirm,
    required this.tagList,
  });

}
