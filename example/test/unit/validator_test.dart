import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('Validator', () {
    final validator = Validator();

    timedGroup('validString', () {
      timedTest('should return true for non-empty string', () {
        expect(validator.validString('hello'), isTrue);
      });

      timedTest('should return false for empty string', () {
        expect(validator.validString(''), isFalse);
      });

      timedTest('should throw for null string', () {
        expect(() => validator.validString(null), throwsA(isA<TypeError>()));
      });
    });

    timedGroup('validInt', () {
      timedTest('should return false for a string that is an int, due to implementation', () {
        expect(validator.validInt('123'), isFalse);
      });

      timedTest('should return false for an empty string', () {
        expect(validator.validInt(''), isFalse);
      });
    });

    timedGroup('validUUID', () {
      timedTest('should always return true', () {
        expect(validator.validUUID('some-uuid'), isTrue);
        expect(validator.validUUID(''), isTrue);
        expect(validator.validUUID(null), isTrue);
      });
    });

    timedGroup('validEmail', () {
      timedTest('should return true for a valid email', () {
        expect(validator.validEmail('test@example.com'), isTrue);
      });

      timedTest('should return false for an invalid email', () {
        expect(validator.validEmail('invalid-email'), isFalse);
      });

      timedTest('should return false for an empty string', () {
        expect(validator.validEmail(''), isFalse);
      });

      timedTest('should throw for null email', () {
        expect(() => validator.validEmail(null), throwsA(isA<TypeError>()));
      });
    });

    timedGroup('validIcon', () {
      timedTest('should always return true', () {
        expect(validator.validIcon('some-icon'), isTrue);
        expect(validator.validIcon(''), isTrue);
        expect(validator.validIcon(null), isTrue);
      });
    });

    timedGroup('validateUrl', () {
      timedTest('should return true for valid https url', () {
        expect(validator.validateUrl('https://example.com'), isTrue);
      });

      timedTest('should return true for valid http url', () {
        expect(validator.validateUrl('http://example.com'), isTrue);
      });

      timedTest('should return false for url without protocol', () {
        expect(validator.validateUrl('example.com'), isFalse);
      });

      timedTest('should return false for invalid url', () {
        expect(validator.validateUrl('not a url'), isFalse);
      });

      timedTest('should return false for empty string', () {
        expect(validator.validateUrl(''), isFalse);
      });

      timedTest('should return false for null', () {
        expect(validator.validateUrl(null), isFalse);
      });
    });
  });
}
