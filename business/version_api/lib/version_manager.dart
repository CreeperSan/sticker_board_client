
import 'package:version_api/interface/version_interface.dart';

class VersionManager {

  VersionManager._();

  static VersionInterface? instance;

  static void install(VersionInterface manager){
    instance = manager;
  }

  static void uninstall(){
    instance = null;
  }

}
