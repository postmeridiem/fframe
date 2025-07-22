import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/helpers/strings.dart';

void main() {
  group('String Helper Unit Tests', () {
    // Test data
    final DateTime testDateTime = DateTime(2023, 10, 26, 14, 30, 15);
    final Timestamp testTimestamp = Timestamp.fromDate(testDateTime);

    test('dateTimeFromTimestamp should convert Timestamp to DateTime correctly', () {
      final result = dateTimeFromTimestamp(testTimestamp);
      expect(result, testDateTime);
    });

    test('dateTimeTextDT should format DateTime correctly', () {
      final result = dateTimeTextDT(testDateTime);
      expect(result, '2023-10-26  14:30');
    });

    test('dateTextDT should format DateTime correctly', () {
      final result = dateTextDT(testDateTime);
      expect(result, '2023-10-26');
    });

    test('timeTextDT should format DateTime correctly', () {
      final result = timeTextDT(testDateTime);
      expect(result, '14:30:15');
    });

    test('dateTimeTextTS should format Timestamp correctly', () {
      final result = dateTimeTextTS(testTimestamp);
      expect(result, '2023-10-26  14:30');
    });

    test('dateTextTS should format Timestamp correctly', () {
      final result = dateTextTS(testTimestamp);
      expect(result, '2023-10-26');
    });

    test('timeTextTS should format Timestamp correctly', () {
      final result = timeTextTS(testTimestamp);
      expect(result, '14:30:15');
    });
  });
}
