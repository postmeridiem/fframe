import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/models/configuration.dart';

import 'unit_test_harness.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('Configuration', () {
    setUp(() {
      setupUnitTests();
    });

    timedTest('should create configuration with default values', () {
      final config = Configuration();

      expect(config.id, isNull);
      expect(config.name, isNull);
      expect(config.icon, isNull);
      expect(config.active, isNull);
      expect(config.order, isNull);
      expect(config, isA<ChangeNotifier>());
    });

    timedTest('should create configuration with all parameters', () {
      final config = Configuration(
        id: 'test-id',
        name: 'Test Config',
        icon: 'settings',
        active: true,
        order: 1,
      );

      expect(config.id, equals('test-id'));
      expect(config.name, equals('Test Config'));
      expect(config.icon, equals('settings'));
      expect(config.active, isTrue);
      expect(config.order, equals(1));
    });

    timedTest('should convert to Firestore map correctly', () {
      final config = Configuration(
        id: 'test-id',
        name: 'Test Config',
        icon: 'home',
        active: false,
        order: 5,
      );

      final firestoreMap = config.toFirestore();

      expect(firestoreMap, equals({
        'active': false,
        'name': 'Test Config',
        'icon': 'home',
        'order': 5,
      }));
      expect(firestoreMap.containsKey('id'), isFalse); // ID not included in Firestore
    });

    timedTest('should handle null values in toFirestore', () {
      final config = Configuration();

      final firestoreMap = config.toFirestore();

      expect(firestoreMap, equals({
        'active': null,
        'name': null,
        'icon': null,
        'order': null,
      }));
    });

    timedTest('should allow mutable properties to be changed', () {
      final config = Configuration(
        name: 'Original',
        active: true,
        order: 1,
      );

      config.name = 'Updated';
      config.active = false;
      config.order = 10;

      expect(config.name, equals('Updated'));
      expect(config.active, isFalse);
      expect(config.order, equals(10));
    });

    timedTest('should not allow id to be changed after creation', () {
      final config = Configuration(id: 'immutable-id');
      
      expect(config.id, equals('immutable-id'));
      // ID is final, so it cannot be changed
    });
  });
}