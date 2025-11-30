import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bytewise/features/onboarding/providers/theme_provider.dart';

void main() {
  group('ThemeProvider Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('should initialize with system theme mode', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 100));

      final themeNotifier = container.read(themeProvider);
      expect(themeNotifier.themeMode, ThemeMode.system);
    });

    test('should set and persist light theme', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 100));

      await container.read(themeProvider.notifier).setThemeMode(ThemeMode.light);

      final themeNotifier = container.read(themeProvider);
      expect(themeNotifier.themeMode, ThemeMode.light);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode'), 'light');
    });

    test('should set and persist dark theme', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 100));

      await container.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);

      final themeNotifier = container.read(themeProvider);
      expect(themeNotifier.themeMode, ThemeMode.dark);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode'), 'dark');
    });

    test('should load persisted theme preference', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 100));

      final themeNotifier = container.read(themeProvider);
      expect(themeNotifier.themeMode, ThemeMode.dark);
    });
  });
}
