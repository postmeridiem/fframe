import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/helper_widgets/confirmation_dialog.dart';

import 'widget_test_harness.dart';

void main() {
  testWidgets('ConfirmationDialog shows and returns true on continue', (WidgetTester tester) async {
    bool? result;

    await tester.pumpWidget(
      TestHarness(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await confirmationDialog(
                context: context,
                titleText: 'Test Title',
                child: const Text('Test Content'),
                cancelText: 'Cancel',
                continueText: 'Continue',
              );
            },
            child: const Text('Show Dialog'),
          ),
        ),
      ),
    );

    // Open the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Verify the dialog is visible
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);

    // Tap the continue button
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Verify the dialog is closed and returned true
    expect(find.byType(AlertDialog), findsNothing);
    expect(result, isTrue);
  });

  testWidgets('ConfirmationDialog shows and returns false on cancel', (WidgetTester tester) async {
    bool? result;

    await tester.pumpWidget(
      TestHarness(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await confirmationDialog(
                context: context,
                titleText: 'Test Title',
                child: const Text('Test Content'),
                cancelText: 'Cancel',
                continueText: 'Continue',
              );
            },
            child: const Text('Show Dialog'),
          ),
        ),
      ),
    );

    // Open the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Verify the dialog is visible
    expect(find.text('Test Title'), findsOneWidget);

    // Tap the cancel button
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Verify the dialog is closed and returned false
    expect(find.byType(AlertDialog), findsNothing);
    expect(result, isFalse);
  });
}
