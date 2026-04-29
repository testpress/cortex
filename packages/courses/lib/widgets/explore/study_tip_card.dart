import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../explore_constants.dart';

class StudyTipCard extends StatelessWidget {
  const StudyTipCard({super.key, required this.tip});

  final StudyTipDto tip;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          AspectRatio(
            aspectRatio: ExploreConstants.cardAspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: design.radius.card.topLeft,
                topRight: design.radius.card.topRight,
              ),
              child: Image.network(
                tip.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: design.colors.surfaceVariant,
                  child: const Center(child: Icon(LucideIcons.fileText)),
                ),
              ),
            ),
          ),

          // Text Content
          Padding(
            padding: EdgeInsets.all(design.spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.cardTitle(
                  tip.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: design.spacing.xs),
                AppText.cardSubtitle(
                  tip.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: design.colors.textSecondary,
                ),
                SizedBox(height: design.spacing.md),
                if (tip.tag != null)
                  AppBadge(
                    label: tip.tag!,
                    backgroundColor: design.shortcutPalette
                        .atIndex(tip.colorIndex ?? 0)
                        .background,
                    foregroundColor: design.shortcutPalette
                        .atIndex(tip.colorIndex ?? 0)
                        .foreground,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
