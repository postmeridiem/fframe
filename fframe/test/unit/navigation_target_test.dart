import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/fframe.dart';

void main() {
  group('NavigationTarget', () {
    test('should construct successfully with only a contentPane', () {
      expect(
        () => NavigationTarget(
          title: 'Test',
          path: 'test',
          contentPane: const Text('Test Content'),
        ),
        returnsNormally,
      );
    });

    test('should construct successfully with only navigationTabs', () {
      expect(
        () => NavigationTarget(
          title: 'Test',
          path: 'test',
          navigationTabs: [
            NavigationTab(
              title: 'Tab',
              path: 'tab',
              contentPane: const Text('Tab Content'),
              destination: Destination(
                icon: const Icon(Icons.tab),
                navigationLabel: () => const Text('Tab'),
              ),
            ),
          ],
        ),
        returnsNormally,
      );
    });

    test('should throw AssertionError if both contentPane and navigationTabs are provided', () {
      expect(
        () => NavigationTarget(
          title: 'Test',
          path: 'test',
          contentPane: const Text('Test Content'),
          navigationTabs: [],
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should construct successfully with neither contentPane nor navigationTabs', () {
      expect(
        () => NavigationTarget(
          title: 'Test',
          path: 'test',
        ),
        returnsNormally,
      );
    });
  });
}
