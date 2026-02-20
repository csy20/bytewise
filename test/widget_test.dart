import 'package:bytewise/models/course_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Course models', () {
    test('Lesson holds title, fileName, and content', () {
      final lesson = Lesson(
        title: 'Intro',
        fileName: 'intro.md',
        content: '# Hello',
      );
      expect(lesson.title, 'Intro');
      expect(lesson.fileName, 'intro.md');
      expect(lesson.content, '# Hello');
    });

    test('Module contains a list of lessons', () {
      final module = Module(
        title: 'Basics',
        icon: '📘',
        lessons: [
          Lesson(title: 'L1', fileName: 'l1.md', content: ''),
          Lesson(title: 'L2', fileName: 'l2.md', content: ''),
        ],
      );
      expect(module.lessons.length, 2);
      expect(module.icon, '📘');
    });

    test('Course contains modules', () {
      final course = Course(
        title: 'DSA',
        description: 'Data Structures',
        modules: [
          Module(title: 'M1', icon: '📗', lessons: []),
        ],
      );
      expect(course.title, 'DSA');
      expect(course.modules.length, 1);
    });
  });
}
