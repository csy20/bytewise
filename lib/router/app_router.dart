import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/onboarding/providers/onboarding_provider.dart';
import '../screens/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingState = ref.watch(onboardingProvider);

  return GoRouter(
    initialLocation: onboardingState.isCompleted ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    redirect: (context, state) {
      final isOnboarded = onboardingState.isCompleted;
      final isOnOnboardingPage = state.matchedLocation == '/onboarding';

      if (!isOnboarded && !isOnOnboardingPage) {
        return '/onboarding';
      }

      if (isOnboarded && isOnOnboardingPage) {
        return '/home';
      }

      return null;
    },
  );
});
