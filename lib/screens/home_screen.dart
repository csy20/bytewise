import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/update_wrapper.dart';
import '../widgets/streak_counter_widget.dart';
import '../services/streak_service.dart';
import 'about_screen.dart';

/// Global StreakService instance
final streakServiceProvider = Provider<StreakService>((ref) => StreakService());

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late StreakService _streakService;
  late AnimationController _chevronController;
  late Animation<double> _chevronAnimation;

  @override
  void initState() {
    super.initState();
    _streakService = ref.read(streakServiceProvider);
    _initStreak();

    // Gentle pulsing animation for the edge chevron
    _chevronController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _chevronAnimation = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(
        parent: _chevronController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _chevronController.dispose();
    super.dispose();
  }

  Future<void> _initStreak() async {
    await _streakService.init();
    setState(() {});
  }

  void _onStreakUpdated() {
    setState(() {});
  }

  /// Opens AboutScreen with a smooth slide-from-right transition
  void _openAbout() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AboutScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuart,
          );

          final offsetTween = Tween<Offset>(
            begin: const Offset(0.3, 0.0),
            end: Offset.zero,
          );

          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: offsetTween.animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(courseListProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return UpdateWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ByteWise'),
          actions: [
            StreakCounter(
              key: StreakCounterKey.key,
              streakService: _streakService,
              onStreakUpdated: _onStreakUpdated,
            ),
            const ThemeToggleButton(),
            const SizedBox(width: 8),
          ],
        ),
        body: Stack(
          children: [
            // Main content with swipe gesture
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null &&
                    details.primaryVelocity! < -300) {
                  _openAbout();
                }
              },
              child: coursesAsync.when(
                data: (courses) {
                  if (courses.isEmpty) {
                    return const Center(
                      child: Text('No courses available'),
                    );
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 2;
                      if (constraints.maxWidth >= 900) {
                        crossAxisCount = 4;
                      } else if (constraints.maxWidth >= 600) {
                        crossAxisCount = 3;
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: courses.length,
                        itemBuilder: (context, index) => CourseCard(
                          course: courses[index],
                          index: index + 1,
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(courseListProvider.notifier).refresh();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Right-edge "about" tab indicator
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _openAbout,
                child: Align(
                  alignment: const Alignment(0, 0.35),
                  child: AnimatedBuilder(
                    animation: _chevronAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_chevronAnimation.value, 0),
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chevron_left_rounded,
                            size: 16,
                            color: colorScheme.primary.withOpacity(0.6),
                          ),
                          const SizedBox(height: 4),
                          RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              'about',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary.withOpacity(0.6),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
