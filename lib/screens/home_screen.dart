import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/update_wrapper.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(courseListProvider);

    return UpdateWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ByteWise'),
          actions: const [
            ThemeToggleButton(),
            SizedBox(width: 8),
          ],
        ),
        body: coursesAsync.when(
          data: (courses) {
            if (courses.isEmpty) {
              return const Center(
                child: Text('No courses available'),
              );
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                // Responsive column count based on width
                int crossAxisCount = 2; // default for phones
                if (constraints.maxWidth >= 900) {
                  crossAxisCount = 4; // large tablets
                } else if (constraints.maxWidth >= 600) {
                  crossAxisCount = 3; // small tablets
                }
                
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}
