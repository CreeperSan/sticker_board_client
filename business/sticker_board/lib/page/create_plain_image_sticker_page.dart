import 'dart:io';

import 'package:file_uploader/file_uploader.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:log/log.dart';
import 'package:network/manager/network_manager.dart';
import 'package:network/network.dart';
import 'package:sticker_board/cache/sticker_category_cache.dart';
import 'package:sticker_board/cache/sticker_tag_cache.dart';
import 'package:sticker_board/page/choose_sticker_category_page.dart';
import 'package:sticker_board/page/choose_sticker_tag_page.dart';
import 'package:sticker_board_api/sticker_board_api.dart';
import 'package:sticker_board_api/sticker_board_managers.dart';
import 'package:toast/manager/toast_manager.dart';
import 'package:formatter/formatter.dart';
import 'package:kv_storage/kv_storage.dart';
import 'package:url_builder/url_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class CreatePlainImageStickerPage extends StatefulWidget {
  late StickerPlainImageModel stickerModel;

  CreatePlainImageStickerPage({
    StickerPlainImageModel? sticker,
  }){
    stickerModel = sticker ?? StickerPlainImageModel.createEmpty();
  }

  @override
  State<StatefulWidget> createState() => _CreatePlainImageStickerPageState();

}

class _CreatePlainImageStickerPageState extends State<CreatePlainImageStickerPage> {
  final TextEditingController _titleEditController = TextEditingController();
  final TextEditingController _descriptionEditController = TextEditingController();

  String imagePath = '';

  CategoryModel? _categoryModel;
  List<TagModel> _selectedTag = <TagModel>[];

  // Whether this page is use for create sticker
  bool get isCreateSticker => widget.stickerModel.id.isEmpty;

  @override
  void initState() {
    super.initState();
    // Init data
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
    // init image path
    imagePath = widget.stickerModel.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F5F7),
      appBar: AppBar(
        title: Text('${isCreateSticker ? 'Create': 'Edit'} Plain Image Sticker'),
        actions: [
          CupertinoButton(
            child: Text(isCreateSticker ? 'Create' : 'Update',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => isCreateSticker ? _onCreateSticker(context) : _onUpdateSticker(context),
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
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Category'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(_categoryModel != null) Text(_categoryModel?.name ?? '<Unnamed Category>'),
                  Icon(Icons.chevron_right),
                ],
              ),
              onTap: _onCategoryClick,
            ),
            ListTile(
              leading: Icon(Icons.tag),
              title: Text('Tag'),
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
            if(imagePath.startsWith('http://') || imagePath.startsWith('https://')) ListTile(
              title: Text('Preview'),
              trailing: Icon(Icons.open_in_new),
              onTap: _onPreviewTap,
            )
          ],
        ),
      ),
    );
  }

  void _onPreviewTap(){
    canLaunch(imagePath).then((canLaunch){
      if(canLaunch){
        launch(imagePath);
      } else {
        ToastManager.show('Can not preview this image');
      }
    });
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
    // 1. Upload file to file server
    final uid = KVStorageManager.getString('app_current_uid', '');   // TODO : SHOULD DEFINE THIS KEY IN COMMON WORKSPACE
    final token = KVStorageManager.getString('app_current_token', ''); // TODO : SHOULD DEFINE THIS KEY IN COMMON WORKSPACE
    if(uid.isEmpty || token.isEmpty){
      ToastManager.show('Login expired. Please login again.');
      return;
    }
    ToastManager.show('Uploading...');
    OSSUploader.instance.uploadFile(file, uid, token, 'create_sticker_plain_image',
      onSuccess: (path, bucket){
        // 2. Add sticker to server
        NetworkManager.instance.rawFetch(URLBuilder.stickerCreatePlainImage(),
            requestMethod: RequestMethod.Post,
            jsonData: {
              'star' : 0,
              'status' : StickerStatus.Processing,
              'title' : _titleEditController.text.trim(),
              'background' : '',
              'category_id' : _categoryModel?.id ?? '',
              'tag_id' : _selectedTag.map((e) => e.id).toList(),
              'is_pinned' : false,
              'description' : _descriptionEditController.text,
              'image_path' : path,
            },
        ).then((response){
          final responseCode = response.data['code'];
          final responseMessage = response.data['msg'];
          if(responseCode == 200){
            ToastManager.show('Sticker create success.');
            Navigator.pop(context);
          } else {
            ToastManager.show(responseMessage);
          }
        }).catchError((error){
          print(error);
          ToastManager.show('Create plain image sticker fail, please try again later.');
        });
      },
      onFail: (code, message){
        ToastManager.show(message);
      },
    );

  }

  void _onUpdateSticker(BuildContext context){
    // 1. Image path can not be empty
    if(imagePath.isEmpty){
      ToastManager.show('Please choose an image file to upload');
      return;
    }
    // 2. check whether new image url is already uploaded
    if(imagePath.startsWith('http://') || imagePath.startsWith('https://')){
      // File Already uploaded
      _onUpdateStickerSendRequest(imagePath);
    } else {
      // File haven't uploaded yet, should upload now
      // Check file path is exist
      final file = File(imagePath);
      if(!file.existsSync()){
        ToastManager.show('The file has been deleted, please choose another file.');
        return;
      }
      // Upload file to file server
      final uid = KVStorageManager.getString('app_current_uid', '');   // TODO : SHOULD DEFINE THIS KEY IN COMMON WORKSPACE
      final token = KVStorageManager.getString('app_current_token', ''); // TODO : SHOULD DEFINE THIS KEY IN COMMON WORKSPACE
      if(uid.isEmpty || token.isEmpty){
        ToastManager.show('Login expired. Please login again.');
        return;
      }
      ToastManager.show('Uploading...');
      OSSUploader.instance.uploadFile(file, uid, token, 'create_sticker_plain_image',
        onSuccess: (path, bucket){
          _onUpdateStickerSendRequest(path);
        },
        onFail: (code, message){
          ToastManager.show(message);
        },
      );
    }
  }

  void _onUpdateStickerSendRequest(String imageUrl){
    // 2. Add sticker to server
    NetworkManager.instance.rawFetch(URLBuilder.stickerUpdatePlainImage(),
      requestMethod: RequestMethod.Post,
      jsonData: {
        'sticker_id' : widget.stickerModel.id,
        'star' : 0,
        'status' : StickerStatus.Processing,
        'title' : _titleEditController.text.trim(),
        'background' : '',
        'category_id' : _categoryModel?.id ?? '',
        'tag_id' : _selectedTag.map((e) => e.id).toList(),
        'is_pinned' : false,
        'description' : _descriptionEditController.text,
        'image_path' : imageUrl,
      },
    ).then((response){
      final responseCode = response.data['code'];
      final responseMessage = response.data['msg'];
      if(responseCode == 200){
        ToastManager.show('Sticker create success.');
        Navigator.pop(context);
      } else {
        ToastManager.show(responseMessage);
      }
    }).catchError((error){
      print(error);
      ToastManager.show('Create plain image sticker fail, please try again later.');
    });
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

}
