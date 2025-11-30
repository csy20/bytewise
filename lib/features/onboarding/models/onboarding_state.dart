class OnboardingState {
  final bool isCompleted;
  final int currentStep;

  const OnboardingState({
    this.isCompleted = false,
    this.currentStep = 0,
  });

  OnboardingState copyWith({
    bool? isCompleted,
    int? currentStep,
  }) {
    return OnboardingState(
      isCompleted: isCompleted ?? this.isCompleted,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
