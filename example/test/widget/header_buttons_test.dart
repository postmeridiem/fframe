import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/helpers/header_buttons.dart';
import 'widget_test_harness.dart';

void main() {
  group('Header Buttons Widget Tests', () {
    testWidgets('BarButtonShare should render icon, tooltip, and respond to tap', (WidgetTester tester) async {
      await tester.pumpWidget(MinimalFframe(child: const BarButtonShare()));
      expect(find.byType(BarButtonShare), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.byTooltip('Copy deeplink...'), findsOneWidget);
      await tester.tap(find.byType(BarButtonShare));
      await tester.pumpAndSettle();
      // Snackbar should appear (text may be localized, so check for SnackBar)
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('BarButtonDuplicate should render icon, tooltip, and respond to tap', (WidgetTester tester) async {
      await tester.pumpWidget(MinimalFframe(child: const BarButtonDuplicate()));
      expect(find.byType(BarButtonDuplicate), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
      expect(find.byTooltip('Open in new tab...'), findsOneWidget);
      await tester.tap(find.byType(BarButtonDuplicate));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('BarButtonFeedback should render icon, tooltip, and respond to tap', (WidgetTester tester) async {
      await tester.pumpWidget(MinimalFframe(child: const BarButtonFeedback()));
      expect(find.byType(BarButtonFeedback), findsOneWidget);
      expect(find.byIcon(Icons.pest_control), findsOneWidget);
      expect(find.byTooltip('Open issue tracker...'), findsOneWidget);
      await tester.tap(find.byType(BarButtonFeedback));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
} 