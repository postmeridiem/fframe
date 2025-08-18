import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/helpers/strings.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('String Helper Unit Tests', () {
    // Test data
    final DateTime testDateTime = DateTime(2023, 10, 26, 14, 30, 15);
    final Timestamp testTimestamp = Timestamp.fromDate(testDateTime);

    timedTest('dateTimeFromTimestamp should convert Timestamp to DateTime correctly', () {
      final result = dateTimeFromTimestamp(testTimestamp);
      expect(result, testDateTime);
    });

    timedTest('dateTimeTextDT should format DateTime correctly', () {
      final result = dateTimeTextDT(testDateTime);
      expect(result, '2023-10-26  14:30');
    });

    timedTest('dateTextDT should format DateTime correctly', () {
      final result = dateTextDT(testDateTime);
      expect(result, '2023-10-26');
    });

    timedTest('timeTextDT should format DateTime correctly', () {
      final result = timeTextDT(testDateTime);
      expect(result, '14:30:15');
    });

    timedTest('dateTimeTextTS should format Timestamp correctly', () {
      final result = dateTimeTextTS(testTimestamp);
      expect(result, '2023-10-26  14:30');
    });

    timedTest('dateTextTS should format Timestamp correctly', () {
      final result = dateTextTS(testTimestamp);
      expect(result, '2023-10-26');
    });

    timedTest('timeTextTS should format Timestamp correctly', () {
      final result = timeTextTS(testTimestamp);
      expect(result, '14:30:15');
    });
  });
}
