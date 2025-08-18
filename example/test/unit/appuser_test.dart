import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:fframe/fframe.dart';
import 'package:example/models/appuser.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('AppUser Model', () {
    timedTest('should create AppUser with all parameters', () {
      final timestamp = Timestamp.now();
      final customClaims = {'role': 'admin', 'tenant': 'test'};
      
      final user = AppUser(
        uid: 'test-uid-123',
        displayName: 'Test User',
        active: true,
        customClaims: customClaims,
        email: 'test@example.com',
        photoURL: 'https://example.com/photo.jpg',
        creationDate: timestamp,
        tennant: 'test-tenant',
      );
      
      expect(user.uid, equals('test-uid-123'));
      expect(user.displayName, equals('Test User'));
      expect(user.active, isTrue);
      expect(user.customClaims, equals(customClaims));
      expect(user.email, equals('test@example.com'));
      expect(user.photoURL, equals('https://example.com/photo.jpg'));
      expect(user.creationDate, equals(timestamp));
      expect(user.tennant, equals('test-tenant'));
    });

    timedTest('should create AppUser with minimal parameters', () {
      final user = AppUser();
      
      expect(user.uid, isNull);
      expect(user.displayName, isNull);
      expect(user.active, isNull);
      expect(user.customClaims, isNull);
      expect(user.email, isNull);
      expect(user.photoURL, isNull);
      expect(user.creationDate, isNull);
      expect(user.tennant, isNull);
    });

    timedTest('should be a ChangeNotifier', () {
      final user = AppUser();
      expect(user, isA<ChangeNotifier>());
    });

    timedTest('should allow mutable properties to be changed', () {
      final user = AppUser(
        displayName: 'Initial Name',
        active: true,
        email: 'initial@example.com',
      );
      
      // Test mutability of properties
      user.displayName = 'Updated Name';
      user.active = false;
      user.email = 'updated@example.com';
      user.tennant = 'new-tenant';
      user.photoURL = 'https://example.com/new-photo.jpg';
      user.customClaims = {'role': 'user'};
      user.creationDate = Timestamp.now();
      
      expect(user.displayName, equals('Updated Name'));
      expect(user.active, isFalse);
      expect(user.email, equals('updated@example.com'));
      expect(user.tennant, equals('new-tenant'));
      expect(user.photoURL, equals('https://example.com/new-photo.jpg'));
      expect(user.customClaims, equals({'role': 'user'}));
      expect(user.creationDate, isNotNull);
    });

    timedTest('should handle null values correctly', () {
      final user = AppUser(
        uid: null,
        displayName: null,
        active: null,
        customClaims: null,
        email: null,
        photoURL: null,
        creationDate: null,
        tennant: null,
      );
      
      expect(user.uid, isNull);
      expect(user.displayName, isNull);
      expect(user.active, isNull);
      expect(user.customClaims, isNull);
      expect(user.email, isNull);
      expect(user.photoURL, isNull);
      expect(user.creationDate, isNull);
      expect(user.tennant, isNull);
    });

    timedTest('should handle empty string values', () {
      final user = AppUser(
        uid: '',
        displayName: '',
        email: '',
        photoURL: '',
        tennant: '',
      );
      
      expect(user.uid, equals(''));
      expect(user.displayName, equals(''));
      expect(user.email, equals(''));
      expect(user.photoURL, equals(''));
      expect(user.tennant, equals(''));
    });

    timedTest('should handle complex customClaims structure', () {
      final complexClaims = {
        'role': 'admin',
        'permissions': ['read', 'write', 'delete'],
        'tenant': 'acme-corp',
        'metadata': {
          'lastLogin': '2023-10-26',
          'preferences': {'theme': 'dark', 'locale': 'en-US'}
        }
      };
      
      final user = AppUser(customClaims: complexClaims);
      
      expect(user.customClaims, equals(complexClaims));
      expect(user.customClaims?['role'], equals('admin'));
      expect(user.customClaims?['permissions'], isA<List>());
      expect(user.customClaims?['metadata'], isA<Map>());
    });

    timedTest('should handle boolean active field correctly', () {
      final activeUser = AppUser(active: true);
      final inactiveUser = AppUser(active: false);
      final undefinedUser = AppUser();
      
      expect(activeUser.active, isTrue);
      expect(inactiveUser.active, isFalse);
      expect(undefinedUser.active, isNull);
    });

    timedTest('should allow uid to remain immutable after construction', () {
      final user = AppUser(uid: 'original-uid');
      
      // uid is final, so this test just verifies it remains unchanged
      expect(user.uid, equals('original-uid'));
      
      // Verify we can't accidentally modify it (would be compile-time error)
      // user.uid = 'new-uid'; // This would cause compilation error
    });
  });
}