import 'package:account_api/account_api.dart';
import 'package:application_config/application_config.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:kv_storage/manager/kv_storage_manager.dart';
import 'package:log/log.dart';
import 'package:network/manager/network_manager.dart';
import 'package:sticker_board_client/const/application_const.dart';
import 'package:account/account.dart';
import 'package:sticker_board_client/const/router_const.dart';
import 'package:sticker_board_client/manager/prefs_manager.dart';
import 'package:toast/manager/toast_manager.dart';
import 'package:url_builder/url_builder.dart';
import 'package:version/version.dart';
import 'package:splash_screen/splash_screen.dart';
import 'package:sticker_board/sticker_board.dart' as StickerBoard;
import 'package:lifecycle/lifecycle.dart';
import 'package:account_api/account_api.dart';
import 'package:sticker_board/operator/category_operator.dart';
import 'package:sticker_board/operator/sticker_board_operator.dart';
import 'package:sticker_board/operator/tag_operator.dart';
import 'package:version/operator/version_operator.dart';
import 'package:version_api/version_api.dart';
import 'package:sticker_board_api/sticker_board_api.dart';
import 'package:account/account.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n/i18n.dart';

class StickerBoardApplication extends StatelessWidget {

  static const TAG = 'StickerBoardApplication';

  StickerBoardApplication(){

    _init();

  }

  void _init() async {
    // https://stackoverflow.com/questions/67808814/flutter-shared-preference-unhandled-exception-null-check-operator-used-on-a
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Basic Module
    await KVStorageManager.initialize();

    // Initialize Network
    NetworkManager.instance.setCommonHeader({
      'sticker-board-token' : PrefsManager.instance.token,
      'sticker-board-brand' : DeviceInformation.brand,
      'sticker-board-device-name' : DeviceInformation.deviceName,
      'sticker-board-machine-code' : DeviceInformation.machineCode,
      'sticker-board-platform' : DeviceInformation.platform,
      'sticker-board-uid' : PrefsManager.instance.uid,
      'sticker-board-version-code' : ApplicationConst.ApplicationVersionCode,
    });

    // Initialize i18n
    i18n.registerLocalization(languageEnglishAmerica);
    i18n.registerLocalization(languageSimplifyChinese);
    final applicationLanguage = config.getApplicationLanguage();
    if(applicationLanguage == languageAutoDetect){
      // TODO: detective system language
      i18n.setCurrentLocalization(languageEnglishAmerica);
    }else{
      i18n.setCurrentLocalization(applicationLanguage);
    }

    // Initialize Prefs
    PrefsManager.instance.prevVersion = ApplicationConst.ApplicationVersionCode;

    // Initialize Modules
    AccountManager.install(AccountOperator.instance);
    VersionManager.install(VersionOperator.instance);
    TagManager.install(TagOperator.instance);
    CategoryManager.install(CategoryOperator.instance);
    StickerBoardManager.install(StickerBoardOperator.instance);

    // KVStorageManager.remove('app_current_uid');
    // KVStorageManager.remove('app_current_token');
    URLBuilder.setHostAddress('http://localhost:8080');

  }

  @override
  Widget build(BuildContext context) {
    print(DeviceInformation.platform);

    return MaterialApp(
      title: ApplicationConst.ApplicationName,
      initialRoute: RouterConst.SplashScreen,
      localeResolutionCallback: (locale, supported){
        print('localeResolutionCallback($locale, $supported)');
      },
      localeListResolutionCallback: (locales, supportedLocales){
        print('localeListResolutionCallback($locales, $supportedLocales)');
      },
      routes: {
        // Splash Screen
        RouterConst.SplashScreen : (context, [params]) => SplashScreenPage(
          onInitialize: _onSplashScreenPageInitialize,
          onInitializeFinish: (response) => _onSplashScreenPageInitializeFinish(context, response),
        ),

        // Version
        RouterConst.VersionHistory : (context, [params]) => VersionHistoryPage(),

        // Login
        RouterConst.AccountLogin : (context, [params]) => LoginPage(
          onLoginSuccess: (model) => _onLoginSuccess(context, model),
          onAuthSuccess: () => _onLoginAuthSuccess(context),
          onTokenExpired: () => _onLoginTokenExpired(context),
          cachedToken: PrefsManager.instance.token,
          cachedUID: PrefsManager.instance.uid,
          autoLogin: params?['auto_login'] ?? true,
        ),
        RouterConst.AccountRegister : (context, [params]) => RegisterPage(),

        // Sticker Board
        RouterConst.StickerBoardIndex : (context, [params]) => StickerBoard.IndexPage(),
        RouterConst.StickerBoardCategoryAdd : (context, [params]) => StickerBoard.CategoryAddPage(),
        RouterConst.StickerBoardTagAdd : (context, [params]) => StickerBoard.TagAddPage(),
      },
    );
  }

  /// Splash Screen

  /// Initialize
  Future<dynamic> _onSplashScreenPageInitialize() async {
    await Future.delayed(Duration(seconds: 1));
    return 0;
  }

  /// Finish Initialize
  void _onSplashScreenPageInitializeFinish(BuildContext context, dynamic initResponse){
    Navigator.pushReplacementNamed(context, RouterConst.AccountLogin,
      arguments: {
        'auto_login' : true,
      },
    );
  }

  /// Login

  /// Login Success
  void _onLoginSuccess(BuildContext context, LoginSuccessModel loginSuccessModel){
    ToastManager.show('Login Success, Token = ${loginSuccessModel.token}');

    PrefsManager.instance.uid = loginSuccessModel.uid;
    PrefsManager.instance.token = loginSuccessModel.token;

    LogManager.i('Update Application UID=${PrefsManager.instance.uid} Token=${PrefsManager.instance.token}', TAG);

    NetworkManager.instance.setCommonHeader({
      'sticker-board-token' : PrefsManager.instance.token,
      'sticker-board-brand' : DeviceInformation.brand,
      'sticker-board-device-name' : DeviceInformation.deviceName,
      'sticker-board-machine-code' : DeviceInformation.machineCode,
      'sticker-board-platform' : DeviceInformation.platform,
      'sticker-board-uid' : PrefsManager.instance.uid,
      'sticker-board-version-code' : ApplicationConst.ApplicationVersionCode,
    });

    Navigator.pushReplacementNamed(context, RouterConst.StickerBoardIndex);

    LifecycleNotifier.instance.fire(Lifecycle.OnLogin);
  }

  void _onLoginAuthSuccess(BuildContext context){
    LogManager.i('Account token auth success.', TAG);
    Navigator.pushReplacementNamed(context, RouterConst.StickerBoardIndex);
  }

  void _onLoginTokenExpired(BuildContext context){
    PrefsManager.instance.uid = '';
    PrefsManager.instance.token = '';
  }

}


