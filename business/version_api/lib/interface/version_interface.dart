
import 'package:version_api/model/version_model.dart';
import 'package:network/network.dart';

abstract class VersionInterface {

  Future getLatestVersion({
    void Function(NetworkResponse<VersionModel> response)? onSuccess,
    void Function(NetworkResponse response)? onFail,
  });

  Future<NetworkResponse<List<VersionModel>>> getVersionList({
    int page = 0,
    int count = 12,
    void Function(NetworkResponse<List<VersionModel>> response)? onSuccess,
    void Function(NetworkResponse response)? onFail,
  });

}
