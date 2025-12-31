import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'router/app_router.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: ByteWiseApp()));
}

class ByteWiseApp extends ConsumerWidget {
  const ByteWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider).themeMode;

    return MaterialApp.router(
      title: 'ByteWise',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      routerConfig: router,
    );
  }

  ThemeData _buildLightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF00b4d8),
      brightness: Brightness.light,
    );

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.light().textTheme,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: Colors.black.withOpacity(0.08),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7CE7F5),
      brightness: Brightness.dark,
    );

    final colorScheme = baseScheme.copyWith(
      background: const Color(0xFF0C111D),
      surface: const Color(0xFF111A2E),
      surfaceVariant: const Color(0xFF19233A),
      onBackground: const Color(0xFFE5ECFF),
      onSurface: const Color(0xFFE5ECFF),
      primaryContainer: const Color(0xFF123B52),
      secondary: const Color(0xFF9AE6B4),
      secondaryContainer: const Color(0xFF1C3B2C),
    );

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: colorScheme.background,
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: colorScheme.onBackground),
        titleTextStyle: GoogleFonts.poppins(
          color: colorScheme.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
