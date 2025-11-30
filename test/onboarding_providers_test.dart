import 'package:bytewise/features/onboarding/providers/onboarding_provider.dart';
import 'package:bytewise/features/onboarding/providers/preferences_provider.dart';
import 'package:bytewise/features/onboarding/providers/theme_provider.dart';
import 'package:bytewise/features/onboarding/presentation/screens/preference_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('OnboardingNotifier respects stored completion', () async {
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await Future.delayed(const Duration(milliseconds: 10));

    expect(container.read(onboardingProvider).isCompleted, isTrue);
  });

  test('OnboardingNotifier completes and persists onboarding', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(onboardingProvider.notifier).completeOnboarding();
    final prefs = await SharedPreferences.getInstance();

    expect(container.read(onboardingProvider).isCompleted, isTrue);
    expect(prefs.getBool('onboarding_completed'), isTrue);
  });

  test('PreferencesNotifier toggles modules and persists', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(preferencesProvider.notifier).toggleModule('dsa');
    final prefs = await SharedPreferences.getInstance();

    expect(container.read(preferencesProvider).selectedModules, contains('dsa'));
    expect(prefs.getStringList('selected_modules'), contains('dsa'));
  });

  test('ThemeNotifier updates theme mode and persists', () async {
    final notifier = ThemeNotifier();
    await notifier.setThemeMode(ThemeMode.dark);
    final prefs = await SharedPreferences.getInstance();

    expect(notifier.themeMode, ThemeMode.dark);
    expect(prefs.getString('theme_mode'), 'dark');
  });

  testWidgets('PreferenceSelectionScreen skip triggers completion', (tester) async {
    SharedPreferences.setMockInitialValues({});
    var completed = false;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: PreferenceSelectionScreen(
            onComplete: () {
              completed = true;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip for now'));
    await tester.pumpAndSettle();

    expect(completed, isTrue);
  });

  testWidgets('PreferenceSelectionScreen toggles module selection and saves', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: PreferenceSelectionScreen(
            onComplete: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Data Structures & Algorithms'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('selected_modules'), contains('dsa'));
  });
}
