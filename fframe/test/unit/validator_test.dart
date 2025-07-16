import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe.dart';

void main() {
  group('Validator', () {
    final validator = Validator();

    group('validString', () {
      test('should return true for non-empty string', () {
        expect(validator.validString('hello'), isTrue);
      });

      test('should return false for empty string', () {
        expect(validator.validString(''), isFalse);
      });

      test('should throw for null string', () {
        expect(() => validator.validString(null), throwsA(isA<TypeError>()));
      });
    });

    group('validInt', () {
      test('should return false for a string that is an int, due to implementation', () {
        expect(validator.validInt('123'), isFalse);
      });

      test('should return false for an empty string', () {
        expect(validator.validInt(''), isFalse);
      });
    });

    group('validUUID', () {
      test('should always return true', () {
        expect(validator.validUUID('some-uuid'), isTrue);
        expect(validator.validUUID(''), isTrue);
        expect(validator.validUUID(null), isTrue);
      });
    });

    group('validEmail', () {
      test('should return true for a valid email', () {
        expect(validator.validEmail('test@example.com'), isTrue);
      });

      test('should return false for an invalid email', () {
        expect(validator.validEmail('invalid-email'), isFalse);
      });

      test('should return false for an empty string', () {
        expect(validator.validEmail(''), isFalse);
      });

      test('should throw for null email', () {
        expect(() => validator.validEmail(null), throwsA(isA<TypeError>()));
      });
    });

    group('validIcon', () {
      test('should always return true', () {
        expect(validator.validIcon('some-icon'), isTrue);
        expect(validator.validIcon(''), isTrue);
        expect(validator.validIcon(null), isTrue);
      });
    });

    group('validateUrl', () {
      test('should return true for valid https url', () {
        expect(validator.validateUrl('https://example.com'), isTrue);
      });

      test('should return true for valid http url', () {
        expect(validator.validateUrl('http://example.com'), isTrue);
      });

      test('should return false for url without protocol', () {
        expect(validator.validateUrl('example.com'), isFalse);
      });

      test('should return false for invalid url', () {
        expect(validator.validateUrl('not a url'), isFalse);
      });

      test('should return false for empty string', () {
        expect(validator.validateUrl(''), isFalse);
      });

      test('should return false for null', () {
        expect(validator.validateUrl(null), isFalse);
      });
    });
  });
}
