class Lesson {
  final String title;
  final String fileName;
  final String? content;
  final String path;

  Lesson({
    required this.title,
    required this.fileName,
    this.content,
    required this.path,
  });
}

class Module {
  final String title;
  final String icon;
  final List<Lesson> lessons;

  Module({
    required this.title,
    required this.icon,
    required this.lessons,
  });
}

class Course {
  final String title;
  final String description;
  final List<Module> modules;

  Course({
    required this.title,
    required this.description,
    required this.modules,
  });
}
