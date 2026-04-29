import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'study_tip_card.dart';
import '../../explore_constants.dart';

class StudyTipsList extends StatelessWidget {
  const StudyTipsList({super.key, required this.tips});

  final List<StudyTipDto> tips;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final l10n = L10n.of(context);

    if (tips.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.labelBold(
                l10n.exploreStudyTipsTitle.toUpperCase(),
                style: const TextStyle(
                  letterSpacing: ExploreConstants.sectionHeaderLetterSpacing,
                ),
              ),
              AppText.labelBold(
                l10n.viewAllAction,
                color: design.colors.textSecondary,
              ),
            ],
          ),
        ),
        SizedBox(height: design.spacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: Row(
            children: [
              for (final tip in tips)
                Padding(
                  padding: EdgeInsets.only(right: design.spacing.md),
                  child: SizedBox(
                    width: ExploreConstants.cardWidth,
                    child: StudyTipCard(tip: tip),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
