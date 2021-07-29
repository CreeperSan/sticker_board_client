import 'package:flutter_test/flutter_test.dart';

import 'package:log/log.dart';

void main() {
  test('adds one to input values', () async {
    print('----- start log -----');
    try {
      await LogManager.initialize();
      print('----- start log -----');
      print('Level Debug:');
      LogManager.d('Debug Level Log', 'tag');
      print('Level Info:');
      LogManager.i('Info Level Log', 'tag');
      print('Level Warming:');
      LogManager.w('Warming Level Log', 'tag');
      print('Level Error:');
      LogManager.e('Error Level Log', 'tag');
    } catch (e) {
      print('----- start log -----');
      print(e);
    }
  });
}
