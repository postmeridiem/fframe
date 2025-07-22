import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/helpers/prompts.dart';

import '../widget_test_harness.dart';

void main() {
  group('promptOK Widget Tests', () {
    testWidgets('should display a dialog with the correct title and message', (WidgetTester tester) async {
      const String testTitle = 'Test Title';
      const String testMessage = 'This is a test message.';

      await tester.pumpWidget(
        TestHarness(
          child: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () => promptOK(context, testTitle, testMessage),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Tap the button to show the dialog.
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify that the dialog is displayed.
      expect(find.byType(AlertDialog), findsOneWidget);

      // Verify the title and message.
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testMessage), findsOneWidget);

      // Verify the button text.
      expect(find.text('I do!'), findsOneWidget);

      // Tap the button to close the dialog.
      await tester.tap(find.text('I do!'));
      await tester.pumpAndSettle();

      // Verify that the dialog is closed.
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}