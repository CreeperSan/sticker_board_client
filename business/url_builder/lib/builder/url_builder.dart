import 'package:kv_storage/kv_storage.dart';
import 'package:url_builder/const/const_kv.dart';

// Host address format should be like this : https://www.domain.com
class URLBuilder {

  URLBuilder._();

  static void setHostAddress(String address){
    KVStorageManager.setString(ConstKV.KV_SERVER_ADDRESS, address);
  }

  static String getHostAddress(){
    return KVStorageManager.getString(ConstKV.KV_SERVER_ADDRESS, '');
  }

  static bool isConfigComplete(){
    return getHostAddress().isNotEmpty;
  }

  /// Account
  static String accountLogin() => '${getHostAddress()}/api/account/v1/login';
  static String accountRegister() => '${getHostAddress()}/api/account/v1/register';
  static String accountAuthToken() => '${getHostAddress()}/api/account/v1/auth_token';

  /// Sticker
  static String stickerCreateCategory() => '${getHostAddress()}/api/category/v1/create';
  static String stickerDeleteCategory() => '${getHostAddress()}/api/category/v1/delete';
  static String stickerListCategory() => '${getHostAddress()}/api/category/v1/list';

  static String stickerCreateTag() => '${getHostAddress()}/api/tag/v1/create';
  static String stickerDeleteTag() => '${getHostAddress()}/api/tag/v1/delete';
  static String stickerListTag() => '${getHostAddress()}/api/tag/v1/list';

  static String stickerCreatePlainText() => '${getHostAddress()}/api/sticker/v1/plain_image/create';
  static String stickerCreatePlainImage() => '${getHostAddress()}/api/sticker/v1/plain_text/create';
  static String stickerDelete() => '${getHostAddress()}/api/sticker/v1/delete';
  static String stickerQuery() => '${getHostAddress()}/api/sticker/v1/query';


  /// OSS
  static String ossGetSignature(String action) => '${getHostAddress()}/api/oss/v1/get_signature?action=$action';

}
