import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/course_models.dart';

class LessonScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Markdown(
                  data: lesson.content,
                  styleSheet: MarkdownStyleSheet(
                    h1: const TextStyle(
                      color: Color(0xFF00b4d8),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    h2: const TextStyle(
                      color: Color(0xFF48cae4),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    h3: const TextStyle(
                      color: Color(0xFF48cae4),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    p: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    code: const TextStyle(
                      color: Color(0xFF90e0ef),
                      backgroundColor: Color(0xFF263238),
                      fontFamily: 'monospace',
                    ),
                    codeblockDecoration: const BoxDecoration(
                      color: Color(0xFF263238),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    blockquote: const TextStyle(
                      color: Colors.white60,
                      fontStyle: FontStyle.italic,
                    ),
                    listBullet: const TextStyle(
                      color: Color(0xFF00b4d8),
                    ),
                    a: const TextStyle(
                      color: Color(0xFF00b4d8),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF00b4d8),
            Color(0xFF48cae4),
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lesson $lessonNumber',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
