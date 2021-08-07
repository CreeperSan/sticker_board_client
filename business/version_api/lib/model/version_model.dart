

class VersionModel {
  int versionID;
  int applicationID;
  String description;
  int versionCode;
  String versionName;
  int publishTime;
  String url;

  VersionModel({
    required this.versionID,
    required this.applicationID,
    required this.description,
    required this.versionCode,
    required this.versionName,
    required this.publishTime,
    required this.url,
  });

}
