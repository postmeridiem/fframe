import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/pages/empty_page.dart';
import '../widget_test_harness.dart';

void main() {
  testWidgets('EmptyPage renders animated icon and text', (WidgetTester tester) async {
    await tester.pumpWidget(MinimalFframe(child: const EmptyPage()));
    // Initial state
    expect(find.byType(AnimatedCrossFade), findsOneWidget);
    expect(find.text('Much empty'), findsOneWidget);
    // Simulate timer tick
    await tester.pump(const Duration(seconds: 11));
    expect(find.byType(AnimatedCrossFade), findsOneWidget);
  });
} 