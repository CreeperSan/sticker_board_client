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
                leading: Container(
                  width: 36,
                  height: 36,
                  child: _getFileIcon(fileModel),
                ),
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


  Widget _getFileIcon(FileModel fileModel){
    switch(fileModel.fileType){
      case FileType.Directory:
        return Icon(Icons.folder_sharp);
      case FileType.CompressFile:
        return Icon(Icons.book);
      case FileType.Code:
        return Icon(Icons.code);
      case FileType.Markdown:
      case FileType.Text:
        return Icon(Icons.text_snippet);
      case FileType.Image:
        // return Icon(Icons.image);
        return Image.file(File(fileModel.path),
          width: 36,
          height: 36,
          fit: BoxFit.cover,
        );
      case FileType.Sound:
        return Icon(Icons.music_note);
      case FileType.Video:
      case FileType.Flash:
        return Icon(Icons.video_collection);
      case FileType.Windows:
        return Icon(Icons.desktop_windows);
      case FileType.OfficeWord:
      case FileType.OfficePowerPoint:
      case FileType.OfficeExcel:
      default:
        return Icon(Icons.insert_drive_file_sharp);
    }
  }

}

