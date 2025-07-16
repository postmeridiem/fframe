import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/extensions/string.dart';

void main() {
  group('StringExtension', () {
    test('removeLeadingSlash should remove the leading slash from a string', () {
      expect('/test'.removeLeadingSlash(), 'test');
    });

    test('removeLeadingSlash should not change a string without a leading slash', () {
      expect('test'.removeLeadingSlash(), 'test');
    });

    test('removeLeadingSlash should handle an empty string', () {
      expect(''.removeLeadingSlash(), '');
    });

    test('removeLeadingSlash should handle a null string', () {
      String? testString;
      expect(testString.removeLeadingSlash(), null);
    });

    test('removeLeadingSlash should handle a string that is only a slash', () {
      expect('/'.removeLeadingSlash(), '');
    });
  });
}
