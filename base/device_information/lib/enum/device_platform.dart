
enum DevicePlatform{
  Unsupported,

  Android,
  iOS,
  Browser,
  Windows,
  MacOS,
  Linux,
}

const DevicePlatformUnsupported = 0;
const DevicePlatformAndroid = 1;
const DevicePlatformIOS = 2;
const DevicePlatformBrowser = 3;
const DevicePlatformWindows = 4;
const DevicePlatformMacOS = 5;
const DevicePlatformLinux = 6;

int convertDevicePlatformToInt(DevicePlatform platform){
  return {
    DevicePlatform.Unsupported : DevicePlatformUnsupported,
    DevicePlatform.Android : DevicePlatformAndroid,
    DevicePlatform.iOS : DevicePlatformIOS,
    DevicePlatform.Browser : DevicePlatformBrowser,
    DevicePlatform.Windows : DevicePlatformWindows,
    DevicePlatform.MacOS : DevicePlatformMacOS,
    DevicePlatform.Linux : DevicePlatformLinux,
  } [platform] ?? DevicePlatformUnsupported;
}

DevicePlatform convertIntToDevicePlatfrom(int platform){
  return {
    DevicePlatformUnsupported : DevicePlatform.Unsupported,
    DevicePlatformAndroid : DevicePlatform.Android,
    DevicePlatformIOS : DevicePlatform.iOS,
    DevicePlatformBrowser : DevicePlatform.Browser,
    DevicePlatformWindows : DevicePlatform.Windows,
    DevicePlatformMacOS : DevicePlatform.MacOS,
    DevicePlatformLinux : DevicePlatform.Linux,
  } [platform] ?? DevicePlatform.Unsupported;
}

