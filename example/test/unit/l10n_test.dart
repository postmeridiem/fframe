import 'package:flutter_test/flutter_test.dart';
import 'unit_test_harness.dart';
import 'package:fframe/helpers/l10n.dart';

void main() {
  group('L10n Unit Tests', () {
    // Set up the test environment before each test
    setUp(() {
      setupUnitTests();
    });

    test('should return translation when key and namespace exist', () {
      expect(L10n.string('greeting', placeholder: 'Default'), 'Hello, World!');
    });

    test('should return translation from a specific namespace', () {
      expect(L10n.string('profile_title', placeholder: 'Default', namespace: 'user'), 'User Profile');
    });

    test('should return placeholder when key does not exist', () {
      expect(L10n.string('unknown_key', placeholder: 'Placeholder'), 'Placeholder');
    });

    test('should return placeholder when namespace does not exist', () {
      // This will also log an error via the initialized Console.
      expect(L10n.string('any_key', placeholder: 'Placeholder', namespace: 'unknown_namespace'), 'Placeholder');
    });

    test('interpolated should replace placeholders correctly', () {
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