import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'widget_test_harness.dart';

void main() {
  testWidgets('Counter increments when button is tapped', (WidgetTester tester) async {
    int counter = 0;

    await tester.pumpWidget(
      TestHarness(
        child: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Column(
              children: [
                Text('Count: $counter', key: Key('counterText')),
                ElevatedButton(
                  onPressed: () => setState(() => counter++),
                  child: Text('Increment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Count: 0'), findsOneWidget);
    await tester.tap(find.text('Increment'));
    await tester.pump();
    expect(find.text('Count: 1'), findsOneWidget);
  });
} 