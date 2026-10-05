import 'package:flutter_test/flutter_test.dart';

import 'package:itp107_finals_lab1/main.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(const FlowPassApp());

    expect(find.text('Welcome back'), findsOneWidget);
  });
}
