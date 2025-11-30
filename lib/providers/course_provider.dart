import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_models.dart';
import '../services/content_loader.dart';

final courseProvider = FutureProvider<List<Course>>((ref) async {
  return await ContentLoader.loadCourses();
});

final courseListProvider = StateNotifierProvider<CourseListNotifier, AsyncValue<List<Course>>>((ref) {
  return CourseListNotifier();
});

class CourseListNotifier extends StateNotifier<AsyncValue<List<Course>>> {
  CourseListNotifier() : super(const AsyncValue.loading()) {
    loadCourses();
  }

  Future<void> loadCourses() async {
    state = const AsyncValue.loading();
    try {
      final courses = await ContentLoader.loadCourses();
      state = AsyncValue.data(courses);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadCourses();
  }
}
