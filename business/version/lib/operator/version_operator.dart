
import 'dart:convert';
import 'package:version_api/interface/version_interface.dart';
import 'package:version_api/model/version_model.dart';
import 'package:network/network.dart';
import 'package:version_api/const/const_url.dart';
import 'package:version_api/const/const_application.dart';

class VersionOperator extends VersionInterface{

  // Singleton Pattern

  VersionOperator._();

  static VersionOperator? _instance;

  static _getInstance(){
    if(_instance == null){
      _instance = VersionOperator._();
    }
    return _instance!;
  }

  factory VersionOperator() => _getInstance();

  static VersionOperator get instance => _getInstance();

  // Actions

  @override
  Future getLatestVersion({
    void Function(NetworkResponse<VersionModel> response)? onSuccess,
    void Function(NetworkResponse response)? onFail,
  }) {
    NetworkManager.instance.fetch(URL_GET_LATEST,
      urlParams: {
        'applicationID' : CONST_APPLICATION_ID,
      },
      onSuccess: (obj){
        print('Success');
        print(obj.runtimeType);
        print(obj);
        final jsonResponse = JsonDecoder().convert(obj);
        final jsonCode = jsonResponse['code'];
        final jsonMessage = jsonResponse['message'];
        final networkResponse = NetworkResponse<VersionModel>(
          code: jsonCode,
          message: jsonMessage,
        );


        if(jsonCode == 200){
          final jsonData = jsonResponse['data'];

          final dataVersionID = jsonData['versionID'];
          final dataApplicationID = jsonData['applicationID'];
          final dataDescription = jsonData['description'];
          final dataVersionCode = jsonData['versionCode'];
          final dataVersionName = jsonData['versionName'];
          final dataPublishTime = jsonData['publishTime'];
          final dataUrl = jsonData['url'];

          final versionModel = VersionModel(
            versionID: dataVersionID,
            applicationID: dataApplicationID,
            description: dataDescription,
            versionCode: dataVersionCode,
            versionName: dataVersionName,
            publishTime: dataPublishTime,
            url: dataUrl,
          );

          networkResponse.data = versionModel;

          onSuccess?.call(networkResponse);
        } else {
          final networkResponse = NetworkResponse(
            code: jsonCode,
            message: jsonMessage,
          );
          onFail?.call(networkResponse);
        }
      },
      onFail: (obj){
        print('Fail');
        print(obj.runtimeType);
        print(obj);
        onFail?.call(NetworkResponse.networkError());
      },
    );
    return Future.value();
  }

  @override
  Future<NetworkResponse<List<VersionModel>>> getVersionList({
    int page = 0,
    int count = 12,
    void Function(NetworkResponse<List<VersionModel>> response)? onSuccess,
    void Function(NetworkResponse response)? onFail,
  }) {
    NetworkManager.instance.fetch(URL_GET_LIST,
      urlParams: {
        'applicationID' : CONST_APPLICATION_ID,
        'page' : page,
        'count' : count,
      },
      onSuccess: (obj){
        print('Success');
        print(obj.runtimeType);
        print(obj);
        final jsonResponse = JsonDecoder().convert(obj);
        final jsonCode = jsonResponse['code'];
        final jsonMessage = jsonResponse['message'];
        final networkResponse = NetworkResponse<List<VersionModel>>(
          code: jsonCode,
          message: jsonMessage,
        );
        if(jsonCode == 200){
          final versionModelList = <VersionModel>[];
          final jsonData = jsonResponse['data'];
          for(final dataItem in jsonData){
            final versionID = dataItem['versionID'];
            final applicationID = dataItem['applicationID'];
            final description = dataItem['description'];
            final versionCode = dataItem['versionCode'];
            final versionName = dataItem['versionName'];
            final publishTime = dataItem['publishTime'];
            final url = dataItem['url'];

            final versionModel = VersionModel(
              versionID: versionID,
              applicationID: applicationID,
              description: description,
              versionCode: versionCode,
              versionName: versionName,
              publishTime: publishTime,
              url: url,
            );
            versionModelList.add(versionModel);
          }
          networkResponse.data = versionModelList;
          onSuccess?.call(networkResponse);
        } else {
          final networkResponse = NetworkResponse(
            code: jsonCode,
            message: jsonMessage,
          );
          onFail?.call(networkResponse);
        }
      },
      onFail: (obj){
        print('Fail');
        print(obj.runtimeType);
        print(obj);
        onFail?.call(NetworkResponse.networkError());
      },
    );
    return Future.value();
  }

}
