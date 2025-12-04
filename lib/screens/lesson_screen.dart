import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_models.dart';
import '../providers/course_provider.dart';

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
    final contentAsync = ref.watch(lessonContentProvider(lesson.path));

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
        child: contentAsync.when(
          data: (content) => Markdown(
            data: content,
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
              code: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                backgroundColor: colorScheme.surfaceContainerHighest,
                fontFamily: 'monospace',
              ),
              codeblockDecoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              blockquote: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontStyle: FontStyle.italic,
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error loading lesson: $error')),
        ),
      ),
    );
  }
}
