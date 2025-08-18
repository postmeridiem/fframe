import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/extensions/string.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('StringExtension', () {
    timedTest('removeLeadingSlash should remove the leading slash from a string', () {
      expect('/test'.removeLeadingSlash(), 'test');
    });

    timedTest('removeLeadingSlash should not change a string without a leading slash', () {
      expect('test'.removeLeadingSlash(), 'test');
    });

    timedTest('removeLeadingSlash should handle an empty string', () {
      expect(''.removeLeadingSlash(), '');
    });

    timedTest('removeLeadingSlash should handle a null string', () {
      String? testString;
      expect(testString.removeLeadingSlash(), null);
    });

    timedTest('removeLeadingSlash should handle a string that is only a slash', () {
      expect('/'.removeLeadingSlash(), '');
    });
  });

  timedGroup('toCapitalized', () {
    timedTest('should capitalize the first letter of a string', () {
      expect('hello'.toCapitalized(), 'Hello');
    });

    timedTest('should not change a string that is already capitalized', () {
      expect('Hello'.toCapitalized(), 'Hello');
    });

    timedTest('should handle an empty string', () {
      expect(''.toCapitalized(), '');
    });

    timedTest('should handle a single character string', () {
      expect('a'.toCapitalized(), 'A');
    });

    timedTest('should handle a null string', () {
      String? testString;
      expect(testString.toCapitalized(), null);
    });
  });

  timedGroup('toTitleCase', () {
    timedTest('should capitalize the first letter of each word in a string', () {
      expect('hello world'.toTitleCase(), 'Hello World');
    });

    timedTest('should not change a string that is already in title case', () {
      expect('Hello World'.toTitleCase(), 'Hello World');
    });

    timedTest('should handle an empty string', () {
      expect(''.toTitleCase(), '');
    });

    timedTest('should handle a single word string', () {
      expect('hello'.toTitleCase(), 'Hello');
    });

    timedTest('should handle a null string', () {
      String? testString;
      expect(testString.toTitleCase(), null);
    });

    timedTest('should handle multiple spaces between words', () {
      expect('hello   world'.toTitleCase(), 'Hello   World');
    });
  });
}
