import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe.dart';

import 'unit_test_harness.dart';

void main() {
  group('SignInConfig', () {
    setUp(() {
      setupUnitTests();
    });

    test('should create sign-in config with required signInTarget', () {
      final signInTarget = NavigationTarget(title: 'Sign In', path: '/signin');
      
      final config = SignInConfig(signInTarget: signInTarget);

      expect(config.signInTarget, equals(signInTarget));
      expect(config.invitionTarget, isNull);
    });

    test('should create sign-in config with both targets', () {
      final signInTarget = NavigationTarget(title: 'Sign In', path: '/signin');
      final invitationTarget = NavigationTarget(title: 'Invitation', path: '/invitation');
      
      final config = SignInConfig(
        signInTarget: signInTarget,
        invitionTarget: invitationTarget,
      );

      expect(config.signInTarget, equals(signInTarget));
      expect(config.invitionTarget, equals(invitationTarget));
    });

    test('should handle null invitionTarget', () {
      final signInTarget = NavigationTarget(title: 'Sign In', path: '/signin');
      
      final config = SignInConfig(
        signInTarget: signInTarget,
        invitionTarget: null,
      );

      expect(config.signInTarget, equals(signInTarget));
      expect(config.invitionTarget, isNull);
    });
  });
}