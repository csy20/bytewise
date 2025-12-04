import 'package:bytewise/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ByteWise app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ByteWiseApp(),
      ),
    );
    
    await tester.pumpAndSettle();
    
    expect(find.text('ByteWise'), findsOneWidget);
  });
}
