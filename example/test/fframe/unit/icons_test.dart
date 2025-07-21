import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/helpers/icons.dart';

void main() {
  group('Icons', () {
    test('iconMap should not be empty', () {
      expect(iconMap, isNotEmpty);
    });

    test('iconMap should contain a known icon', () {
      expect(iconMap.containsKey('add'), isTrue);
      expect(iconMap['add'], isNotNull);
    });
  });
}
