import 'package:flutter_test/flutter_test.dart';

import 'package:bytewise/main.dart';

void main() {
  testWidgets('ByteWise app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ByteWiseApp());
    
    await tester.pumpAndSettle();
    
    expect(find.text('ByteWise'), findsOneWidget);
  });
}
