import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'services/course_provider.dart';

void main() {
  runApp(const ByteWiseApp());
}

class ByteWiseApp extends StatelessWidget {
  const ByteWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CourseProvider()..loadCourses(),
      child: MaterialApp(
        title: 'ByteWise',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00b4d8),
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData.dark().textTheme,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF1a1a2e),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
