import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:log/log.dart';
import 'package:toast/manager/toast_manager.dart';
import 'package:formatter/formatter.dart';

class CreatePlainImageStickerPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _CreatePlainImageStickerPageState();

}

class _CreatePlainImageStickerPageState extends State<CreatePlainImageStickerPage> {
  final TextEditingController _titleEditController = TextEditingController();
  final TextEditingController _descriptionEditController = TextEditingController();

  String imagePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F5F7),
      appBar: AppBar(
        title: Text('Create Plain Image Sticker'),
        actions: [
          CupertinoButton(
            child: Text('Create',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => _onCreateSticker(context),
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
                hintText: 'Description ( Also used to search this sticker )',
              ),
            ),
            ListTile(
              title: Text('Image'),
              subtitle: Text(imagePath.isEmpty ? 'Not selected yet' : imagePath),
              trailing: Icon(Icons.chevron_right),
              onTap: () => _onPickImage(context),
            ),
          ],
        ),
      ),
    );
  }

  void _onPickImage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(
        builder: (routeContext){
          return FilePickerPage();
        }
    )).then((response){
      // check response value is valid
      if(!(response is PickerResponse)){
        return;
      }
      if(response.pickerAction != PickerAction.Confirm){
        return;
      }
      final fileList = response.fileList;
      if(fileList.isEmpty) {
        return;
      }

      // check whether the file is an image
      final path = fileList.first.path;
      final pathFileExtension = path.pathFileExtension();
      if(!isImageFileExtension(pathFileExtension)){
        ToastManager.show('The file your selected is not an image, please choose an image file.');
        return;
      }

      imagePath = path;
      setState(() { });
    }).catchError((error){
      LogManager.w('Error occur while selecting image in CreatePlainImageStickerPage, error=$error', this.runtimeType);
      ToastManager.show('Error, please try again later');
    });
  }

  void _onCreateSticker(BuildContext context){
    if(imagePath.isEmpty){
      ToastManager.show('Please choose an image file to upload');
      return;
    }
    if(!FileSystemEntity.isFileSync(imagePath)){
      ToastManager.show('The path your choose is not a file.');
      return;
    }
    final file = File(imagePath);
    if(!file.existsSync()){
      ToastManager.show('The file has been deleted, please choose another file.');
      return;
    }
    // 1. Request an signature from server

    // 2. Upload to OSS

  }

}
