
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:file_uploader/file_uploader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formatter/formatter.dart';
import 'package:i18n/i18n.dart';
import 'package:log/log.dart';
import 'package:network/enum/request_method.dart';
import 'package:network/manager/network_manager.dart';
import 'package:sticker_board/cache/sticker_category_cache.dart';
import 'package:sticker_board/cache/sticker_tag_cache.dart';
import 'package:sticker_board_api/sticker_board_api.dart';
import 'package:kv_storage/kv_storage.dart';
import 'package:toast/toast.dart';
import 'package:url_builder/url_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class CreatePlainSoundStickerPage extends StatefulWidget{
  late StickerPlainSoundModel stickerModel;

  CreatePlainSoundStickerPage({
    StickerPlainSoundModel? sticker,
  }){
    stickerModel = sticker ?? StickerPlainSoundModel.createEmpty();
  }

  @override
  State<StatefulWidget> createState() {
    return _CreatePlainSoundStickerPageState();
  }

}

class _CreatePlainSoundStickerPageState extends State<CreatePlainSoundStickerPage> {
  late TextEditingController _soundTitleController = TextEditingController();
  late TextEditingController _soundDescriptionController = TextEditingController();

  String _soundPath = '';

  CategoryModel? _categoryModel;
  List<TagModel> _selectedTag = <TagModel>[];

  // Whether this page is use for create sticker
  bool get isCreateSticker => widget.stickerModel.id.isEmpty;

