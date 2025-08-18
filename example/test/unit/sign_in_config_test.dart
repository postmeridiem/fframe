import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe.dart';

import 'unit_test_harness.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('SignInConfig', () {
    setUp(() {
      setupUnitTests();
    });

    timedTest('should create sign-in config with required signInTarget', () {
      final signInTarget = NavigationTarget(title: 'Sign In', path: '/signin');
      
      final config = SignInConfig(signInTarget: signInTarget);

      expect(config.signInTarget, equals(signInTarget));
      expect(config.invitionTarget, isNull);
    });

    timedTest('should create sign-in config with both targets', () {
      final signInTarget = NavigationTarget(title: 'Sign In', path: '/signin');
      final invitationTarget = NavigationTarget(title: 'Invitation', path: '/invitation');
      
      final config = SignInConfig(
        signInTarget: signInTarget,
        invitionTarget: invitationTarget,
      );

      expect(config.signInTarget, equals(signInTarget));
      expect(config.invitionTarget, equals(invitationTarget));
    });

    timedTest('should handle null invitionTarget', () {
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