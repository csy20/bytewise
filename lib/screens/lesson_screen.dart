import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_models.dart';
import '../utils/code_element_builder.dart';

class LessonScreen extends ConsumerWidget {
  final Lesson lesson;
  final Module module;
  final int lessonNumber;

  const LessonScreen({
    super.key,
    required this.lesson,
    required this.module,
    required this.lessonNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              'Lesson $lessonNumber',
              style: textTheme.bodyMedium,
            ),
            Text(
              lesson.title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Markdown(
          data: lesson.content,
          builders: {
            'code': CodeElementBuilder(),
          },
          styleSheet: MarkdownStyleSheet(
            h1: textTheme.headlineMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            h2: textTheme.titleLarge?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
            h3: textTheme.titleMedium?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
            p: textTheme.bodyLarge?.copyWith(
              height: 1.5,
            ),
            blockquote: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
            blockquoteDecoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(
                  color: colorScheme.primary,
                  width: 4,
                ),
              ),
            ),
            listBullet: TextStyle(
              color: colorScheme.primary,
            ),
            a: TextStyle(
              color: colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
