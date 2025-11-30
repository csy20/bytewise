import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_preferences.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/theme_provider.dart';

class PreferenceSelectionScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const PreferenceSelectionScreen({
    super.key,
    required this.onComplete,
  });

  @override
  ConsumerState<PreferenceSelectionScreen> createState() =>
      _PreferenceSelectionScreenState();
}

class _PreferenceSelectionScreenState
    extends ConsumerState<PreferenceSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedModules = ref.watch(preferencesProvider).selectedModules;
    final themeMode = ref.watch(themeProvider).themeMode;
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        final contentWidth = isWide ? 720.0 : double.infinity;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Semantics(
                          button: true,
                          label: 'Skip preference selection',
                          child: TextButton(
                            onPressed: widget.onComplete,
                            child: const Text(
                              'Skip for now',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Personalize Your Experience',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose what you want to learn',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Topics of Interest',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: availableModules.length,
                          padding: const EdgeInsets.only(bottom: 24),
                          itemBuilder: (context, index) {
                            final module = availableModules[index];
                            final isSelected = selectedModules.contains(module.id);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Semantics(
                                container: true,
                                selected: isSelected,
                                label: 'Topic: ${module.name}',
                                child: InkWell(
                                  onTap: () {
                                    ref
                                        .read(preferencesProvider.notifier)
                                        .toggleModule(module.id);
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                                          : colorScheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.outlineVariant,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? colorScheme.primary
                                                : colorScheme.surface,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: isSelected
                                                  ? colorScheme.onPrimary.withValues(alpha: 0.1)
                                                  : colorScheme.outlineVariant,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              module.icon,
                                              style: const TextStyle(fontSize: 28),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                module.name,
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                module.description,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      color: colorScheme.onSurface.withOpacity(0.7),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Checkbox(
                                          value: isSelected,
                                          onChanged: (_) {
                                            ref
                                                .read(preferencesProvider.notifier)
                                                .toggleModule(module.id);
                                          },
                                          activeColor: colorScheme.primary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Theme Preference',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _ThemeOptionCard(
                              icon: Icons.light_mode,
                              label: 'Light',
                              isSelected: themeMode == ThemeMode.light,
                              onTap: () {
                                ref.read(themeProvider.notifier).setThemeMode(ThemeMode.light);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ThemeOptionCard(
                              icon: Icons.dark_mode,
                              label: 'Dark',
                              isSelected: themeMode == ThemeMode.dark,
                              onTap: () {
                                ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ThemeOptionCard(
                              icon: Icons.settings_suggest,
                              label: 'System',
                              isSelected: themeMode == ThemeMode.system,
                              onTap: () {
                                ref.read(themeProvider.notifier).setThemeMode(ThemeMode.system);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Semantics(
                        button: true,
                        label: 'Continue to completion step',
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: widget.onComplete,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer.withValues(alpha: 0.4)
              : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
