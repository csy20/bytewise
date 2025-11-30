import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences.dart';

class PreferencesNotifier extends StateNotifier<UserPreferences> {
  PreferencesNotifier() : super(const UserPreferences()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final modules = prefs.getStringList('selected_modules') ?? [];
    state = UserPreferences(selectedModules: modules);
  }

  Future<void> toggleModule(String moduleId) async {
    final modules = List<String>.from(state.selectedModules);
    if (modules.contains(moduleId)) {
      modules.remove(moduleId);
    } else {
      modules.add(moduleId);
    }
    state = state.copyWith(selectedModules: modules);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selected_modules', modules);
  }

  Future<void> setModules(List<String> modules) async {
    state = state.copyWith(selectedModules: modules);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selected_modules', modules);
  }
}

final preferencesProvider =
    StateNotifierProvider<PreferencesNotifier, UserPreferences>((ref) {
  return PreferencesNotifier();
});
