import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/helpers/header_buttons.dart';
import 'widget_test_harness.dart';

void main() {
  group('Header Buttons Widget Tests', () {
    testWidgets('BarButtonShare should render icon and tooltip', (WidgetTester tester) async {
      await tester.pumpWidget(const TestHarness(child: Scaffold(body: BarButtonShare())));
      expect(find.byType(BarButtonShare), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.byTooltip('Copy deeplink...'), findsOneWidget);
      
      // Verify the button is tappable (doesn't test async side effects)
      await tester.tap(find.byType(BarButtonShare));
      await tester.pump();
      // Note: SnackBar testing requires mocking FlutterClipboard.copy()
      // which is beyond the scope of this widget test
    });

    testWidgets('BarButtonDuplicate should render icon and tooltip', (WidgetTester tester) async {
      await tester.pumpWidget(const TestHarness(child: Scaffold(body: BarButtonDuplicate())));
      expect(find.byType(BarButtonDuplicate), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
      expect(find.byTooltip('Open in new tab...'), findsOneWidget);
      
      // Verify the button is tappable (doesn't test async side effects)
      await tester.tap(find.byType(BarButtonDuplicate));
      await tester.pump();
      // Note: SnackBar testing requires mocking launchUrl()
      // which is beyond the scope of this widget test
    });

    testWidgets('BarButtonFeedback should render icon and tooltip', (WidgetTester tester) async {
      await tester.pumpWidget(const TestHarness(child: Scaffold(body: BarButtonFeedback())));
      expect(find.byType(BarButtonFeedback), findsOneWidget);
      expect(find.byIcon(Icons.pest_control), findsOneWidget);
      expect(find.byTooltip('Open issue tracker...'), findsOneWidget);
      
      // Verify the button is tappable (doesn't test async side effects)
      await tester.tap(find.byType(BarButtonFeedback));
      await tester.pump();
      // Note: SnackBar testing requires mocking launchUrl()
      // which is beyond the scope of this widget test
    });
  });
} 