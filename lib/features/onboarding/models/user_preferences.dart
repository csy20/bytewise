class UserPreferences {
  final List<String> selectedModules;

  const UserPreferences({
    this.selectedModules = const [],
  });

  UserPreferences copyWith({List<String>? selectedModules}) {
    return UserPreferences(
      selectedModules: selectedModules ?? this.selectedModules,
    );
  }
}

class Module {
  final String id;
  final String name;
  final String description;
  final String icon;

  const Module({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}

const List<Module> availableModules = [
  Module(
    id: 'dsa',
    name: 'Data Structures & Algorithms',
    description: 'Master DSA fundamentals',
    icon: '📊',
  ),
  Module(
    id: 'system_design',
    name: 'System Design',
    description: 'Learn to design scalable systems',
    icon: '🏗️',
  ),
  Module(
    id: 'git',
    name: 'Git & Version Control',
    description: 'Version control essentials',
    icon: '🔀',
  ),
];
