import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('Console Logger Tests', () {
    // This list will capture the output of debugPrint.
    final List<String> capturedLogs = [];

    // This is the original debugPrint function.
    final originalDebugPrint = debugPrint;

    // Before each test, redirect debugPrint to capture logs.
    setUp(() {
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) {
          capturedLogs.add(message);
        }
      };
    });

    // After each test, restore the original debugPrint and clear the logs.
    tearDown(() {
      debugPrint = originalDebugPrint;
      capturedLogs.clear();
    });

    timedTest('should log messages at or above the "dev" threshold', () {
      // 1. Arrange
      Console(logThreshold: LogLevel.dev);

      // 2. Act
      Console.log('fframe message', level: LogLevel.fframe); // Should not be logged
      Console.log('dev message', level: LogLevel.dev);
      Console.log('prod message', level: LogLevel.prod);

      // 3. Assert
      expect(capturedLogs.length, 2);
      expect(capturedLogs.any((log) => log.contains('dev message')), isTrue);
      expect(capturedLogs.any((log) => log.contains('prod message')), isTrue);
      expect(capturedLogs.any((log) => log.contains('fframe message')), isFalse);
    });

    timedTest('should only log messages at the "prod" threshold', () {
      // 1. Arrange
      Console(logThreshold: LogLevel.prod);

      // 2. Act
      Console.log('fframe message', level: LogLevel.fframe);
      Console.log('dev message', level: LogLevel.dev);
      Console.log('prod message', level: LogLevel.prod);

      // 3. Assert
      expect(capturedLogs.length, 1);
      expect(capturedLogs.first, contains('prod message'));
    });

    timedTest('should log all levels when threshold is "fframe"', () {
      // 1. Arrange
      Console(logThreshold: LogLevel.fframe);

      // 2. Act
      Console.log('fframe message', level: LogLevel.fframe);
      Console.log('dev message', level: LogLevel.dev);
      Console.log('prod message', level: LogLevel.prod);

      // 3. Assert
      expect(capturedLogs.length, 3);
      expect(capturedLogs.any((log) => log.contains('fframe message')), isTrue);
      expect(capturedLogs.any((log) => log.contains('dev message')), isTrue);
      expect(capturedLogs.any((log) => log.contains('prod message')), isTrue);
    });
  });
}
