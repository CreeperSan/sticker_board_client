
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:file_uploader/file_uploader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formatter/formatter.dart';
import 'package:log/log.dart';
import 'package:sticker_board_api/sticker_board_api.dart';
import 'package:kv_storage/kv_storage.dart';
import 'package:toast/toast.dart';

class CreatePlainSoundStickerPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _CreatePlainSoundStickerPageState();
  }

}

class _CreatePlainSoundStickerPageState extends State<CreatePlainSoundStickerPage> {
  late TextEditingController _soundTitleController;
  late TextEditingController _soundDescriptionController;

  String _soundPath = '';

  @override
  void initState() {
    super.initState();
    _soundTitleController = TextEditingController();
    _soundDescriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Plain Sound Sticker'),
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
              controller: _soundTitleController,
              decoration: InputDecoration(
                hintText: 'Title',
              ),
            ),
            TextField(
              controller: _soundDescriptionController,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
            ),
            ListTile(
              title: Text('Sound'),
              subtitle: Text(_soundPath.isEmpty ? 'Not selected yet' : _soundPath),
              trailing: Icon(Icons.chevron_right),
              onTap: () => _onPickSound(context),
            ),
          ],
        ),
      ),
    );
  }

  void _onPickSound(BuildContext pageContext){
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

      // check whether the file is sound
      final path = fileList.first.path;
      final pathFileExtension = path.pathFileExtension();
      if(!isSoundExtension(pathFileExtension)){
        ToastManager.show('The file your selected is not sound file, please choose another one.');
        return;
      }

      _soundPath = path;
      setState(() { });
    }).catchError((error){
      LogManager.w('Error occur while selecting sound in CreatePlainSoundStickerPage, error=$error', this.runtimeType);
      ToastManager.show('Error, please try again later');
    });
  }

  void _onCreatePressed(){
    LogManager.i('Create Plain Sound Sticker', this.runtimeType);

    if(_soundPath.isEmpty){
      ToastManager.show('Please choose an audio file to upload');
      return;
    }
    if(!FileSystemEntity.isFileSync(_soundPath)){
      ToastManager.show('The path your choose is not a file.');
      return;
    }

    final file = File(_soundPath);
    if(!file.existsSync()){
      ToastManager.show('The file has been deleted, please choose another file.');
      return;
    }

    // 1. Parse request Params
    final uid = KVStorageManager.getString('app_current_uid', '');   // TODO : SHOULD DEFINE THIS KEY IN COMMON WORKSPACE
    final token = KVStorageManager.getString('app_current_token', ''); // TODO : SHOULD DEFINE THIS KEY IN COMMON WORKSPACE
    if(uid.isEmpty || token.isEmpty){
      ToastManager.show('Login expired. Please login again.');
      return;
    }
    final paramsTitle = _soundTitleController.text.trim();
    final paramsDescription = _soundDescriptionController.text;
    
    // 2. Upload file to file server
    ToastManager.show('Uploading...');
    OSSUploader.instance.uploadFile(file, uid, token, 'create_sticker_plain_sound',
      onSuccess: (path, bucket){
        // 3. Add sticker to server
        StickerBoardManager.instance.createStickerPlainSound(
          soundPath: path,
          title: paramsTitle,
          description: paramsDescription,
          duration: 10 * 1000, // TODO: Currently can not find a lib that could support both android, ios, windows, linux, macos and web platform, considering write a new lib or just wait...
        ).then((value){
          if(value.isSuccess){
            ToastManager.show('Create Success');
          }else{
            ToastManager.show('Create failed, ${value.message}');
          }
        }).catchError((error){
          ToastManager.show('Create failed, $error');
        });
      },
      onFail: (code, message){
        ToastManager.show(message);
      },
    );
  }

}

