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

  group('toCapitalized', () {
    test('should capitalize the first letter of a string', () {
      expect('hello'.toCapitalized(), 'Hello');
    });

    test('should not change a string that is already capitalized', () {
      expect('Hello'.toCapitalized(), 'Hello');
    });

    test('should handle an empty string', () {
      expect(''.toCapitalized(), '');
    });

    test('should handle a single character string', () {
      expect('a'.toCapitalized(), 'A');
    });

    test('should handle a null string', () {
      String? testString;
      expect(testString.toCapitalized(), null);
    });
  });

  group('toTitleCase', () {
    test('should capitalize the first letter of each word in a string', () {
      expect('hello world'.toTitleCase(), 'Hello World');
    });

    test('should not change a string that is already in title case', () {
      expect('Hello World'.toTitleCase(), 'Hello World');
    });

    test('should handle an empty string', () {
      expect(''.toTitleCase(), '');
    });

    test('should handle a single word string', () {
      expect('hello'.toTitleCase(), 'Hello');
    });

    test('should handle a null string', () {
      String? testString;
      expect(testString.toTitleCase(), null);
    });

    test('should handle multiple spaces between words', () {
      expect('hello   world'.toTitleCase(), 'Hello   World');
    });
  });
}
