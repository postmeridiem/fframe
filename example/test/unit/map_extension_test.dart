import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/extensions/map.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('MapExtensions', () {
    final Map<String, int> testMap = {
      'one': 1,
      'two': 2,
      'three': 3,
    };

    timedTest('firstWhereOrNull should return the value when the condition is met', () {
      final result = testMap.firstWhereOrNull((key, value) => value == 2);
      expect(result, 2);
    });

    timedTest('firstWhereOrNull should return the first value when multiple conditions are met', () {
      final result = testMap.firstWhereOrNull((key, value) => value > 1);
      expect(result, 2);
    });

    timedTest('firstWhereOrNull should return null when the condition is not met', () {
      final result = testMap.firstWhereOrNull((key, value) => value == 4);
      expect(result, null);
    });

    timedTest('firstWhereOrNull should return null for an empty map', () {
      final Map<String, int> emptyMap = {};
      final result = emptyMap.firstWhereOrNull((key, value) => value == 1);
      expect(result, null);
    });

    timedTest('firstWhereOrNull should work with different key and value types', () {
      final Map<int, String> mixedMap = {
        1: 'one',
        2: 'two',
      };
      final result = mixedMap.firstWhereOrNull((key, value) => key == 2);
      expect(result, 'two');
    });
  });
}