  @override
  void initState() {
    super.initState();
    // Init Data
    // init title
    _soundTitleController.text = widget.stickerModel.title;
    // init description
    _soundDescriptionController.text = widget.stickerModel.description;
    // init category
    _categoryModel = StickerCategoryCache.instance.getCategoryModel(widget.stickerModel.category);
    // init tag
    widget.stickerModel.tags.forEach((tagID) {
      final tagModel = StickerTagCache.instance.getTagModel(tagID);
      if(tagModel != null){
        _selectedTag.add(tagModel);
      }
    });
    // init image path
    _soundPath = widget.stickerModel.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.str(isCreateSticker ? 'CreateSoundSticker_TitleCreate': 'CreateSoundSticker_TitleEdit')),
        actions: [
          CupertinoButton(
            child: Text(i18n.str(isCreateSticker ? 'CreateSoundSticker_ActionCreate' : 'CreateSoundSticker_ActionEdit'),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => isCreateSticker ? _onCreatePressed() : _onUpdatePressed(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _soundTitleController,
              decoration: InputDecoration(
                hintText: 'CreateSoundSticker_ParamsTitle'.i18n(),
              ),
            ),
            TextField(
              controller: _soundDescriptionController,
              decoration: InputDecoration(
                hintText: 'CreateSoundSticker_ParamsDescription'.i18n(),
              ),
            ),
            ListTile(
              title: Text('CreateSoundSticker_ParamsSound'.i18n()),
              subtitle: Text(_soundPath.isEmpty ? 'CreateSoundSticker_ValueSound'.i18n() : _soundPath),
              trailing: Icon(Icons.chevron_right),
              onTap: () => _onPickSound(context),
            ),
            if(_soundPath.startsWith('http://') || _soundPath.startsWith('https://')) ListTile(
              title: Text('CreateSoundSticker_ParamsPreview'.i18n()),
              trailing: Icon(Icons.open_in_new),
              onTap: _onPreviewTap,
            )
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
        ToastManager.show('CreateSoundSticker_HintNotValidSound'.i18n());
        return;
      }

      _soundPath = path;
      setState(() { });
    }).catchError((error){
      LogManager.w('Error occur while selecting sound in CreatePlainSoundStickerPage, error=$error', this.runtimeType);
      ToastManager.show('CreateSoundSticker_HintError'.i18n());
    });
  }

  void _onPreviewTap(){
    canLaunch(_soundPath).then((canLaunch){
      if(canLaunch){
        launch(_soundPath);
      } else {
        ToastManager.show('CreateSoundSticker_HintPreviewError'.i18n());
      }
    });
  }

  void _onCreatePressed(){
    LogManager.i('Create Plain Sound Sticker', this.runtimeType);

    if(_soundPath.isEmpty){
      ToastManager.show('CreateSoundSticker_HintChooseSoundFileUpload'.i18n());
      return;
    }
    if(!FileSystemEntity.isFileSync(_soundPath)){
      ToastManager.show('CreateSoundSticker_HintPathNotFile'.i18n());
      return;
    }

    final file = File(_soundPath);
    if(!file.existsSync()){
      ToastManager.show('CreateSoundSticker_HintFileDeleted'.i18n());
      return;
    }

    // 1. Parse request Params
    final uid = KVStorageManager.getString('app_current_uid', '');   // TODO : SHOULD DEFINE THIS KEY IN COMMON WORKSPACE
    final token = KVStorageManager.getString('app_current_token', ''); // TODO : SHOULD DEFINE THIS KEY IN COMMON WORKSPACE
    if(uid.isEmpty || token.isEmpty){
      ToastManager.show('CreateSoundSticker_HintLoginExpired'.i18n());
      return;
    }
    final paramsTitle = _soundTitleController.text.trim();
    final paramsDescription = _soundDescriptionController.text;
    
    // 2. Upload file to file server
    ToastManager.show('CreateSoundSticker_HintUploading'.i18n());
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
            ToastManager.show('CreateSoundSticker_HintCreateSuccess'.i18n());
          }else{
            ToastManager.show(i18n.tr('CreateSoundSticker_HintCreateFailMessage', value.message));
          }
        }).catchError((error){
          ToastManager.show(i18n.tr('CreateSoundSticker_HintCreateFailMessage', error));
        });
      },
      onFail: (code, message){
        ToastManager.show(message);
      },
    );
  }

  void _onUpdatePressed(){
    // 1. Sound path can not be empty
    if(_soundPath.isEmpty){
      ToastManager.show('CreateSoundSticker_HintChooseSoundFileUpload'.i18n());
      return;
    }
    // 2. check whether new image url is already uploaded
    if(_soundPath.startsWith('http://') || _soundPath.startsWith('https://')){
      // File Already uploaded
      _onUpdateStickerSendRequest(_soundPath);
    } else {
      // File haven't uploaded yet, should upload now
      // Check file path is exist
      final file = File(_soundPath);
      if(!file.existsSync()){
        ToastManager.show('CreateSoundSticker_HintFileDeleted'.i18n());
        return;
      }
      // Upload file to file server
      final uid = KVStorageManager.getString('app_current_uid', '');   // TODO : SHOULD DEFINE THIS KEY IN COMMON WORKSPACE
      final token = KVStorageManager.getString('app_current_token', ''); // TODO : SHOULD DEFINE THIS KEY IN COMMON WORKSPACE
      if(uid.isEmpty || token.isEmpty){
        ToastManager.show('CreateSoundSticker_HintLoginExpired'.i18n());
        return;
      }
      ToastManager.show('CreateSoundSticker_HintUploading'.i18n());
      OSSUploader.instance.uploadFile(file, uid, token, 'create_sticker_plain_sound',
        onSuccess: (path, bucket){
          // 3. Add sticker to server
          _onUpdateStickerSendRequest(path);
        },
        onFail: (code, message){
          ToastManager.show(message);
        },
      );
    }
  }

  void _onUpdateStickerSendRequest(String soundUrl){
    NetworkManager.instance.rawFetch(URLBuilder.stickerUpdatePlainSound(),
      requestMethod: RequestMethod.Post,
      jsonData: {
        'sticker_id': widget.stickerModel.id,
        'star' : 0,
        'status' : StickerStatus.Processing,
        'title' : _soundTitleController.text.trim(),
        'background' : '',
        'category_id' : _categoryModel?.id ?? '',
        'tag_id' : _selectedTag.map((e) => e.id).toList(),
        'is_pinned' : false,
        'description' : _soundDescriptionController.text.trim(),
        'path' : soundUrl,
        'duration' : 0,
      },
    ).then((response){
      final responseCode = response.data['code'];
      final responseMessage = response.data['msg'];
      if(responseCode == 200){
        ToastManager.show('CreateSoundSticker_HintCreateSuccess'.i18n());
        Navigator.pop(context);
      } else {
        ToastManager.show(responseMessage);
      }
    }).catchError((error){
      print(error);
      ToastManager.show('CreateSoundSticker_HintError'.i18n());
    });
  }

}

