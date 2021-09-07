import 'dart:io';

import 'package:file_selector/const/selector_action.dart';
import 'package:file_selector/model/file_model.dart';
import 'package:file_selector/model/selector_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_selector/model/directory_model.dart';
import 'package:flutter/material.dart';

class FilePickerPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _FilePickerPageState();
  }

}

class _FilePickerPageState extends State<FilePickerPage> {
  bool isLoading = true;
  final List<DirectoryModel> _directoryList = [];

  @override
  void initState() {
    super.initState();

    // Initialize root path
    _directoryList.clear();
    getDownloadsDirectory().then((value){
      _directoryList.add(DirectoryModel(value?.path ?? ''));
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Picker'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: _onCancelClicked,
        ),
      ),
      body: isLoading ? _buildLoadingWidget() : _buildContentWidget(),
    );
  }

  Widget _buildLoadingWidget(){
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoActivityIndicator(),
          Padding(
            padding: EdgeInsets.only(
              top: 16,
            ),
            child: Text('Loading...'),
          )
        ],
      ),
    );
  }

  Widget _buildContentWidget(){
    if(_directoryList.isEmpty){
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoActivityIndicator(),
            Padding(
              padding: EdgeInsets.only(
                top: 16,
              ),
              child: Text('< Empty >'),
            )
          ],
        ),
      );
    }

    final directory = _directoryList.last;
    final fileList = directory.fileList;
    return Column(
      children: [
        Container(
          color: Color(0xFFF2F5F7),
          height: 50,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left,
                  color: _directoryList.length > 1 ? Colors.black : Color(0xFFDDDDDD),
                ),
                onPressed: _onDirectoryGoBackPressed,
              ),
              Text(directory.path,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: fileList.length,
            separatorBuilder: (separatorContext, index){
              return Divider(
                thickness: 0.5,
                height: 0.5,
              );
            },
            itemBuilder: (itemContext, index){
              final fileModel = fileList[index];
              return ListTile(
                leading: Icon(fileModel.isDirectory ? Icons.folder_sharp : Icons.insert_drive_file_sharp),
                title: Text(fileModel.name,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                subtitle: Text('${fileModel.size} ${fileModel.isDirectory ? 'File' : 'Byte'}',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                trailing: fileModel.isDirectory ? Icon(Icons.chevron_right,
                  color: Colors.grey,
                ) : null,
                onTap: () => _onListItemClicked(fileModel),
              );
            },
          ),
        )
      ],
    );
  }

  void _onCancelClicked(){
    Navigator.pop(context, PickerResponse(
      pickerAction: PickerAction.Cancel,
    ));
  }

  void _onDirectoryGoBackPressed(){
    if(_directoryList.length <= 1){
      return;
    }
    _directoryList.removeLast();

    setState(() { });
  }

  void _onListItemClicked(FileModel fileModel){
    if(fileModel.isDirectory){
      // If select a directory
      _directoryList.add(DirectoryModel(fileModel.path));
      setState(() { });
    } else {
      // If select a file
      Navigator.pop(context, PickerResponse(
        pickerAction: PickerAction.Confirm,
        fileList: [
          fileModel,
        ],
      ));
    }

  }

}

