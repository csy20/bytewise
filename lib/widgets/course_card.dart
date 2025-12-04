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
    final icon = course.modules.isNotEmpty ? course.modules.first.icon : '📚';
    final label = _formatLabel();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
