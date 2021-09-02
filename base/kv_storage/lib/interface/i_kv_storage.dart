
abstract class IKVStorage {

  Future<bool> initialize();



  String getString(String key, [String defaultValue = '']);

  int getInt(String key, [int defaultValue = 0]);

  bool getBool(String key, [bool defaultValue = false]);

  double getDouble(String key, [double defaultValue = 0.0]);



  void setString(String key, String value);

  void setInt(String key, int value);

  void setBool(String key, bool value);

  void setDouble(String key, double value);


  void remove(String key);

}
