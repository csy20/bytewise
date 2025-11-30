import 'package:bytewise/features/onboarding/providers/theme_provider.dart';
import 'package:bytewise/widgets/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Theme toggle switches to dark and persists', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              actions: [ThemeToggleButton()],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Open the popup menu
    await tester.tap(find.byType(ThemeToggleButton));
    await tester.pumpAndSettle();

    // Select Dark
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();

    expect(container.read(themeProvider).themeMode, ThemeMode.dark);
    expect(prefs.getString('theme_mode'), 'dark');
  });
}
