import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for handling app reviews and developer social links.
/// Policy-compliant: uses official APIs, rate-limited, non-intrusive.
class ReviewService {
  static const String _lastReviewRequestKey = 'last_review_request';
  static const String _celebrationCardShownKey = 'celebration_card_shown';
  static const String _lessonsCompletedKey = 'lessons_completed_count';
  
  static const String developerTwitterUrl = 'https://x.com/the__csy20';
  
  // Minimum days between review requests
  static const int _minDaysBetweenRequests = 30;
  
  // Criteria for review request
  static const int _minStreakForReview = 2;

  SharedPreferences? _prefs;
  final InAppReview _inAppReview = InAppReview.instance;

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get total lessons completed
  int getLessonsCompleted() {
    return _prefs?.getInt(_lessonsCompletedKey) ?? 0;
  }

  /// Increment lessons completed count
  Future<void> incrementLessonsCompleted() async {
    if (_prefs == null) await init();
    final current = getLessonsCompleted();
    await _prefs?.setInt(_lessonsCompletedKey, current + 1);
  }

  /// Check if celebration card has been shown
  bool hasCelebrationCardBeenShown() {
    return _prefs?.getBool(_celebrationCardShownKey) ?? false;
  }

  /// Mark celebration card as shown
  Future<void> markCelebrationCardShown() async {
    if (_prefs == null) await init();
    await _prefs?.setBool(_celebrationCardShownKey, true);
  }

  /// Check if we should show the 3-day streak celebration card
  bool shouldShowCelebrationCard(int streakDays) {
    if (hasCelebrationCardBeenShown()) return false;
    return streakDays >= 3;
  }

  /// Check if we should ask for a review based on streak count
  bool shouldAskForReview(int lessonsCompleted, int streakDays) {
    // Review appears after 2+ streaks
    if (streakDays < _minStreakForReview) return false;
    
    // Check if 30 days have passed since last request
    final lastRequest = _prefs?.getString(_lastReviewRequestKey);
    if (lastRequest != null) {
      final lastDate = DateTime.parse(lastRequest);
      final daysSince = DateTime.now().difference(lastDate).inDays;
      if (daysSince < _minDaysBetweenRequests) return false;
    }
    
    return true;
  }

  /// Request an in-app review using the native OS dialog
  Future<void> requestReview() async {
    if (_prefs == null) await init();
    
    try {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
        // Record the request timestamp
        await _prefs?.setString(
          _lastReviewRequestKey,
          DateTime.now().toIso8601String(),
        );
      }
    } catch (e) {
      // Silently fail - don't disrupt user experience
      print('Review request failed: $e');
    }
  }

  /// Open developer Twitter/X page in external browser
  Future<bool> openDeveloperTwitter() async {
    final uri = Uri.parse(developerTwitterUrl);
    try {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print('Could not launch $developerTwitterUrl: $e');
      return false;
    }
  }

  /// Open app store page for review (fallback)
  Future<void> openStoreForReview() async {
    try {
      await _inAppReview.openStoreListing();
    } catch (e) {
      print('Could not open store listing: $e');
    }
  }
}
