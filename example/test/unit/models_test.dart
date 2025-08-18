import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:example/models/models.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('Models Export', () {
    timedTest('should export Setting class', () {
      // Verify Setting class is accessible via models.dart export
      final setting = Setting();
      expect(setting, isA<Setting>());
      expect(setting.name, isNull);
      expect(setting.active, isNull);
      expect(setting.icon, isNull);
    });

    timedTest('should export Suggestion class', () {
      // Verify Suggestion class is accessible via models.dart export
      final suggestion = Suggestion();
      expect(suggestion, isA<Suggestion>());
      expect(suggestion.name, isNull);
      expect(suggestion.status, isNull);
      expect(suggestion.saveCount, equals(0)); // Default value
      expect(suggestion.priority, equals(3.0)); // Default value
    });

    timedTest('should export AppUser class', () {
      // Verify AppUser class is accessible via models.dart export
      final appUser = AppUser();
      expect(appUser, isA<AppUser>());
      expect(appUser.uid, isNull);
      expect(appUser.displayName, isNull);
      expect(appUser.email, isNull);
    });

    timedTest('should export FframeList class', () {
      // Verify FframeList class is accessible via models.dart export
      final fframeList = FframeList();
      expect(fframeList, isA<FframeList>());
      expect(fframeList.id, isNull);
      expect(fframeList.name, isNull);
      expect(fframeList.type, isNull);
      expect(fframeList.options, isNull);
    });

    timedTest('should allow all exported models to be instantiated together', () {
      // Test that all exported models can be used in the same context
      final setting = Setting(name: 'Test Setting');
      final suggestion = Suggestion(name: 'Test Suggestion');
      final appUser = AppUser(displayName: 'Test User');
      final fframeList = FframeList(name: 'Test List');
      
      expect(setting.name, equals('Test Setting'));
      expect(suggestion.name, equals('Test Suggestion'));
      expect(appUser.displayName, equals('Test User'));
      expect(fframeList.name, equals('Test List'));
    });

    timedTest('should have all models implement expected interfaces', () {
      final setting = Setting();
      final appUser = AppUser();
      final fframeList = FframeList();
      
      // Verify ChangeNotifier implementation where expected
      expect(setting, isA<ChangeNotifier>());
      expect(appUser, isA<ChangeNotifier>());
      expect(fframeList, isA<ChangeNotifier>());
      
      // Suggestion doesn't extend ChangeNotifier, so don't test it
    });

    timedTest('should handle models with complex data structures', () {
      // Test models with various data types work together
      final suggestion = Suggestion(
        name: 'Complex Test',
        followers: ['user1@example.com', 'user2@example.com'],
        saveCount: 10.0,
        priority: 2.5,
      );
      
      final fframeList = FframeList(
        name: 'Complex List',
        options: [
          {'label': 'Option 1', 'value': 1},
          {'label': 'Option 2', 'value': 2},
        ],
      );
      
      expect(suggestion.followers?.length, equals(2));
      expect(suggestion.saveCount, equals(10.0));
      expect(fframeList.options?.length, equals(2));
    });

    timedTest('should maintain model independence', () {
      // Verify that models don't interfere with each other
      final setting1 = Setting(name: 'Setting 1', active: true);
      final setting2 = Setting(name: 'Setting 2', active: false);
      
      final suggestion1 = Suggestion(name: 'Suggestion 1', priority: 1.0);
      final suggestion2 = Suggestion(name: 'Suggestion 2', priority: 5.0);
      
      // Ensure instances are independent
      expect(setting1.name, equals('Setting 1'));
      expect(setting2.name, equals('Setting 2'));
      expect(setting1.active, isTrue);
      expect(setting2.active, isFalse);
      
      expect(suggestion1.priority, equals(1.0));
      expect(suggestion2.priority, equals(5.0));
    });
  });
}