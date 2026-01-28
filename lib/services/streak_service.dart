import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing time-based learning streak.
/// Streak starts when app opens, completes when countdown hits zero.
/// Each day user keeps app open for 10 minutes = 1 streak day.
class StreakService {
  static const String _streakCountKey = 'streak_count';
  static const String _lastCompletedDateKey = 'last_completed_date';
  static const String _sessionStartKey = 'session_start_time';
  
  // Duration required to complete a streak (10 minutes)
  static const Duration streakDuration = Duration(minutes: 10);

  SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get current streak count
  int getStreakCount() {
    _checkAndResetIfMissedDay();
    return _prefs?.getInt(_streakCountKey) ?? 0;
  }

  /// Get last completed date as DateTime (or null if never completed)
  DateTime? getLastCompletedDate() {
    final timestamp = _prefs?.getString(_lastCompletedDateKey);
    if (timestamp == null) return null;
    return DateTime.parse(timestamp);
  }

  /// Check if streak was completed today
  bool isCompletedToday() {
    final lastCompleted = getLastCompletedDate();
    if (lastCompleted == null) return false;
    
    final now = DateTime.now();
    return _isSameDay(lastCompleted, now);
  }

  /// Start a new session timer (call when app opens)
  Future<void> startSession() async {
    if (_prefs == null) await init();
    
    // Don't start new session if already completed today
    if (isCompletedToday()) return;
    
    // Start session timer
    await _prefs?.setString(_sessionStartKey, DateTime.now().toIso8601String());
  }

  /// Get session start time
  DateTime? getSessionStartTime() {
    final timestamp = _prefs?.getString(_sessionStartKey);
    if (timestamp == null) return null;
    return DateTime.parse(timestamp);
  }

  /// Get time remaining in current session until streak completes
  Duration getTimeRemaining() {
    if (isCompletedToday()) {
      return Duration.zero;
    }
    
    final sessionStart = getSessionStartTime();
    if (sessionStart == null) {
      return streakDuration;
    }
    
    final elapsed = DateTime.now().difference(sessionStart);
    final remaining = streakDuration - elapsed;
    
    if (remaining.isNegative) {
      return Duration.zero;
    }
    
    return remaining;
  }

  /// Check if current session has completed the streak
  /// Returns true if streak was just completed
  Future<bool> checkAndCompleteStreak() async {
    if (_prefs == null) await init();
    
    // Already completed today
    if (isCompletedToday()) return false;
    
    final remaining = getTimeRemaining();
    
    // Timer hit zero - complete streak!
    if (remaining.inSeconds <= 0) {
      return await _completeStreak();
    }
    
    return false;
  }

  /// Complete the streak for today
  Future<bool> _completeStreak() async {
    if (_prefs == null) await init();
    
    final now = DateTime.now();
    final lastCompleted = getLastCompletedDate();
    
    // Already completed today
    if (lastCompleted != null && _isSameDay(lastCompleted, now)) {
      return false;
    }
    
    int currentStreak = _prefs?.getInt(_streakCountKey) ?? 0;
    
    if (lastCompleted == null) {
      // First time - start streak at 1
      currentStreak = 1;
    } else {
      // Check if last completion was yesterday (consecutive day)
      final yesterday = now.subtract(const Duration(days: 1));
      final isConsecutive = _isSameDay(lastCompleted, yesterday);
      
      if (isConsecutive) {
        currentStreak += 1;
      } else {
        // Streak broken - but we're completing today, so start at 1
        currentStreak = 1;
      }
    }
    
    await _prefs?.setInt(_streakCountKey, currentStreak);
    await _prefs?.setString(_lastCompletedDateKey, now.toIso8601String());
    
    // Clear session timer
    await _prefs?.remove(_sessionStartKey);
    
    return true;
  }

  /// Check if streak needs to be reset (missed a day)
  void _checkAndResetIfMissedDay() {
    if (_prefs == null) return;
    
    final lastCompleted = getLastCompletedDate();
    if (lastCompleted == null) return;
    
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    
    // If last completion was not today and not yesterday, reset streak
    if (!_isSameDay(lastCompleted, now) && !_isSameDay(lastCompleted, yesterday)) {
      _prefs?.setInt(_streakCountKey, 0);
    }
  }

  /// Check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Get time until deadline (for backward compatibility)
  Duration getTimeUntilDeadline() {
    return getTimeRemaining();
  }

  /// Legacy method - now handled automatically
  Future<bool> completeLesson() async {
    return await checkAndCompleteStreak();
  }

  /// Reset streak (for testing)
  Future<void> resetStreak() async {
    if (_prefs == null) await init();
    await _prefs?.remove(_streakCountKey);
    await _prefs?.remove(_lastCompletedDateKey);
    await _prefs?.remove(_sessionStartKey);
  }
}
