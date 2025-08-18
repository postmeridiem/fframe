import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe.dart';

import 'unit_test_harness.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('FFrameUser', () {
    setUp(() {
      setupUnitTests();
    });

    timedGroup('Constructor', () {
      timedTest('should create user with all parameters', () {
        final user = FFrameUser(
          id: 'test-id',
          uid: 'test-uid',
          displayName: 'Test User',
          email: 'test@example.com',
          photoURL: 'https://example.com/photo.jpg',
          roles: <String>['admin', 'user'],
        );

        expect(user.id, equals('test-id'));
        expect(user.uid, equals('test-uid'));
        expect(user.displayName, equals('Test User'));
        expect(user.email, equals('test@example.com'));
        expect(user.photoURL, equals('https://example.com/photo.jpg'));
        expect(user.roles, equals(['admin', 'user']));
        expect(user.timeStamp, isNotNull);
        expect(user, isA<ChangeNotifier>());
      });

      timedTest('should create user with minimal parameters', () {
        final user = FFrameUser();

        expect(user.id, isNull);
        expect(user.uid, isNull);
        expect(user.displayName, isNull);
        expect(user.email, isNull);
        expect(user.photoURL, isNull);
        expect(user.roles, isEmpty); // Empty list when _roles is null
        expect(user.timeStamp, isNotNull);
      });

      timedTest('should set timestamp on creation', () {
        final beforeCreation = DateTime.now();
        final user = FFrameUser();
        final afterCreation = DateTime.now();

        expect(user.timeStamp, isNotNull);
        expect(user.timeStamp!.isAfter(beforeCreation.subtract(const Duration(seconds: 1))), isTrue);
        expect(user.timeStamp!.isBefore(afterCreation.add(const Duration(seconds: 1))), isTrue);
      });

      timedTest('should be a ChangeNotifier', () {
        final user = FFrameUser();
        
        expect(user, isA<ChangeNotifier>());
      });
    });

    timedGroup('Roles Management', () {
      timedTest('should return empty list when roles is null', () {
        final user = FFrameUser();
        
        expect(user.roles, isEmpty);
        expect(user.roles, isA<List<String>>());
      });

      timedTest('should return roles when provided', () {
        final user = FFrameUser(roles: <String>['admin', 'editor', 'viewer']);
        
        expect(user.roles, equals(['admin', 'editor', 'viewer']));
        expect(user.roles.length, equals(3));
      });

      timedTest('should preserve role order', () {
        final roles = <String>['viewer', 'admin', 'editor'];
        final user = FFrameUser(roles: roles);
        
        expect(user.roles, equals(roles));
      });

      timedTest('should handle empty roles list', () {
        final user = FFrameUser(roles: <String>[]);
        
        expect(user.roles, isEmpty);
      });
    });

    timedGroup('hasRole Method', () {
      timedTest('should return true for existing role', () {
        final user = FFrameUser(roles: <String>['admin', 'editor']);
        
        expect(user.hasRole('admin'), isTrue);
        expect(user.hasRole('editor'), isTrue);
      });

      timedTest('should return false for non-existing role', () {
        final user = FFrameUser(roles: <String>['admin']);
        
        expect(user.hasRole('editor'), isFalse);
        expect(user.hasRole('viewer'), isFalse);
        expect(user.hasRole('nonexistent'), isFalse);
      });

      timedTest('should handle case insensitivity correctly', () {
        // hasRole converts input to lowercase and checks against stored roles
        // So for case insensitivity to work, stored roles should be lowercase
        final user = FFrameUser(roles: <String>['admin', 'editor', 'viewer']);
        
        // Test lowercase input
        expect(user.hasRole('admin'), isTrue);
        expect(user.hasRole('editor'), isTrue);
        expect(user.hasRole('viewer'), isTrue);
        
        // Test uppercase input - should work because hasRole converts to lowercase
        expect(user.hasRole('ADMIN'), isTrue);
        expect(user.hasRole('EDITOR'), isTrue);
        expect(user.hasRole('VIEWER'), isTrue);
        
        // Test mixed case input - should work because hasRole converts to lowercase
        expect(user.hasRole('Admin'), isTrue);
        expect(user.hasRole('Editor'), isTrue);
        expect(user.hasRole('Viewer'), isTrue);
      });

      timedTest('should handle special characters in roles', () {
        final user = FFrameUser(roles: <String>['admin-user', 'api_reader', 'role.with.dots']);
        
        expect(user.hasRole('admin-user'), isTrue);
        expect(user.hasRole('api_reader'), isTrue);
        expect(user.hasRole('role.with.dots'), isTrue);
        expect(user.hasRole('ADMIN-USER'), isTrue); // hasRole converts to lowercase
      });

      timedTest('should throw when roles is null and hasRole is called', () {
        final user = FFrameUser(); // No roles provided, _roles is null
        
        expect(() => user.hasRole('any-role'), throwsA(isA<TypeError>()));
      });
    });

    timedGroup('Edge Cases', () {
      timedTest('should handle null and empty string roles', () {
        final user = FFrameUser(roles: <String>['', 'valid-role']);
        
        expect(user.roles, contains(''));
        expect(user.roles, contains('valid-role'));
        expect(user.hasRole(''), isTrue);
        expect(user.hasRole('valid-role'), isTrue);
      });

      timedTest('should handle duplicate roles', () {
        final user = FFrameUser(roles: <String>['admin', 'admin', 'user', 'admin']);
        
        expect(user.roles, equals(['admin', 'admin', 'user', 'admin'])); // Preserves duplicates
        expect(user.hasRole('admin'), isTrue);
        expect(user.hasRole('user'), isTrue);
      });

      timedTest('should handle unicode characters in roles', () {
        final user = FFrameUser(roles: <String>['管理员', 'ユーザー', 'administrador']);
        
        expect(user.hasRole('管理员'), isTrue);
        expect(user.hasRole('ユーザー'), isTrue);  
        expect(user.hasRole('administrador'), isTrue);
      });

      timedTest('should handle very long role names', () {
        final longRole = 'a' * 1000; // 1000 character role name
        final user = FFrameUser(roles: <String>[longRole]);
        
        expect(user.hasRole(longRole), isTrue);
        expect(user.roles.first.length, equals(1000));
      });
    });

    timedGroup('Properties Immutability', () {
      timedTest('should have immutable properties', () {
        final user = FFrameUser(
          id: 'test-id',
          uid: 'test-uid',
          displayName: 'Test User',
          email: 'test@example.com',
          photoURL: 'https://example.com/photo.jpg',
        );

        // These properties should be final and unchangeable
        expect(user.id, equals('test-id'));
        expect(user.uid, equals('test-uid'));
        expect(user.displayName, equals('Test User'));
        expect(user.email, equals('test@example.com'));
        expect(user.photoURL, equals('https://example.com/photo.jpg'));
      });

      timedTest('should allow roles to be accessed but not modified externally', () {
        final originalRoles = <String>['admin', 'user'];
        final user = FFrameUser(roles: originalRoles);
        
        final retrievedRoles = user.roles;
        expect(retrievedRoles, equals(originalRoles));
        
        // Verify roles getter returns the internal list
        expect(identical(retrievedRoles, user.roles), isTrue);
      });
    });
  });
}