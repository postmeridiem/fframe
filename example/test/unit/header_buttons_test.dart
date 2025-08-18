import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/helpers/header_buttons.dart';
import '../widget/widget_test_harness.dart';
import '../helpers/test_timing.dart';
import 'unit_test_harness.dart';

void main() {
  setupTiming(TestType.unit);
  
  group('Header Buttons', () {
    setUp(() {
      setupUnitTests();
    });

    timedGroup('BarButtonShare', () {
      timedTestWidgets('should render share button with correct icon and tooltip', (tester) async {
        await tester.pumpWidget(
          const TestHarness(
            child: Scaffold(
              body: BarButtonShare(),
            ),
          ),
        );

        // Verify IconButton is present
        expect(find.byType(IconButton), findsOneWidget);
        
        // Verify share icon is present
        expect(find.byIcon(Icons.share), findsOneWidget);
        
        // Verify tooltip - we can't easily test tooltip text in widget tests
        // but we can verify the button exists and has a tooltip
        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        expect(iconButton.tooltip, isNotNull);
        expect(iconButton.tooltip, contains('deeplink'));
      });

      timedTestWidgets('should be tappable', (tester) async {
        await tester.pumpWidget(
          const TestHarness(
            child: Scaffold(
              body: BarButtonShare(),
            ),
          ),
        );

        // Verify button can be tapped without throwing errors
        await tester.tap(find.byType(IconButton));
        await tester.pump();
        
        // The actual clipboard operation will fail in test environment,
        // but we can verify the button responds to taps
        expect(find.byType(IconButton), findsOneWidget);
      });

      timedTestWidgets('should have correct widget structure', (tester) async {
        await tester.pumpWidget(
          const TestHarness(
            child: BarButtonShare(),
          ),
        );

        // Verify widget hierarchy
        expect(find.byType(BarButtonShare), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
        expect(find.byIcon(Icons.share), findsOneWidget);
        
        // Verify onPressed callback exists
        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        expect(iconButton.onPressed, isNotNull);
      });
    });

    timedGroup('BarButtonDuplicate', () {
      timedTestWidgets('should render duplicate button with correct icon and tooltip', (tester) async {
        await tester.pumpWidget(
          const TestHarness(
            child: Scaffold(
              body: BarButtonDuplicate(),
            ),
          ),
        );

        // Verify IconButton is present
        expect(find.byType(IconButton), findsOneWidget);
        
        // Verify open_in_new icon is present
        expect(find.byIcon(Icons.open_in_new), findsOneWidget);
        
        // Verify tooltip exists and contains expected text
        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        expect(iconButton.tooltip, isNotNull);
        expect(iconButton.tooltip, contains('tab'));
      });

      timedTestWidgets('should be tappable', (tester) async {
        await tester.pumpWidget(
          const TestHarness(
            child: Scaffold(
              body: BarButtonDuplicate(),
            ),
          ),
        );

        // Verify button can be tapped without throwing errors
        await tester.tap(find.byType(IconButton));
        await tester.pump();
        
        // The actual URL launch will fail in test environment,
        // but we can verify the button responds to taps
        expect(find.byType(IconButton), findsOneWidget);
      });

      timedTestWidgets('should have correct widget structure', (tester) async {
        await tester.pumpWidget(
          const TestHarness(
            child: BarButtonDuplicate(),
          ),
        );

        // Verify widget hierarchy
        expect(find.byType(BarButtonDuplicate), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
        expect(find.byIcon(Icons.open_in_new), findsOneWidget);
        
        // Verify onPressed callback exists
        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        expect(iconButton.onPressed, isNotNull);
      });
    });

    timedGroup('BarButtonFeedback', () {
      timedTestWidgets('should render feedback button with correct icon and tooltip', (tester) async {
        await tester.pumpWidget(
          const TestHarness(
            child: Scaffold(
              body: BarButtonFeedback(),
            ),
          ),
        );

        // Verify IconButton is present
        expect(find.byType(IconButton), findsOneWidget);
        
        // Verify pest_control icon is present
        expect(find.byIcon(Icons.pest_control), findsOneWidget);
        
        // Verify tooltip exists and contains expected text
        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        expect(iconButton.tooltip, equals('Open issue tracker...'));
      });

      timedTestWidgets('should be tappable', (tester) async {
        await tester.pumpWidget(
          const TestHarness(
            child: Scaffold(
              body: BarButtonFeedback(),
            ),
          ),
        );

        // Verify button can be tapped without throwing errors
        await tester.tap(find.byType(IconButton));
        await tester.pump();
        
        // The actual URL launch will fail in test environment,
        // but we can verify the button responds to taps
        expect(find.byType(IconButton), findsOneWidget);
      });

      timedTestWidgets('should have correct widget structure', (tester) async {
        await tester.pumpWidget(
          const TestHarness(
            child: BarButtonFeedback(),
          ),
        );

        // Verify widget hierarchy
        expect(find.byType(BarButtonFeedback), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
        expect(find.byIcon(Icons.pest_control), findsOneWidget);
        
        // Verify onPressed callback exists
        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        expect(iconButton.onPressed, isNotNull);
      });
    });

    timedGroup('Widget Properties', () {
      timedTestWidgets('all buttons should have unique icons', (tester) async {
        await tester.pumpWidget(
          const TestHarness(
            child: Scaffold(
              body: Row(
                children: [
                  BarButtonShare(),
                  BarButtonDuplicate(), 
                  BarButtonFeedback(),
                ],
              ),
            ),
          ),
        );

        // Verify each button has its unique icon
        expect(find.byIcon(Icons.share), findsOneWidget);
        expect(find.byIcon(Icons.open_in_new), findsOneWidget);
        expect(find.byIcon(Icons.pest_control), findsOneWidget);
        
        // Verify we have exactly 3 IconButtons
        expect(find.byType(IconButton), findsNWidgets(3));
      });

      timedTestWidgets('all buttons should be StatelessWidgets', (tester) async {
        // Test widget types directly
        const shareButton = BarButtonShare();
        const duplicateButton = BarButtonDuplicate();
        const feedbackButton = BarButtonFeedback();
        
        expect(shareButton, isA<StatelessWidget>());
        expect(duplicateButton, isA<StatelessWidget>());
        expect(feedbackButton, isA<StatelessWidget>());
      });

      timedTest('widgets should have proper key handling', () {
        // Test key assignment
        const testKey = Key('test-button');
        
        const shareButton = BarButtonShare(key: testKey);
        const duplicateButton = BarButtonDuplicate(key: testKey);
        const feedbackButton = BarButtonFeedback(key: testKey);
        
        expect(shareButton.key, equals(testKey));
        expect(duplicateButton.key, equals(testKey));
        expect(feedbackButton.key, equals(testKey));
      });
    });

    timedGroup('Integration Tests', () {
      timedTestWidgets('buttons should work within app bar', (tester) async {
        await tester.pumpWidget(
          TestHarness(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Test App'),
                actions: const [
                  BarButtonShare(),
                  BarButtonDuplicate(),
                  BarButtonFeedback(),
                ],
              ),
              body: const Center(child: Text('Test Body')),
            ),
          ),
        );

        // Verify all buttons are present in the app bar
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(BarButtonShare), findsOneWidget);
        expect(find.byType(BarButtonDuplicate), findsOneWidget);
        expect(find.byType(BarButtonFeedback), findsOneWidget);
        
        // Verify all buttons are tappable
        await tester.tap(find.byType(BarButtonShare));
        await tester.pump();
        
        await tester.tap(find.byType(BarButtonDuplicate));
        await tester.pump();
        
        await tester.tap(find.byType(BarButtonFeedback));
        await tester.pump();
        
        // Should complete without errors
        expect(find.byType(AppBar), findsOneWidget);
      });

      timedTestWidgets('buttons should maintain state across rebuilds', (tester) async {
        Widget buildTestApp(String title) {
          return TestHarness(
            child: Scaffold(
              appBar: AppBar(
                title: Text(title),
                actions: const [
                  BarButtonShare(),
                  BarButtonDuplicate(),
                  BarButtonFeedback(),
                ],
              ),
            ),
          );
        }

        // Build initial widget
        await tester.pumpWidget(buildTestApp('Initial Title'));
        
        // Verify buttons exist
        expect(find.byType(BarButtonShare), findsOneWidget);
        expect(find.byType(BarButtonDuplicate), findsOneWidget);
        expect(find.byType(BarButtonFeedback), findsOneWidget);
        
        // Rebuild with different title
        await tester.pumpWidget(buildTestApp('Updated Title'));
        await tester.pump();
        
        // Verify buttons still exist and function
        expect(find.byType(BarButtonShare), findsOneWidget);
        expect(find.byType(BarButtonDuplicate), findsOneWidget);
        expect(find.byType(BarButtonFeedback), findsOneWidget);
        
        // Verify buttons are still tappable after rebuild
        await tester.tap(find.byType(BarButtonShare));
        await tester.pump();
        
        expect(find.text('Updated Title'), findsOneWidget);
      });
    });

    timedGroup('Error Handling', () {
      timedTestWidgets('buttons should handle rapid taps gracefully', (tester) async {
        await tester.pumpWidget(
          const TestHarness(
            child: Scaffold(
              body: Column(
                children: [
                  BarButtonShare(),
                  BarButtonDuplicate(),
                  BarButtonFeedback(),
                ],
              ),
            ),
          ),
        );

        // Rapidly tap all buttons multiple times
        for (int i = 0; i < 3; i++) {
          await tester.tap(find.byType(BarButtonShare));
          await tester.tap(find.byType(BarButtonDuplicate));
          await tester.tap(find.byType(BarButtonFeedback));
          await tester.pump(const Duration(milliseconds: 10));
        }
        
        // Should not cause any crashes or errors
        expect(find.byType(BarButtonShare), findsOneWidget);
        expect(find.byType(BarButtonDuplicate), findsOneWidget);
        expect(find.byType(BarButtonFeedback), findsOneWidget);
      });

      timedTestWidgets('buttons should handle scaffold context properly', (tester) async {
        // Test without scaffold (should not crash)
        await tester.pumpWidget(
          const TestHarness(
            child: Column(
              children: [
                BarButtonShare(),
                BarButtonDuplicate(),
                BarButtonFeedback(),
              ],
            ),
          ),
        );

        // Buttons should render even without Scaffold
        expect(find.byType(BarButtonShare), findsOneWidget);
        expect(find.byType(BarButtonDuplicate), findsOneWidget);
        expect(find.byType(BarButtonFeedback), findsOneWidget);
        
        // Tapping might not show snackbars but shouldn't crash
        await tester.tap(find.byType(BarButtonShare));
        await tester.pump();
        
        expect(find.byType(BarButtonShare), findsOneWidget);
      });
    });
  });
}