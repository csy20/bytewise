import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bytewise/features/onboarding/providers/onboarding_provider.dart';

void main() {
  group('OnboardingProvider Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('should initialize with isCompleted as false', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 200));

      final state = container.read(onboardingProvider);
      expect(state.isCompleted, false);
      expect(state.currentStep, 0);
    });

    test('should complete onboarding and persist state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 200));

      await container.read(onboardingProvider.notifier).completeOnboarding();

      final state = container.read(onboardingProvider);
      expect(state.isCompleted, true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('onboarding_completed'), true);
    });

    test('should update current step', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 200));

      container.read(onboardingProvider.notifier).updateStep(2);

      final state = container.read(onboardingProvider);
      expect(state.currentStep, 2);
    });

    test('should reset onboarding', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 200));

      await container.read(onboardingProvider.notifier).completeOnboarding();
      await container.read(onboardingProvider.notifier).resetOnboarding();

      final state = container.read(onboardingProvider);
      expect(state.isCompleted, false);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('onboarding_completed'), false);
    });

    test('should load persisted onboarding state', () async {
      await SharedPreferences.getInstance();
      SharedPreferences.setMockInitialValues({'onboarding_completed': true});

      final container = ProviderContainer();
      
      await Future.delayed(const Duration(milliseconds: 300));

      final state = container.read(onboardingProvider);
      expect(state.isCompleted, true);
      
      container.dispose();
    });
  });
}
