import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/helpers/prompts.dart';
import 'widget_test_harness.dart';

void main() {
  group('promptOK Widget Tests', () {
    testWidgets('should display a dialog with the correct title and message', (WidgetTester tester) async {
      const String testTitle = 'Test Title';
      const String testMessage = 'This is a test message.';

      await tester.pumpWidget(
        TestHarness(child: Scaffold(body: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () => promptOK(context, testTitle, testMessage),
              child: const Text('Show Dialog'),
            );
          },
        ))),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testMessage), findsOneWidget);
      expect(find.text('I do!'), findsOneWidget);

      await tester.tap(find.text('I do!'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
} 