import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/helpers/profile_buttons.dart';
import 'widget_test_harness.dart';

void main() {
  group('ProfileButtons', () {
    testWidgets('ThemeDropdown should build and change value', (WidgetTester tester) async {
      await tester.pumpWidget(const TestHarness(child: Scaffold(body: Center(child: ThemeDropdown()))));
      expect(find.text('Theme: auto'), findsOneWidget);
      await tester.tap(find.text('Theme: auto'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Theme: dark').last);
      await tester.pumpAndSettle();
      expect(find.text('Theme: dark'), findsOneWidget);
    });

    testWidgets('LocaleDropdown should build and change value', (WidgetTester tester) async {
      await tester.pumpWidget(const TestHarness(child: Scaffold(body: Center(child: LocaleDropdown()))));
      expect(find.text('Locale: en-US'), findsOneWidget);
      await tester.tap(find.text('Locale: en-US'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Locale: nl-NL').last);
      await tester.pumpAndSettle();
      expect(find.text('Locale: nl-NL'), findsOneWidget);
    });
  });
} 