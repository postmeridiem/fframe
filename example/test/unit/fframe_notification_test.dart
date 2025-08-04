import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe.dart';

import 'unit_test_harness.dart';

void main() {
  group('FframeNotification', () {
    setUp(() {
      setupUnitTests();
    });

    group('Constructor', () {
      test('should create notification with required parameters only', () {
        final notification = FframeNotification(
          reporter: 'test-reporter',
          messageTitle: 'Test Title',
        );

        expect(notification.reporter, equals('test-reporter'));
        expect(notification.messageTitle, equals('Test Title'));
        expect(notification.id, isNull);
        expect(notification.notificationTime, isNull);
        expect(notification.type, equals('notification')); // Default value
        expect(notification.messageSubtitle, isNull);
        expect(notification.messageBody, isNull);
        expect(notification.contextLinks, isNull);
        expect(notification.seen, isFalse); // Default value
        expect(notification.read, isFalse); // Default value
        expect(notification.deleted, isFalse); // Default value
        expect(notification.firestoreTTL, isNull);
        expect(notification, isA<ChangeNotifier>());
      });

      test('should create notification with all parameters', () {
        final notificationTime = Timestamp.now();
        final ttl = Timestamp.fromDate(DateTime.now().add(const Duration(days: 7)));
        final contextLinks = <Map<String, dynamic>>[
          {'url': 'https://example.com', 'title': 'Example'},
          {'url': 'https://test.com', 'title': 'Test'}
        ];

        final notification = FframeNotification(
          id: 'test-id',
          notificationTime: notificationTime,
          reporter: 'admin-user',
          messageTitle: 'Important Update',
          type: 'alert',
          messageSubtitle: 'System Maintenance',
          messageBody: 'The system will be down for maintenance tonight.',
          contextLinks: contextLinks,
          seen: true,
          read: true,
          deleted: false,
          firestoreTTL: ttl,
        );

        expect(notification.id, equals('test-id'));
        expect(notification.notificationTime, equals(notificationTime));
        expect(notification.reporter, equals('admin-user'));
        expect(notification.messageTitle, equals('Important Update'));
        expect(notification.type, equals('alert'));
        expect(notification.messageSubtitle, equals('System Maintenance'));
        expect(notification.messageBody, equals('The system will be down for maintenance tonight.'));
        expect(notification.contextLinks, equals(contextLinks));
        expect(notification.seen, isTrue);
        expect(notification.read, isTrue);
        expect(notification.deleted, isFalse);
        expect(notification.firestoreTTL, equals(ttl));
      });

      test('should have immutable properties', () {
        final notification = FframeNotification(
          reporter: 'test-reporter',
          messageTitle: 'Test Title',
          type: 'warning',
        );

        // All properties should be final and unchangeable
        expect(notification.reporter, equals('test-reporter'));
        expect(notification.messageTitle, equals('Test Title'));
        expect(notification.type, equals('warning'));
      });

      test('should be a ChangeNotifier', () {
        final notification = FframeNotification(
          reporter: 'test-reporter',
          messageTitle: 'Test Title',
        );

        expect(notification, isA<ChangeNotifier>());
      });
    });

    group('toJson Method', () {
      test('should convert notification to JSON with all fields', () {
        final notificationTime = Timestamp.fromDate(DateTime(2024, 1, 15, 10, 30));
        final ttl = Timestamp.fromDate(DateTime(2024, 2, 15, 10, 30));
        final contextLinks = <Map<String, dynamic>>[
          {'url': 'https://example.com', 'title': 'Example'}
        ];

        final notification = FframeNotification(
          notificationTime: notificationTime,
          reporter: 'system',
          messageTitle: 'Test Notification',
          type: 'info',
          messageSubtitle: 'Subtitle',
          messageBody: 'Body content',
          contextLinks: contextLinks,
          seen: true,
          read: false,
          deleted: false,
          firestoreTTL: ttl,
        );

        final json = notification.toJson();

        expect(json['notificationTime'], equals(notificationTime));
        expect(json['reporter'], equals('system'));
        expect(json['type'], equals('info'));
        expect(json['messageTitle'], equals('Test Notification'));
        expect(json['messageSubtitle'], equals('Subtitle'));
        expect(json['messageBody'], equals('Body content'));
        expect(json['contextLinks'], equals(contextLinks));
        expect(json['seen'], isTrue);
        expect(json['read'], isFalse);
        expect(json['deleted'], isFalse);
        expect(json['firestoreTTL'], equals(ttl));
      });

      test('should handle null notificationTime by setting current timestamp', () {
        final beforeCall = Timestamp.now();
        
        final notification = FframeNotification(
          reporter: 'test-reporter',
          messageTitle: 'Test Title',
          // notificationTime is null
        );

        final json = notification.toJson();
        final afterCall = Timestamp.now();

        expect(json['notificationTime'], isA<Timestamp>());
        final timestamp = json['notificationTime'] as Timestamp;
        expect(timestamp.seconds, greaterThanOrEqualTo(beforeCall.seconds));
        expect(timestamp.seconds, lessThanOrEqualTo(afterCall.seconds));
      });

      test('should handle null firestoreTTL by setting 30-day expiry', () {
        final beforeCall = DateTime.now();
        
        final notification = FframeNotification(
          reporter: 'test-reporter',
          messageTitle: 'Test Title',
          // firestoreTTL is null
        );

        final json = notification.toJson();
        final afterCall = DateTime.now();

        expect(json['firestoreTTL'], isA<Timestamp>());
        final ttlTimestamp = json['firestoreTTL'] as Timestamp;
        final ttlDate = ttlTimestamp.toDate();
        
        // Should be approximately 30 days from now
        final expectedTTL = beforeCall.add(const Duration(days: 30));
        final maxExpectedTTL = afterCall.add(const Duration(days: 30));
        
        expect(ttlDate.isAfter(expectedTTL.subtract(const Duration(seconds: 1))), isTrue);
        expect(ttlDate.isBefore(maxExpectedTTL.add(const Duration(seconds: 1))), isTrue);
      });

      test('should include null values in JSON', () {
        final notification = FframeNotification(
          reporter: 'test-reporter',
          messageTitle: 'Test Title',
          messageSubtitle: null,
          messageBody: null,
          contextLinks: null,
        );

        final json = notification.toJson();

        expect(json.containsKey('messageSubtitle'), isTrue);
        expect(json.containsKey('messageBody'), isTrue);
        expect(json.containsKey('contextLinks'), isTrue);
        expect(json['messageSubtitle'], isNull);
        expect(json['messageBody'], isNull);
        expect(json['contextLinks'], isNull);
      });
    });

    group('toFirestore Method', () {
      test('should delegate to toJson', () {
        final notification = FframeNotification(
          reporter: 'test-reporter',
          messageTitle: 'Test Title',
        );

        final firestoreData = notification.toFirestore();
        final jsonData = notification.toJson();

        expect(firestoreData, equals(jsonData));
      });

      test('should return proper Firestore-compatible data', () {
        final notification = FframeNotification(
          reporter: 'test-reporter',
          messageTitle: 'Test Title',
          type: 'warning',
        );

        final firestoreData = notification.toFirestore();

        expect(firestoreData, isA<Map<String, dynamic>>());
        expect(firestoreData['reporter'], equals('test-reporter'));
        expect(firestoreData['messageTitle'], equals('Test Title'));
        expect(firestoreData['type'], equals('warning'));
      });
    });

    group('Default Values', () {
      test('should use correct default values', () {
        final notification = FframeNotification(
          reporter: 'test-reporter',
          messageTitle: 'Test Title',
        );

        expect(notification.type, equals('notification'));
        expect(notification.seen, isFalse);
        expect(notification.read, isFalse);
        expect(notification.deleted, isFalse);
      });

      test('should allow overriding default values', () {
        final notification = FframeNotification(
          reporter: 'test-reporter',
          messageTitle: 'Test Title',
          type: 'custom-type',
          seen: true,
          read: true,
          deleted: true,
        );

        expect(notification.type, equals('custom-type'));
        expect(notification.seen, isTrue);
        expect(notification.read, isTrue);
        expect(notification.deleted, isTrue);
      });
    });

    group('Context Links', () {
      test('should handle empty context links', () {
        final notification = FframeNotification(
          reporter: 'test-reporter',
          messageTitle: 'Test Title',
          contextLinks: <Map<String, dynamic>>[],
        );

        expect(notification.contextLinks, isEmpty);
        expect(notification.contextLinks, isA<List<Map<String, dynamic>>>());
      });

      test('should handle complex context links structure', () {
        final contextLinks = <Map<String, dynamic>>[
          {
            'url': 'https://example.com/page1',
            'title': 'Page 1',
            'description': 'First page',
            'metadata': {'category': 'help', 'priority': 1}
          },
          {
            'url': 'https://example.com/page2',
            'title': 'Page 2',
            'icon': 'warning',
            'external': true
          }
        ];

        final notification = FframeNotification(
          reporter: 'test-reporter',
          messageTitle: 'Test Title',
          contextLinks: contextLinks,
        );

        expect(notification.contextLinks, equals(contextLinks));
        expect(notification.contextLinks!.length, equals(2));
        expect(notification.contextLinks![0]['metadata'], isA<Map>());
        expect(notification.contextLinks![1]['external'], isTrue);
      });
    });

    group('Edge Cases', () {
      test('should handle empty strings for required fields', () {
        final notification = FframeNotification(
          reporter: '',
          messageTitle: '',
        );

        expect(notification.reporter, equals(''));
        expect(notification.messageTitle, equals(''));
      });

      test('should handle very long strings', () {
        final longString = 'A' * 10000; // 10,000 character string
        
        final notification = FframeNotification(
          reporter: longString,
          messageTitle: longString,
          messageBody: longString,
        );

        expect(notification.reporter.length, equals(10000));
        expect(notification.messageTitle.length, equals(10000));
        expect(notification.messageBody!.length, equals(10000));
      });

      test('should handle special characters in strings', () {
        const specialChars = 'Test with émojis 🚀 and spéciál châractérs & symbols!@#\$%^&*()';
        
        final notification = FframeNotification(
          reporter: specialChars,
          messageTitle: specialChars,
          messageSubtitle: specialChars,
          messageBody: specialChars,
        );

        expect(notification.reporter, equals(specialChars));
        expect(notification.messageTitle, equals(specialChars));
        expect(notification.messageSubtitle, equals(specialChars));
        expect(notification.messageBody, equals(specialChars));
      });

      test('should handle extreme timestamps', () {
        final veryOldTime = Timestamp.fromDate(DateTime(1970, 1, 1));
        final veryFutureTime = Timestamp.fromDate(DateTime(2100, 12, 31));

        final notification = FframeNotification(
          reporter: 'test-reporter',
          messageTitle: 'Test Title',
          notificationTime: veryOldTime,
          firestoreTTL: veryFutureTime,
        );

        expect(notification.notificationTime, equals(veryOldTime));
        expect(notification.firestoreTTL, equals(veryFutureTime));
      });
    });
  });
}