
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:formatter/formatter.dart';
import 'package:log/log.dart';
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

}

