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
    final modules = course.modules;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              modules.first.icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Text(
              course.title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;

            if (modules.isEmpty) {
              return const Center(child: Text('No modules available'));
            }

            Widget buildModuleHeader(Module module) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.icon,
                      style: textTheme.headlineMedium?.copyWith(
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      module.title,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              );
            }

            Widget buildLessons(Module module) {
              if (isWide) {
                return GridView.builder(
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
                );
              }

              return Column(
                children: module.lessons.asMap().entries.map((entry) {
                  return LessonTile(
                    lesson: entry.value,
                    lessonNumber: entry.key + 1,
                    module: module,
                  );
                }).toList(),
              );
            }

            final firstModule = modules.first;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // buildModuleHeader(firstModule), // Removed as per request
                buildLessons(firstModule),
                const SizedBox(height: 16),
                ...modules.skip(1).map((module) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildModuleHeader(module),
                      buildLessons(module),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
