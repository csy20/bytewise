import 'package:flutter/material.dart';
import '../models/course_models.dart';
import '../screens/module_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final totalLessons = _getTotalLessons();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListTile(
        leading: Text(
          course.modules.first.icon,
          style: const TextStyle(fontSize: 32),
        ),
        title: Text(course.title),
        subtitle: Text(course.description),
        trailing: Text('$totalLessons lessons'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModuleScreen(course: course),
            ),
          );
        },
      ),
    );
  }

  int _getTotalLessons() {
    return course.modules.fold(
      0,
      (total, module) => total + module.lessons.length,
    );
  }
}
