import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bytewise/features/onboarding/providers/preferences_provider.dart';

void main() {
  group('PreferencesProvider Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('should initialize with empty selected modules', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 200));

      final state = container.read(preferencesProvider);
      expect(state.selectedModules, isEmpty);
    });

    test('should toggle module selection', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 200));

      await container.read(preferencesProvider.notifier).toggleModule('dsa');

      var state = container.read(preferencesProvider);
      expect(state.selectedModules, contains('dsa'));

      await container.read(preferencesProvider.notifier).toggleModule('dsa');

      state = container.read(preferencesProvider);
      expect(state.selectedModules, isNot(contains('dsa')));
    });

    test('should select multiple modules', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 200));

      await container.read(preferencesProvider.notifier).toggleModule('dsa');
      await container.read(preferencesProvider.notifier).toggleModule('system_design');
      await container.read(preferencesProvider.notifier).toggleModule('git');

      final state = container.read(preferencesProvider);
      expect(state.selectedModules.length, 3);
      expect(state.selectedModules, containsAll(['dsa', 'system_design', 'git']));
    });

    test('should persist selected modules', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 200));

      await container.read(preferencesProvider.notifier).toggleModule('dsa');

      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('selected_modules');
      expect(saved, contains('dsa'));
    });

    test('should load persisted module preferences', () async {
      await SharedPreferences.getInstance();
      SharedPreferences.setMockInitialValues({
        'selected_modules': ['dsa', 'git']
      });

      final container = ProviderContainer();

      await Future.delayed(const Duration(milliseconds: 300));

      final state = container.read(preferencesProvider);
      expect(state.selectedModules.length, 2);
      expect(state.selectedModules, containsAll(['dsa', 'git']));
      
      container.dispose();
    });

    test('should set modules directly', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 200));

      await container
          .read(preferencesProvider.notifier)
          .setModules(['system_design', 'git']);

      final state = container.read(preferencesProvider);
      expect(state.selectedModules.length, 2);
      expect(state.selectedModules, containsAll(['system_design', 'git']));
    });
  });
}
