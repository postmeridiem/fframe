import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/helpers/icons.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('Icons', () {
    timedTest('iconMap should not be empty', () {
      expect(iconMap, isNotEmpty);
    });

    timedTest('iconMap should contain a known icon', () {
      expect(iconMap.containsKey('add'), isTrue);
      expect(iconMap['add'], isNotNull);
    });
  });
}
