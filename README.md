# ByteWise - Learning App

ByteWise is a Flutter-based learning application that provides structured courses on DSA (Data Structures & Algorithms), System Design, and Git/Version Control.

## Features

- **3-in-1 Learning Platform**: Access comprehensive courses on:
  - Data Structures & Algorithms in C++ (22 lessons)
  - System Design (22 lessons)
  - Git & Version Control (8 lessons)

- **Beautiful UI**: 
  - Dark theme with blue-green gradient design
  - Inspired by the ByteWise logo aesthetic
  - Smooth animations and transitions
  - Responsive Material Design 3

- **Rich Content Display**:
  - Markdown rendering for formatted content
  - Syntax-highlighted code blocks
  - Easy navigation between courses and lessons

## Architecture

The app follows Flutter best practices with a clean architecture:

```
lib/
├── models/
│   └── course_models.dart          # Data models for Course, Module, Lesson
├── screens/
│   ├── home_screen.dart            # Main course selection screen
│   ├── module_screen.dart          # Lesson list for a course
│   └── lesson_screen.dart          # Lesson content display
├── widgets/
│   ├── course_card.dart            # Course card component
│   └── lesson_tile.dart            # Lesson list item component
├── services/
│   ├── content_loader.dart         # Asset loading service
│   └── course_provider.dart        # State management with Provider
└── main.dart                       # App entry point
```

## Dependencies

- `flutter_markdown`: Render markdown content
- `provider`: State management
- `google_fonts`: Custom typography (Poppins font)

## Getting Started

### Prerequisites
- Flutter SDK (^3.5.2)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
2. Navigate to the project directory:
   ```bash
   cd bytewise
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Content Structure

All course content is stored in `assets/courses/`:
- `01.dsa/` - Data Structures & Algorithms lessons
- `02.system_design/` - System Design lessons  
- `03.git/` - Git & Version Control lessons

Content is loaded from markdown files and rendered with proper formatting.

## Design Principles

- **Minimalist & Modern**: Clean interface with plenty of spacing
- **Dark Theme**: Easy on the eyes with teal/blue-green accent colors
- **Accessibility**: High contrast text and readable fonts
- **Performance**: Efficient asset loading and smooth 60fps animations

## Screenshots

The app features:
- Home screen with course cards
- Module/lesson listing with numbered tiles
- Full lesson content with markdown rendering
- Gradient headers and beautiful color scheme

## Future Enhancements

- Progress tracking
- Bookmarks and favorites
- Search functionality
- Quiz/practice sections
- Offline mode
- Custom themes

## License

This project was created as an educational app for learning DSA, System Design, and Git.

## Credits

Course content sourced from the `dsa_cpp` repository.
