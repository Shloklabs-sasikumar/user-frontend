// test/counter_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Counter increments smoke test", (WidgetTester tester) async {
    // Build the Counter widget.
    await tester.pumpWidget(MaterialApp(home: Counter()));

    // Verify that the initial counter text is "Count: 0".
    expect(find.text("Count: 0"), findsOneWidget);
    expect(find.text("Count: 1"), findsNothing);

    // Tap the increment button and trigger a frame.
    await tester.tap(find.byKey(Key("incrementButton")));
    await tester.pump(); // Rebuild the widget after the state has changed.

    // Verify that the counter text has incremented to "Count: 1".
    expect(find.text("Count: 0"), findsNothing);
    expect(find.text("Count: 1"), findsOneWidget);
  });
}


class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;

  void _incrementCounter() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Counter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Count: $_count", key: Key("counterText")),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text("Increment"),
              key: Key("incrementButton"),
            ),
          ],
        ),
      ),
    );
  }
}
