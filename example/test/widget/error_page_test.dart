import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/pages/error_page.dart';
import 'widget_test_harness.dart';

void main() {
  testWidgets('ErrorPage renders animated error icon and error text', (WidgetTester tester) async {
    // Use TestHarness as the preferred widget test harness
    await tester.pumpWidget(TestHarness(child: Scaffold(body: ErrorPage())));
    expect(find.byType(AnimatedCrossFade), findsOneWidget);
    expect(find.byType(Text), findsWidgets);
    await tester.pump(const Duration(seconds: 11));
    expect(find.byType(AnimatedCrossFade), findsOneWidget);
  });
} 