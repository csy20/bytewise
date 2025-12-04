import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    final mode = themeNotifier.themeMode;

    return IconButton(
      onPressed: () {
        final newMode = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
        ref.read(themeProvider.notifier).setThemeMode(newMode);
      },
      icon: Icon(
        mode == ThemeMode.light ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
      ),
      tooltip: 'Toggle theme',
    );
  }
}

