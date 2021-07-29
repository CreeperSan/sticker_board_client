import 'package:flutter_test/flutter_test.dart';

import 'package:kv_storage/kv_storage.dart';
import 'package:kv_storage/manager/kv_storage_manager.dart';

void main() {
  test('adds one to input values', () {
    KVStorageManager.initialize().then((isInitializeSuccess){
      if(!isInitializeSuccess){
        expect(true, false, reason: 'KVStorage Initialize error');
      } else {
        final keyString = '_test_kv_storage_type_string';
        final valueString = 'string';
        final keyInt = '_test_kv_storage_type_string';
        final valueInt = 65536;
        final keyBool = '_test_kv_storage_type_string';
        final valueBool = true;
        final keyDouble = '_test_kv_storage_type_string';
        final valueDouble = 3.1415926;

        KVStorageManager.setString(keyString, valueString);
        KVStorageManager.setDouble(keyDouble, valueDouble);
        KVStorageManager.setInt(keyInt, valueInt);
        KVStorageManager.setBool(keyBool, valueBool);

        expect(KVStorageManager.getString(keyString, ''), valueString);
        expect(KVStorageManager.getInt(keyString, 0), valueInt);
        expect(KVStorageManager.getBool(keyBool, false), valueBool);
        expect(KVStorageManager.getDouble(keyString, 0.0), valueDouble);
      }
    }).then((value){
      expect(true, false, reason: 'KVStorage Initialize error');
    });

  });
}
