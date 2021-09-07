
import 'package:file_selector/const/picker_action.dart';
import 'package:file_selector/model/file_model.dart';

class PickerResponse {
  PickerAction pickerAction;
  List<FileModel> fileList;

  PickerResponse({
    required this.pickerAction,
    this.fileList = const [],
  });

}