import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe.dart';

void main() {
  group('NavigationConfig', () {
    test('clone factory creates a deep copy', () {
      // 1. Create original NavigationConfig
      final original = NavigationConfig(
        signInConfig: SignInConfig(
          signInTarget: NavigationTarget(
            path: 'signin',
            title: 'Sign In',
            contentPane: const Text('Sign In'),
          ),
        ),
        errorPage: NavigationTarget(path: 'error', title: 'Error', contentPane: const Text('Error')),
        emptyPage: NavigationTarget(path: 'empty', title: 'Empty', contentPane: const Text('Empty')),
        waitPage: NavigationTarget(path: 'wait', title: 'Wait', contentPane: const Text('Wait')),
        navigationTargets: [
          // This is the parent target. It has no contentPane itself, only tabs.
          NavigationTarget(
            path: 'home',
            title: 'Home',
            destination: Destination(
              icon: const Icon(Icons.home),
              navigationLabel: () => const Text('Home'),
            ),
            navigationTabs: [
              // This is the child tab, which has the actual content.
              NavigationTab(
                title: 'Tab 1',
                path: 'tab1',
                contentPane: const Text('Tab 1 Content'),
                destination: Destination(
                  icon: const Icon(Icons.tab),
                  navigationLabel: () => const Text('Tab 1'),
                ),
              ),
            ],
          ),
        ],
      );

      // 2. Create a clone
      final clone = NavigationConfig.clone(original);

      // 3. Assert that the clone is not the same instance
      expect(identical(original, clone), isFalse);

      // 4. Assert that top-level properties are equal
      expect(clone.errorPage.path, original.errorPage.path);
      expect(clone.emptyPage.path, original.emptyPage.path);
      expect(clone.waitPage.path, original.waitPage.path);

      // 5. Assert that the navigationTargets list is a new instance
      expect(identical(original.navigationTargets, clone.navigationTargets), isFalse);
      expect(clone.navigationTargets.length, 1);

      // 6. Assert that the nested NavigationTarget is a new instance
      final originalTarget = original.navigationTargets.first;
      final clonedTarget = clone.navigationTargets.first;
      expect(identical(originalTarget, clonedTarget), isFalse);
      expect(clonedTarget.path, 'home');

      // 7. Assert that the nested navigationTabs list is a new instance
      expect(identical(originalTarget.navigationTabs, clonedTarget.navigationTabs), isFalse);
      expect(clonedTarget.navigationTabs?.length, 1);
      expect(clonedTarget.navigationTabs?.first.path, 'tab1');
    });
  });
}
