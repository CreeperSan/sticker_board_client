import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CreatePlainImageStickerPage extends StatelessWidget {
  final TextEditingController _titleEditController = TextEditingController();
  final TextEditingController _descriptionEditController = TextEditingController();

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
              subtitle: Text('Not selected yet'),
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
    ));
  }

  void _onCreateSticker(BuildContext context){
    getDownloadsDirectory().then((value){
      // print(value.path);
      print(value?.path);
    });
  }

}
