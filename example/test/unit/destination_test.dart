import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe.dart';

import 'unit_test_harness.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  timedGroup('Destination', () {
    setUp(() {
      setupUnitTests();
    });

    timedTest('should create destination with required parameters', () {
      const icon = Icon(Icons.home);
      Widget navigationLabel() => const Text('Home');
      
      final destination = Destination(
        icon: icon,
        navigationLabel: navigationLabel,
      );

      expect(destination.icon, equals(icon));
      expect(destination.selectedIcon, equals(icon)); // Defaults to icon
      expect(destination.navigationLabel, equals(navigationLabel));
      expect(destination.tabLabel, isNull);
      expect(destination.padding, isNull);
    });

    timedTest('should create destination with all parameters', () {
      const icon = Icon(Icons.home);
      const selectedIcon = Icon(Icons.home_filled);
      Widget navigationLabel() => const Text('Home');
      String tabLabel() => 'Home Tab';
      const padding = EdgeInsets.all(8.0);
      
      final destination = Destination(
        icon: icon,
        selectedIcon: selectedIcon,
        navigationLabel: navigationLabel,
        tabLabel: tabLabel,
        padding: padding,
      );

      expect(destination.icon, equals(icon));
      expect(destination.selectedIcon, equals(selectedIcon));
      expect(destination.navigationLabel, equals(navigationLabel));
      expect(destination.tabLabel, equals(tabLabel));
      expect(destination.padding, equals(padding));
    });

    timedTest('should use icon as selectedIcon when selectedIcon is null', () {
      const icon = Icon(Icons.settings);
      Widget navigationLabel() => const Text('Settings');
      
      final destination = Destination(
        icon: icon,
        selectedIcon: null,
        navigationLabel: navigationLabel,
      );

      expect(destination.selectedIcon, equals(icon));
    });

    timedTest('should create functional navigation and tab labels', () {
      Widget navigationLabel() => const Text('Profile');
      String tabLabel() => 'Profile Tab';
      
      final destination = Destination(
        icon: const Icon(Icons.person),
        navigationLabel: navigationLabel,
        tabLabel: tabLabel,
      );

      // Test that the function callbacks work
      final navWidget = destination.navigationLabel();
      final tabString = destination.tabLabel!();

      expect(navWidget, isA<Text>());
      expect((navWidget as Text).data, equals('Profile'));
      expect(tabString, equals('Profile Tab'));
    });
  });
}