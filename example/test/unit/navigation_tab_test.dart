import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe.dart';

import 'unit_test_harness.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('NavigationTab', () {
    setUp(() {
      setupUnitTests();
    });

    timedTest('should create navigation tab with required parameters', () {
      Widget navigationLabel() => const Text('Tab');
      final destination = Destination(
        icon: const Icon(Icons.tab),
        navigationLabel: navigationLabel,
      );
      const contentPane = Text('Tab Content');
      
      final tab = NavigationTab(
        title: 'Test Tab',
        path: '/test-tab',
        contentPane: contentPane,
        destination: destination,
      );

      expect(tab.title, equals('Test Tab'));
      expect(tab.path, equals('/test-tab'));
      expect(tab.contentPane, equals(contentPane));
      expect(tab.destination, equals(destination));
      expect(tab.navigationTabs, isNull);
      expect(tab.roles, isNull);
      expect(tab.public, isFalse); // Default false
      expect(tab.private, isTrue); // Default true
      expect(tab.parentTarget, isNull);
    });

    timedTest('should create navigation tab with all parameters', () {
      Widget navigationLabel() => const Text('Advanced Tab');
      final destination = Destination(
        icon: const Icon(Icons.settings_applications),
        navigationLabel: navigationLabel,
      );
      const contentPane = Text('Advanced Content');
      const roles = ['admin', 'user'];
      
      final tab = NavigationTab(
        title: 'Advanced Tab',
        path: '/advanced',
        contentPane: contentPane,
        destination: destination,
        roles: roles,
        public: true,
        private: false,
      );

      expect(tab.title, equals('Advanced Tab'));
      expect(tab.path, equals('/advanced'));
      expect(tab.contentPane, equals(contentPane));
      expect(tab.destination, equals(destination));
      expect(tab.roles, equals(roles));
      expect(tab.public, isTrue);
      expect(tab.private, isFalse);
      expect(tab.parentTarget, isNull);
    });

    timedTest('should allow setting parentTarget', () {
      Widget navigationLabel() => const Text('Child Tab');
      final destination = Destination(
        icon: const Icon(Icons.child_care),
        navigationLabel: navigationLabel,
      );
      const contentPane = Text('Child Content');
      
      final parentTarget = NavigationTarget(
        title: 'Parent',
        path: '/parent',
        contentPane: const Text('Parent Content'),
      );
      
      final tab = NavigationTab(
        title: 'Child Tab',
        path: '/child',
        contentPane: contentPane,
        destination: destination,
      );
      
      tab.parentTarget = parentTarget;

      expect(tab.parentTarget, equals(parentTarget));
    });

    timedTest('should inherit from NavigationTarget', () {
      Widget navigationLabel() => const Text('Inherited Tab');
      final destination = Destination(
        icon: const Icon(Icons.nature),
        navigationLabel: navigationLabel,
      );
      const contentPane = Text('Inherited Content');
      
      final tab = NavigationTab(
        title: 'Inherited Tab',
        path: '/inherited',
        contentPane: contentPane,
        destination: destination,
      );

      expect(tab, isA<NavigationTarget>());
      expect(tab.landingPage, isFalse); // NavigationTarget default
      expect(tab.profilePage, isFalse); // NavigationTarget default
    });
  });
}