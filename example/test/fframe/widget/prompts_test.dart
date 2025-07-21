import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/helpers/prompts.dart';
import '../widget_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Prompts', () {
    testWidgets('promptOK should build and display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHarness(
          child: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  promptOK(
                    context: context,
                    title: 'Test Title',
                    message: 'Test Message',
                  );
                },
                child: const Text('Show OK Prompt'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show OK Prompt'));
      await tester.pumpAndSettle();

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Message'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('promptOKCancel should build and display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHarness(
          child: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  promptOKCancel(
                    context: context,
                    title: 'Test Title',
                    message: 'Test Message',
                  );
                },
                child: const Text('Show OK/Cancel Prompt'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show OK/Cancel Prompt'));
      await tester.pumpAndSettle();

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Message'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}
