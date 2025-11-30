import 'package:flutter/material.dart';
import '../models/course_models.dart';
import '../services/content_loader.dart';

class CourseProvider extends ChangeNotifier {
  List<Course> _courses = [];
  bool _isLoading = true;
  String? _error;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCourses() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _courses = await ContentLoader.loadCourses();
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
