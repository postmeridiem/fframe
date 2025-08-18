import 'package:flutter_test/flutter_test.dart';
import 'unit_test_harness.dart';
import '../helpers/test_timing.dart';
import 'package:fframe/helpers/l10n.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('L10n Unit Tests', () {
    // Set up the test environment before each test
    setUp(() {
      setupUnitTests();
    });

    timedTest('should return translation when key and namespace exist', () {
      expect(L10n.string('greeting', placeholder: 'Default'), 'Hello, World!');
    });

    timedTest('should return translation from a specific namespace', () {
      expect(L10n.string('profile_title', placeholder: 'Default', namespace: 'user'), 'User Profile');
    });

    timedTest('should return placeholder when key does not exist', () {
      expect(L10n.string('unknown_key', placeholder: 'Placeholder'), 'Placeholder');
    });

    timedTest('should return placeholder when namespace does not exist', () {
      // This will also log an error via the initialized Console.
      expect(L10n.string('any_key', placeholder: 'Placeholder', namespace: 'unknown_namespace'), 'Placeholder');
    });

    timedTest('interpolated should replace placeholders correctly', () {
      final result = L10n.interpolated(
        'greeting', // "Hello, World!"
        placeholder: 'Default',
        replacers: [
          L10nReplacer(from: 'World', replace: 'Flutter'),
        ],
      );
      expect(result, 'Hello, Flutter!');
    });
  });
}