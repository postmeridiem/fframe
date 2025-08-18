import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/helpers/slug.dart';
import 'unit_test_harness.dart';
import '../helpers/test_timing.dart';

void main() {
  // Setup timing collection for unit tests
  setupTiming(TestType.unit);
  
  timedGroup('getSlug characterization tests', () {
    // Set up the test environment before each test
    setUp(() {
      setupUnitTests();
    });

    timedTest('should handle basic strings', () {
      expect(getSlug('Hello World'), 'hello-world');
    });

    timedTest('should handle special characters based on current output', () {
      // This test documents the actual, current behavior.
      expect(getSlug('Hello!@#\$%^&*()_+World'), 'hello!@-%^-plusworld');
    });

    timedTest('should handle leading/trailing whitespace and hyphens based on current output', () {
      // This test documents that leading/trailing hyphens ARE trimmed by the current code.
      expect(getSlug('  -Hello World-  '), 'hello-world');
    });

    timedTest('should convert accented characters based on current output', () {
      // This documents the current, specific transliteration behavior.
      expect(getSlug('àáâãäåçèéêëìíîïñòóôõöøùúûüýÿ'), 'aaaaaeaceeeeiiiinoooooeouuuueyy');
    });
    
    timedTest('should handle mixed case accented characters based on current output', () {
      // Documents the current ß -> ss, Ä -> ae, etc. behavior.
      expect(getSlug('ÄäÖöÜüß'), 'aeaeoeoeueuess');
    });

    timedTest('should collapse multiple spaces and hyphens', () {
      expect(getSlug('Hello   ---   World'), 'hello-world');
    });

    timedTest('should handle an empty string', () {
      expect(getSlug(''), '');
    });

    timedTest('should handle a string with only special characters based on current output', () {
      expect(getSlug('!@#\$%^&*()_+'), '!@-%^-plus');
    });
  });
}
