
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sticker_board/cache/sticker_tag_cache.dart';
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
            onTap: () => _onSelectTag(item.id),
          );
        },
      ),
    );
  }

  Future _onLoad({
    bool loadFromInternet = false,
  }) async {
    _hintMessage = 'Loading...';
    setState(() { });

    return StickerTagCache.instance.fetch(forceRefresh: loadFromInternet).then((response){
      _tagModelList.clear();
      if(response.isFetchSuccess){
        if(response.data.isEmpty){
          _hintMessage = 'Empty';
        } else {
          _tagModelList.addAll(response.data);
          _hintMessage = '';
        }
      } else {
        _hintMessage = response.message;
      }

      setState(() { });
    });
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
    // find out all available tags
    List<TagModel> resultTag = [];
    Map<String, TagModel> tmpTagCache = {};
    _tagModelList.forEach((tagModel) {
      tmpTagCache[tagModel.id] = tagModel;
    });
    _selectedTagIDSet.forEach((tagID) {
      final tmpTag = tmpTagCache[tagID];
      if(tmpTag != null && tmpTag is TagModel){
        resultTag.add(tmpTag);
      }
    });
    // return tag models
    Navigator.pop(context, ChooseStickerTagResponse(
      isConfirm: true,
      tagList: resultTag,
    ));
  }

}

class ChooseStickerTagResponse {
  bool isConfirm;
  List<TagModel> tagList;

  ChooseStickerTagResponse({
    required this.isConfirm,
    required this.tagList,
  });

}
