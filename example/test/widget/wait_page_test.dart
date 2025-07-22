import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/pages/wait_page.dart';
import '../widget_test_harness.dart';

void main() {
  testWidgets('WaitPage renders loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(
      MinimalFframe(child: const WaitPage()),
    );
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });
} 