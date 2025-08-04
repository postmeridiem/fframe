import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/constants/constants.dart';

import 'unit_test_harness.dart';

void main() {
  group('Constants', () {
    setUp(() {
      setupUnitTests();
    });

    group('allClaims', () {
      test('should contain user-related claims', () {
        expect(allClaims.containsKey('userViewer'), isTrue);
        expect(allClaims.containsKey('userEditor'), isTrue);
        expect(allClaims['userViewer'], equals('Allow viewing of all registered users'));
        expect(allClaims['userEditor'], equals('Allow editing of all registered users'));
      });

      test('should contain client-related claims', () {
        expect(allClaims.containsKey('clientViewer'), isTrue);
        expect(allClaims.containsKey('clientEditor'), isTrue);
        expect(allClaims.containsKey('clientCreator'), isTrue);
        expect(allClaims['clientViewer'], equals('Allow viewing of all registered client'));
        expect(allClaims['clientEditor'], equals('Allow editing of all registered client'));
        expect(allClaims['clientCreator'], equals('Allow creating of a registered client'));
      });

      test('should contain runConfig-related claims', () {
        expect(allClaims.containsKey('runConfigViewer'), isTrue);
        expect(allClaims.containsKey('runConfigEditor'), isTrue);
        expect(allClaims.containsKey('runConfigCreator'), isTrue);
        expect(allClaims['runConfigViewer'], equals('Allow viewing of all registered runConfigs'));
        expect(allClaims['runConfigEditor'], equals('Allow Editing of all registered runConfigs'));
        expect(allClaims['runConfigCreator'], equals('Allow creating of a registered runConfig'));
      });

      test('should contain run-related claims', () {
        expect(allClaims.containsKey('runViewer'), isTrue);
        expect(allClaims.containsKey('runEditor'), isTrue);
        expect(allClaims.containsKey('runCreator'), isTrue);
        expect(allClaims['runViewer'], equals('Allow viewing of all registered run'));
        expect(allClaims['runEditor'], equals('Allow Editing of all registered run'));
        expect(allClaims['runCreator'], equals('Allow creating of a registered run'));
      });

      test('should not contain commented out userCreator claim', () {
        expect(allClaims.containsKey('userCreator'), isFalse);
      });

      test('should have correct total number of claims', () {
        expect(allClaims.length, equals(11)); // Total claims excluding commented one
      });
    });

    group('ScreenSize enum', () {
      test('should contain all expected values', () {
        expect(ScreenSize.values, contains(ScreenSize.phone));
        expect(ScreenSize.values, contains(ScreenSize.tablet));
        expect(ScreenSize.values, contains(ScreenSize.large));
        expect(ScreenSize.values, contains(ScreenSize.unknown));
      });

      test('should have correct number of values', () {
        expect(ScreenSize.values.length, equals(4));
      });

      test('should allow comparison and equality', () {
        expect(ScreenSize.phone == ScreenSize.phone, isTrue);
        expect(ScreenSize.phone == ScreenSize.tablet, isFalse);
        expect(ScreenSize.tablet != ScreenSize.large, isTrue);
      });
    });

    group('lanePositionIncrement', () {
      test('should have correct value', () {
        expect(lanePositionIncrement, equals(1000.0));
      });

      test('should be a double', () {
        expect(lanePositionIncrement, isA<double>());
      });

      test('should be positive', () {
        expect(lanePositionIncrement, greaterThan(0));
      });

      test('should provide reasonable spacing for reordering', () {
        // Test the concept behind the value - providing space for reordering
        expect(lanePositionIncrement, greaterThan(100)); // Should be large enough
        expect(lanePositionIncrement % 100, equals(0)); // Should be a round number
      });
    });
  });
}