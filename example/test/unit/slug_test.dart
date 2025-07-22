import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/helpers/slug.dart';
import '../unit_test_harness.dart';

void main() {
  group('getSlug characterization tests', () {
    // Set up the test environment before each test
    setUp(() {
      setupUnitTests();
    });

    test('should handle basic strings', () {
      expect(getSlug('Hello World'), 'hello-world');
    });

    test('should handle special characters based on current output', () {
      // This test documents the actual, current behavior.
      expect(getSlug('Hello!@#\$%^&*()_+World'), 'hello!@-%^-plusworld');
    });

    test('should handle leading/trailing whitespace and hyphens based on current output', () {
      // This test documents that leading/trailing hyphens ARE trimmed by the current code.
      expect(getSlug('  -Hello World-  '), 'hello-world');
    });

    test('should convert accented characters based on current output', () {
      // This documents the current, specific transliteration behavior.
      expect(getSlug('àáâãäåçèéêëìíîïñòóôõöøùúûüýÿ'), 'aaaaaeaceeeeiiiinoooooeouuuueyy');
    });
    
    test('should handle mixed case accented characters based on current output', () {
      // Documents the current ß -> ss, Ä -> ae, etc. behavior.
      expect(getSlug('ÄäÖöÜüß'), 'aeaeoeoeueuess');
    });

    test('should collapse multiple spaces and hyphens', () {
      expect(getSlug('Hello   ---   World'), 'hello-world');
    });

    test('should handle an empty string', () {
      expect(getSlug(''), '');
    });

    test('should handle a string with only special characters based on current output', () {
      expect(getSlug('!@#\$%^&*()_+'), '!@-%^-plus');
    });
  });
}
