import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/lesson_content.dart';

/// Renders a hierarchical heading within a lesson.
class LessonHeading extends StatelessWidget {
  const LessonHeading({super.key, required this.text, this.level = 2});

  /// The text content of the heading.
  final String text;

  /// The hierarchical level (1-3).
  final int level;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    // Select appropriate typographic style based on hierarchical level.
    final style = switch (level) {
      1 => design.typography.display.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      3 => design.typography.title.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      _ => design.typography.headline.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    };

    return Padding(
      padding: EdgeInsets.only(
        top: design.spacing.lg,
        bottom: design.spacing.md,
      ),
      child: Text(text, style: style),
    );
  }
}

/// Renders a standard block of text within a lesson with optimized readability.
class LessonParagraph extends StatelessWidget {
  const LessonParagraph({super.key, required this.text});

  /// The raw text of the paragraph.
  final String text;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.md),
      child: AppText.body(
        text,
        color: design.colors.textSecondary, // Slate-700 equivalent
      ),
    );
  }
}

/// Renders a semantic callout/info box with specific color coding and icons.
class LessonCallout extends StatelessWidget {
  const LessonCallout({super.key, required this.text, required this.type});

  /// The message within the callout.
  final String text;

  /// The semantic type (note, tip, warning, example).
  final CalloutType type;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    // Choose visual palette and icon based on callout type.
    final (bgColor, borderColor, textColor, icon) = switch (type) {
      CalloutType.note => (
        design.colors.accent2.withValues(alpha: 0.1),
        design.colors.accent2.withValues(alpha: 0.2),
        design.colors.accent2,
        LucideIcons.lightbulb,
      ),
      CalloutType.tip => (
        design.colors.accent4.withValues(alpha: 0.1),
        design.colors.accent4.withValues(alpha: 0.2),
        design.colors.accent4,
        LucideIcons.sparkles,
      ),
      CalloutType.warning => (
        design.colors.accent3.withValues(alpha: 0.1),
        design.colors.accent3.withValues(alpha: 0.2),
        design.colors.accent3,
        LucideIcons.alertTriangle,
      ),
      CalloutType.example => (
        design.colors.accent1.withValues(alpha: 0.1),
        design.colors.accent1.withValues(alpha: 0.2),
        design.colors.accent1,
        LucideIcons.fileText,
      ),
    };

    return Container(
      margin: EdgeInsets.only(bottom: design.spacing.md),
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(design.radius.lg),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: textColor),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: AppText.bodySmall(
              text,
              // Darken text slightly for better accessibility on light backgrounds
              color: textColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders a lesson illustrative image with rounded corners and loading states.
class LessonImage extends StatelessWidget {
  const LessonImage({super.key, required this.imageUrl, this.altText});

  /// Remote URL for the image.
  final String imageUrl;

  /// Optional accessibility label.
  final String? altText;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: design.spacing.lg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(design.radius.lg),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: design.colors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            semanticLabel: altText,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 200,
                width: double.infinity,
                color: design.colors.surface,
                child: const Center(child: AppLoadingIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 120,
                width: double.infinity,
                color: design.colors.surface,
                child: Center(
                  child: Icon(
                    LucideIcons.image,
                    color: design.colors.textTertiary,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Renders a bulleted list of items with subject-specific bullet styling.
class LessonList extends StatelessWidget {
  const LessonList({super.key, required this.items, this.bulletColor});

  /// The list of strings to render as bullet points.
  final List<String> items;

  /// Custom color for the bullets.
  final Color? bulletColor;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final color = bulletColor ?? design.colors.primary;

    return Padding(
      padding: EdgeInsets.only(
        bottom: design.spacing.md,
        left: design.spacing.xs,
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: design.spacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 4.0,
                    right: 12.0,
                  ),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: color.withValues(alpha: 0.4)),
                    ),
                  ),
                ),
                Expanded(
                  child: AppText.body(item, color: design.colors.textSecondary),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
