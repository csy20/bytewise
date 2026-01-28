import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/review_service.dart';

/// Custom review dialog with "csy😎: Review, Buddy?" phrase.
/// Shows star rating, review option, and Twitter follow link.
class ReviewDialog extends StatefulWidget {
  final ReviewService reviewService;

  const ReviewDialog({
    super.key,
    required this.reviewService,
  });

  /// Show the review dialog
  static Future<void> show(BuildContext context, ReviewService reviewService) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ReviewDialog(reviewService: reviewService),
    );
  }

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  int _selectedRating = 0;
  bool _isSubmitting = false;

  Future<void> _submitRating() async {
    if (_selectedRating == 0) return;
    
    setState(() => _isSubmitting = true);
    
    // If rating is 4 or 5, request native review
    if (_selectedRating >= 4) {
      await widget.reviewService.requestReview();
    }
    
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _selectedRating >= 4 
                ? 'Thanks for your support! 💙' 
                : 'Thanks for your feedback!',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _openTwitter() async {
    final uri = Uri.parse('https://x.com/the__csy20');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '📚',
                style: TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 20),

            // Title with custom phrase
            Text(
              'csy😎: Review, Buddy?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Tap a star to rate ByteWise',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withAlpha(180),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Divider
            Divider(
              color: colorScheme.outline.withAlpha(50),
              height: 1,
            ),
            const SizedBox(height: 20),

            // Star rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return GestureDetector(
                  onTap: () => setState(() => _selectedRating = starIndex),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      _selectedRating >= starIndex
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 40,
                      color: _selectedRating >= starIndex
                          ? Colors.amber
                          : (isDark ? Colors.grey[600] : Colors.grey[400]),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Submit button (shows when stars selected)
            if (_selectedRating > 0) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitRating,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Twitter follow button
            TextButton.icon(
              onPressed: _openTwitter,
              icon: const Text('𝕏', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              label: const Text('Follow @the__csy20'),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurface.withAlpha(200),
              ),
            ),

            // Not Now button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Not Now',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
