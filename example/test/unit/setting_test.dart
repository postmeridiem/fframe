import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:fframe/fframe.dart';
import 'package:example/models/setting.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('Setting Model', () {
    timedTest('should create Setting with all parameters', () {
      final timestamp = Timestamp.now();
      
      final setting = Setting(
        id: 'test-setting-123',
        name: 'Test Setting',
        active: true,
        icon: 'settings',
        creationDate: timestamp,
        createdBy: 'test-user',
      );
      
      expect(setting.id, equals('test-setting-123'));
      expect(setting.name, equals('Test Setting'));
      expect(setting.active, isTrue);
      expect(setting.icon, equals('settings'));
      expect(setting.creationDate, equals(timestamp));
      expect(setting.createdBy, equals('test-user'));
    });

    timedTest('should create Setting with minimal parameters', () {
      final setting = Setting();
      
      expect(setting.id, isNull);
      expect(setting.name, isNull);
      expect(setting.active, isNull);
      expect(setting.icon, isNull);
      expect(setting.creationDate, isNull);
      expect(setting.createdBy, isNull);
    });

    timedTest('should be a ChangeNotifier', () {
      final setting = Setting();
      expect(setting, isA<ChangeNotifier>());
    });

    timedTest('should allow mutable properties to be changed', () {
      final setting = Setting(
        name: 'Initial Setting',
        active: true,
        icon: 'initial_icon',
      );
      
      // Test mutability of properties
      setting.id = 'updated-id';
      setting.name = 'Updated Setting';
      setting.active = false;
      setting.icon = 'updated_icon';
      setting.creationDate = Timestamp.now();
      setting.createdBy = 'updated-user';
      
      expect(setting.id, equals('updated-id'));
      expect(setting.name, equals('Updated Setting'));
      expect(setting.active, isFalse);
      expect(setting.icon, equals('updated_icon'));
      expect(setting.creationDate, isNotNull);
      expect(setting.createdBy, equals('updated-user'));
    });

    timedTest('should handle null values correctly', () {
      final setting = Setting(
        id: null,
        name: null,
        active: null,
        icon: null,
        creationDate: null,
        createdBy: null,
      );
      
      expect(setting.id, isNull);
      expect(setting.name, isNull);
      expect(setting.active, isNull);
      expect(setting.icon, isNull);
      expect(setting.creationDate, isNull);
      expect(setting.createdBy, isNull);
    });

    timedTest('should handle empty string values', () {
      final setting = Setting(
        id: '',
        name: '',
        icon: '',
        createdBy: '',
      );
      
      expect(setting.id, equals(''));
      expect(setting.name, equals(''));
      expect(setting.icon, equals(''));
      expect(setting.createdBy, equals(''));
    });

    timedTest('should handle boolean active field correctly', () {
      final activeSetting = Setting(active: true);
      final inactiveSetting = Setting(active: false);
      final undefinedSetting = Setting();
      
      expect(activeSetting.active, isTrue);
      expect(inactiveSetting.active, isFalse);
      expect(undefinedSetting.active, isNull);
    });

    timedTest('should handle various icon string values', () {
      final iconValues = [
        'home',
        'settings',
        'account_circle',
        'notification_important',
        'question_mark',
        '123',
        'special-icon_name',
      ];
      
      for (final iconValue in iconValues) {
        final setting = Setting(icon: iconValue);
        expect(setting.icon, equals(iconValue));
      }
    });

    timedTest('should handle timestamp creation dates', () {
      final pastDate = Timestamp.fromDate(DateTime(2020, 1, 1));
      final currentDate = Timestamp.now();
      final futureDate = Timestamp.fromDate(DateTime(2030, 12, 31));
      
      final pastSetting = Setting(creationDate: pastDate);
      final currentSetting = Setting(creationDate: currentDate);
      final futureSetting = Setting(creationDate: futureDate);
      
      expect(pastSetting.creationDate, equals(pastDate));
      expect(currentSetting.creationDate, equals(currentDate));
      expect(futureSetting.creationDate, equals(futureDate));
    });

    timedTest('should handle various createdBy user strings', () {
      final userNames = [
        'John Doe',
        'jane.smith@example.com',
        'user123',
        'Anonymous',
        'Test User With Spaces',
        'user-with-special_chars@domain.co.uk',
      ];
      
      for (final userName in userNames) {
        final setting = Setting(createdBy: userName);
        expect(setting.createdBy, equals(userName));
      }
    });

    timedTest('should handle long string values', () {
      final longName = 'This is a very long setting name that might be used in some edge cases ' * 3;
      final longId = 'very-long-id-${'x' * 100}';
      final longCreatedBy = 'very-long-username-${'y' * 50}';
      
      final setting = Setting(
        id: longId,
        name: longName,
        createdBy: longCreatedBy,
      );
      
      expect(setting.id, equals(longId));
      expect(setting.name, equals(longName));
      expect(setting.createdBy, equals(longCreatedBy));
      expect(setting.id!.length, greaterThan(100));
      expect(setting.name!.length, greaterThan(200));
    });

    timedTest('should handle special characters in strings', () {
      final setting = Setting(
        id: 'test-id-with-special-chars-123!@#',
        name: 'Setting with émojis 🚀 and åccénts',
        icon: 'icon_with_underscores',
        createdBy: 'Ñame with ñ and café',
      );
      
      expect(setting.id, equals('test-id-with-special-chars-123!@#'));
      expect(setting.name, equals('Setting with émojis 🚀 and åccénts'));
      expect(setting.icon, equals('icon_with_underscores'));
      expect(setting.createdBy, equals('Ñame with ñ and café'));
    });
  });
}