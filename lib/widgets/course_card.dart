import 'package:flutter/material.dart';
import '../models/course_models.dart';
import '../screens/module_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final int index;

  const CourseCard({
    super.key,
    required this.course,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      color: colorScheme.surface,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModuleScreen(course: course),
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.6,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                course.modules.isNotEmpty ? course.modules.first.icon : '📚',
                style: const TextStyle(fontSize: 34),
              ),
              const SizedBox(height: 14),
              Text(
                _formatLabel(),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatLabel() {
    final number = index.toString().padLeft(2, '0');
    final shortTitle = course.title.split(' ').first.toLowerCase();
    return '$number.$shortTitle';
  }
}
