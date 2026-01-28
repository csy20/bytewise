import 'dart:async';
import 'package:flutter/material.dart';
import '../services/streak_service.dart';
import '../services/review_service.dart';
import 'review_dialog.dart';

/// Time-based streak counter widget.
/// - Starts countdown when app opens
/// - Auto-completes streak when timer hits zero
/// - Grey flame while counting, orange when done
class StreakCounter extends StatefulWidget {
  final StreakService streakService;
  final VoidCallback? onStreakUpdated;

  const StreakCounter({
    super.key,
    required this.streakService,
    this.onStreakUpdated,
  });

  @override
  State<StreakCounter> createState() => StreakCounterState();
}

class StreakCounterState extends State<StreakCounter> {
  bool _showTimeRemaining = false;
  Timer? _hideTimer;
  Timer? _countdownTimer;
  int _streakCount = 0;
  bool _completedToday = false;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initStreakSession();
  }

  Future<void> _initStreakSession() async {
    await widget.streakService.init();
    
    // Start session timer when widget loads
    await widget.streakService.startSession();
    
    _loadStreakData();
    
    // Update countdown every second for live countdown
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _checkCountdownAndUpdate();
      }
    });
  }

  void _loadStreakData() {
    if (mounted) {
      setState(() {
        _streakCount = widget.streakService.getStreakCount();
        _completedToday = widget.streakService.isCompletedToday();
        _timeRemaining = widget.streakService.getTimeRemaining();
      });
    }
  }

  Future<void> _checkCountdownAndUpdate() async {
    _timeRemaining = widget.streakService.getTimeRemaining();
    
    // Check if streak should complete
    if (!_completedToday && _timeRemaining.inSeconds <= 0) {
      final completed = await widget.streakService.checkAndCompleteStreak();
      if (completed) {
        // Show celebration!
        _completedToday = true;
        _streakCount = widget.streakService.getStreakCount();
        widget.onStreakUpdated?.call();
        
        // Show snackbar notification
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Text('🔥 ', style: TextStyle(fontSize: 20)),
                  Text('Streak completed! Day $_streakCount 🎉'),
                ],
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
          
          // Show review dialog after first streak completes
          if (_streakCount >= 1) {
            Future.delayed(const Duration(seconds: 2), () async {
              if (mounted) {
                final reviewService = ReviewService();
                await reviewService.init();
                if (reviewService.shouldAskForReview(1, _streakCount)) {
                  ReviewDialog.show(context, reviewService);
                }
              }
            });
          }
        }
      }
    }
    
    if (mounted) {
      setState(() {});
    }
  }

  /// Public method to refresh streak data
  void refreshStreak() {
    _loadStreakData();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _onTap() {
    setState(() {
      _showTimeRemaining = true;
    });
    
    // Cancel any existing timer
    _hideTimer?.cancel();
    
    // Hide after 3 seconds
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showTimeRemaining = false;
        });
      }
    });
  }

  String _getTimeRemainingText() {
    if (_completedToday) {
      return 'Done! ✓';
    }
    
    if (_timeRemaining.inSeconds <= 0) {
      return 'Complete!';
    }
    
    final minutes = _timeRemaining.inMinutes;
    final seconds = _timeRemaining.inSeconds % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    
    return '${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Flame is orange only when completed today
    final isFlameActive = _completedToday;
    
    // Text color based on theme
    final textColor = theme.colorScheme.onSurface;
    
    return GestureDetector(
      onTap: _onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Flame icon - grey while counting, orange when done
          Text(
            '🔥',
            style: TextStyle(
              fontSize: 20,
              color: isFlameActive ? Colors.orange : Colors.grey,
            ),
          ),
          const SizedBox(width: 4),
          // Streak count or time remaining
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _showTimeRemaining
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(
              '$_streakCount',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            secondChild: Text(
              _getTimeRemainingText(),
              style: TextStyle(
                color: _completedToday 
                    ? const Color(0xFF22C55E)  // Green for completed
                    : textColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Global key to access StreakCounter state for refreshing
class StreakCounterKey {
  static final GlobalKey<StreakCounterState> key = GlobalKey<StreakCounterState>();
  
  static void refresh() {
    key.currentState?.refreshStreak();
  }
}
