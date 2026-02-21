import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:core/core.dart';

enum ShortcutIcon { video, notes, tests, practice, doubts, schedule }

class Shortcut {
  final String id;
  final ShortcutIcon icon;
  final String label;

  const Shortcut({required this.id, required this.icon, required this.label});
}

/// A grid of shortcuts for quick navigation.
class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({
    super.key,
    required this.shortcuts,
    this.onShortcutTap,
  });

  final List<Shortcut> shortcuts;
  final ValueChanged<Shortcut>? onShortcutTap;

  @override
  Widget build(BuildContext context) {
    if (shortcuts.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: design.spacing.md,
        right: design.spacing.md,
        top: 32,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Quick Access',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
            color: design.colors.textPrimary,
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
            children: shortcuts
                .map(
                  (shortcut) => _ShortcutItem(
                    shortcut: shortcut,
                    onTap: () => onShortcutTap?.call(shortcut),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ShortcutItem extends StatelessWidget {
  const _ShortcutItem({required this.shortcut, this.onTap});
  final Shortcut shortcut;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final colors = _getColors(context);

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.bg,
                shape: BoxShape.circle,
              ),
              child: Center(child: _buildIcon(colors.text)),
            ),
            const SizedBox(height: 8),
            AppText.caption(
              shortcut.label,
              color: design.colors.textPrimary,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(Color color) {
    final iconData = switch (shortcut.icon) {
      ShortcutIcon.video => LucideIcons.playCircle,
      ShortcutIcon.notes => LucideIcons.fileText,
      ShortcutIcon.tests => LucideIcons.shieldCheck,
      ShortcutIcon.practice => LucideIcons.clipboardCheck,
      ShortcutIcon.doubts => Icons.live_help_outlined,
      ShortcutIcon.schedule => LucideIcons.calendar,
    };

    return Icon(iconData, size: 20, color: color);
  }

  ({Color bg, Color text}) _getColors(BuildContext context) {
    final baseColor = switch (shortcut.icon) {
      ShortcutIcon.video => const Color(0xFF9333EA), // Purple-600
      ShortcutIcon.notes => const Color(0xFF2563EB), // Blue-600
      ShortcutIcon.tests => const Color(0xFFEA580C), // Orange-600
      ShortcutIcon.practice => const Color(0xFF16A34A), // Green-600
      ShortcutIcon.doubts => const Color(0xFFE11D48), // Rose-600
      ShortcutIcon.schedule => const Color(0xFF0891B2), // Cyan-600
    };

    return (bg: baseColor.withValues(alpha: 0.1), text: baseColor);
  }
}
