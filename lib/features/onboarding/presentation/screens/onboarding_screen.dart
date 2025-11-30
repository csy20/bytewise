import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/welcome_carousel.dart';
import 'preference_selection_screen.dart';
import '../../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void _skipToPreferences() {
    setState(() {
      _currentStep = 1;
    });
  }

  void _completeOnboarding() {
    ref.read(onboardingProvider.notifier).completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _buildCurrentStep(),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return WelcomeCarousel(
          key: const ValueKey('carousel'),
          onComplete: _nextStep,
          onSkip: _skipToPreferences,
        );
      case 1:
        return PreferenceSelectionScreen(
          key: const ValueKey('preferences'),
          onComplete: _completeOnboarding,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
