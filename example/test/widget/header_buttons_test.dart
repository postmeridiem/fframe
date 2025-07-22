import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/helpers/header_buttons.dart';

import '../widget_test_harness.dart';

void main() {
  group('Header Buttons Widget Tests', () {
    testWidgets('BarButtonShare should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestHarness(
          child: BarButtonShare(),
        ),
      );

      // Verify that the button and its icon are displayed.
      expect(find.byType(BarButtonShare), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);

      // Tap the button to trigger the onPressed handler.
      await tester.tap(find.byType(BarButtonShare));
      await tester.pumpAndSettle();
    });

    testWidgets('BarButtonDuplicate should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestHarness(
          child: BarButtonDuplicate(),
        ),
      );

      // Verify that the button and its icon are displayed.
      expect(find.byType(BarButtonDuplicate), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);

      // Tap the button to trigger the onPressed handler.
      await tester.tap(find.byType(BarButtonDuplicate));
      await tester.pumpAndSettle();
    });

    testWidgets('BarButtonFeedback should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestHarness(
          child: BarButtonFeedback(),
        ),
      );

      // Verify that the button and its icon are displayed.
      expect(find.byType(BarButtonFeedback), findsOneWidget);
      expect(find.byIcon(Icons.pest_control), findsOneWidget);

      // Tap the button to trigger the onPressed handler.
      await tester.tap(find.byType(BarButtonFeedback));
      await tester.pumpAndSettle();
    });
  });
}
