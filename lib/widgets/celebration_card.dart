import 'package:flutter/material.dart';
import '../services/review_service.dart';

/// Celebration card shown after user achieves 3-day streak (one time only).
/// Includes review and follow developer options.
class CelebrationCard extends StatelessWidget {
  final VoidCallback onDismiss;
  final ReviewService reviewService;

  const CelebrationCard({
    super.key,
    required this.onDismiss,
    required this.reviewService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with dismiss button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🔥 3-day streak!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                icon: Icon(
                  Icons.close,
                  color: colorScheme.onSurface.withAlpha(180),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Text(
            "You're on fire! Keep up the great work.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withAlpha(200),
            ),
          ),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            'Enjoying ByteWise? Support the developer:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withAlpha(160),
            ),
          ),
          const SizedBox(height: 12),

          // Action buttons
          Row(
            children: [
              // Review button
              Expanded(
                child: _ActionButton(
                  icon: '⭐',
                  label: 'Rate App',
                  onTap: () async {
                    await reviewService.requestReview();
                    onDismiss();
                  },
                  isPrimary: true,
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              // Twitter button
              Expanded(
                child: _ActionButton(
                  icon: '𝕏',
                  label: 'Follow',
                  onTap: () async {
                    await reviewService.openDeveloperTwitter();
                    onDismiss();
                  },
                  isPrimary: false,
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final ColorScheme colorScheme;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isPrimary,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary 
          ? colorScheme.primary 
          : colorScheme.surface.withAlpha(200),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                icon,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary 
                      ? colorScheme.onPrimary 
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
