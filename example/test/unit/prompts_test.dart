import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/helpers/prompts.dart';
import '../widget/widget_test_harness.dart';
import '../helpers/test_timing.dart';

void main() {
  setupTiming(TestType.unit);
  
  group('Prompts', () {
    timedGroup('promptOK', () {
      timedTestWidgets('should display dialog with correct title and message', (tester) async {
        const testTitle = 'Test Title';
        const testMessage = 'This is a test message';
        
        await tester.pumpWidget(
          TestHarness(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => promptOK(context, testTitle, testMessage),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        // Tap button to show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog appears
        expect(find.byType(AlertDialog), findsOneWidget);
        
        // Verify title is displayed
        expect(find.text(testTitle), findsOneWidget);
        
        // Verify message is displayed
        expect(find.text(testMessage), findsOneWidget);
        
        // Verify additional text is displayed
        expect(find.text('Would you like to approve of this message?'), findsOneWidget);
        
        // Verify button is displayed
        expect(find.text('I do!'), findsOneWidget);
      });

      timedTestWidgets('should dismiss dialog when button is tapped', (tester) async {
        const testTitle = 'Test Title';
        const testMessage = 'Test Message';
        
        await tester.pumpWidget(
          TestHarness(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => promptOK(context, testTitle, testMessage),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        // Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is present
        expect(find.byType(AlertDialog), findsOneWidget);

        // Tap the "I do!" button
        await tester.tap(find.text('I do!'));
        await tester.pumpAndSettle();

        // Verify dialog is dismissed
        expect(find.byType(AlertDialog), findsNothing);
      });

      timedTestWidgets('should handle empty title and message', (tester) async {
        const emptyTitle = '';
        const emptyMessage = '';
        
        await tester.pumpWidget(
          TestHarness(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => promptOK(context, emptyTitle, emptyMessage),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        // Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog still appears even with empty strings
        expect(find.byType(AlertDialog), findsOneWidget);
        
        // The dialog should still show the standard text
        expect(find.text('Would you like to approve of this message?'), findsOneWidget);
        expect(find.text('I do!'), findsOneWidget);
      });

      timedTestWidgets('should handle long title and message', (tester) async {
        const longTitle = 'This is a very long title that should still display correctly in the dialog widget without causing any issues';
        const longMessage = 'This is a very long message that contains multiple sentences and should wrap properly within the dialog content area. It should be scrollable if needed and maintain proper formatting throughout the entire text content.';
        
        await tester.pumpWidget(
          TestHarness(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => promptOK(context, longTitle, longMessage),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        // Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog appears
        expect(find.byType(AlertDialog), findsOneWidget);
        
        // Verify long content is displayed (partial match since it might wrap)
        expect(find.textContaining('This is a very long title'), findsOneWidget);
        expect(find.textContaining('This is a very long message'), findsOneWidget);
      });

      timedTestWidgets('should have correct dialog structure', (tester) async {
        const testTitle = 'Test Title';
        const testMessage = 'Test Message';
        
        await tester.pumpWidget(
          TestHarness(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => promptOK(context, testTitle, testMessage),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        // Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog structure
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(ListBody), findsOneWidget);
        expect(find.byType(TextButton), findsOneWidget);
      });

      timedTestWidgets('should be barrier dismissible false', (tester) async {
        const testTitle = 'Test Title';
        const testMessage = 'Test Message';
        
        await tester.pumpWidget(
          TestHarness(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => promptOK(context, testTitle, testMessage),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        // Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is present
        expect(find.byType(AlertDialog), findsOneWidget);

        // Try to tap outside the dialog (this should not dismiss it)
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Dialog should still be present (barrierDismissible: false)
        expect(find.byType(AlertDialog), findsOneWidget);
      });

      timedTest('should have correct function signature', () {
        // This test verifies the function signature and type
        // We test that the function exists and has the expected signature
        
        // Test that promptOK is a function with the expected signature
        expect(promptOK, isA<Function>());
        
        // The function should accept (dynamic context, String title, String message)
        // and return Future<void>
        // We can't call it without proper context but can verify it compiles
        const dynamic mockContext = 'not_a_context';
        
        // This will fail but proves the function signature is correct
        expect(
          () => promptOK(mockContext, 'title', 'message'),
          throwsA(isA<TypeError>()),
        );
      });
    });

    timedGroup('Dialog Interaction Edge Cases', () {
      timedTestWidgets('should handle rapid button taps gracefully', (tester) async {
        const testTitle = 'Rapid Tap Test';
        const testMessage = 'Test rapid tapping';
        
        await tester.pumpWidget(
          TestHarness(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => promptOK(context, testTitle, testMessage),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        // Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Rapidly tap the button multiple times
        await tester.tap(find.text('I do!'));
        await tester.tap(find.text('I do!'));
        await tester.pump();

        // Should not cause any errors and dialog should be dismissed
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
      });

      timedTestWidgets('should handle special characters in title and message', (tester) async {
        const specialTitle = 'Title with "quotes" & symbols: @#\$%^&*()';
        const specialMessage = 'Message with\nnewlines and\ttabs & émojis 🎉';
        
        await tester.pumpWidget(
          TestHarness(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => promptOK(context, specialTitle, specialMessage),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        // Show dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog appears and handles special characters
        expect(find.byType(AlertDialog), findsOneWidget);
        
        // Check for partial content (special characters might be rendered differently)
        expect(find.textContaining('quotes'), findsOneWidget);
        expect(find.textContaining('newlines'), findsOneWidget);
      });
    });
  });
}