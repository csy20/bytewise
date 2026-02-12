import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/review_service.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? colorScheme.background
          : const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // About Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(
                  isDark ? 0.25 : 0.6,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hey there! 👋",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "I'm csy — a developer who got tired of scattered notes and half-baked tutorials. So I built ByteWise: a clean, offline-first companion that puts everything you need for DSA, system design, and competitive programming in one place.",
                    textAlign: TextAlign.left,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Every topic is broken down with intuitive mental models, real-world analogies, and ready-to-use C++ templates — designed so concepts click, not just stick.",
                    textAlign: TextAlign.left,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Whether you're prepping for placements, grinding contests, or just leveling up — ByteWise was made for you.",
                    textAlign: TextAlign.left,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.65),
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Social Media Section
            Text(
              'Connect with me',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            // Social Icons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialIcon(
                  icon: FontAwesomeIcons.linkedin,
                  label: null,
                  color: const Color(0xFF0A66C2),
                  onTap: () => _launchUrl('https://www.linkedin.com/in/csy20/'),
                ),
                const SizedBox(width: 16),
                SocialIcon(
                  icon: FontAwesomeIcons.github,
                  label: null,
                  color: isDark ? Colors.white : Colors.black87,
                  onTap: () => _launchUrl('https://github.com/csy20'),
                ),
                const SizedBox(width: 16),
                SocialIcon(
                  icon: FontAwesomeIcons.instagram,
                  label: null,
                  color: const Color(0xFFE4405F),
                  onTap: () => _launchUrl('https://www.instagram.com/the__csy20/'),
                ),
                const SizedBox(width: 16),
                SocialIcon(
                  icon: FontAwesomeIcons.xTwitter,
                  label: null,
                  color: isDark ? Colors.white : Colors.black87,
                  onTap: () => _launchUrl('https://x.com/the__csy20'),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'A follow doesn\'t cost much 😉',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),

            const SizedBox(height: 40),

            // Rate this app
            LinkTile(
              icon: Icons.star_outline_rounded,
              title: 'Rate this app',
              onTap: () => ReviewService().openStoreForReview(),
            ),

            const SizedBox(height: 32),

            // Legal Section
            Text(
              'Legal',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 12),

            LinkTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () => _launchUrl(
                'https://csy20.github.io/privacy_policy_bytewise/index.html',
              ),
            ),

            const SizedBox(height: 8),

            LinkTile(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              onTap: () => _launchUrl(
                'https://csy20.github.io/privacy_policy_bytewise/terms-and-conditions.html',
              ),
            ),

            const SizedBox(height: 40),

            // Version
            Text(
              'Version 1.0.10',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Social Media Icon Button
class SocialIcon extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color color;
  final VoidCallback onTap;

  const SocialIcon({
    super.key,
    required this.icon,
    this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(
              isDark ? 0.25 : 0.6,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: label != null
                ? Text(
                    label!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  )
                : Icon(
                    icon,
                    size: 24,
                    color: color,
                  ),
          ),
        ),
      ),
    );
  }
}

/// Reusable Link Tile for Legal Documents
class LinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const LinkTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(
              isDark ? 0.25 : 0.6,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.12),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
