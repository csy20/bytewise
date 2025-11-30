import 'package:flutter/material.dart';
import '../models/course_models.dart';
import '../widgets/lesson_tile.dart';

class ModuleScreen extends StatelessWidget {
  final Course course;

  const ModuleScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              course.description,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: course.modules.length,
              itemBuilder: (context, moduleIndex) {
                final module = course.modules[moduleIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        '${module.icon} ${module.title}',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    if (isWide)
                      GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 3.5,
                        ),
                        itemCount: module.lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = module.lessons[index];
                          return LessonTile(
                            lesson: lesson,
                            lessonNumber: index + 1,
                            module: module,
                          );
                        },
                      )
                    else
                      ...module.lessons.asMap().entries.map((entry) {
                        return LessonTile(
                          lesson: entry.value,
                          lessonNumber: entry.key + 1,
                          module: module,
                        );
                      }),
                    const SizedBox(height: 16),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
