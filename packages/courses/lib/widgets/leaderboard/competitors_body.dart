import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'competitor_list_item.dart';
import 'leaderboard_list_item.dart';

class CompetitorsBody extends StatelessWidget {
  const CompetitorsBody({
    super.key,
    required this.competitors,
    this.isLoading = false,
    this.hasError = false,
  });

  final List<LearnerDto> competitors;
  final bool isLoading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Padding(
      padding: EdgeInsets.all(design.spacing.md),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.circular(24),
            boxShadow: design.shadows.surfaceSoft,
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) {
                  if (hasError) {
                    return Padding(
                      padding: EdgeInsets.all(design.spacing.lg),
                      child: Center(
                        child: AppText.body(
                            l10n.leaderboardErrorLoadingCompetitors,
                            color: design.colors.error),
                      ),
                    );
                  }
                  if (!isLoading && competitors.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(design.spacing.lg),
                      child: Center(
                        child: AppText.body(l10n.leaderboardNoCompetitorsFound,
                            color: design.colors.textSecondary),
                      ),
                    );
                  }

                  final displayCompetitors =
                      isLoading ? _mockCompetitors : competitors;

                  return Skeletonizer(
                    enabled: isLoading,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: displayCompetitors.length,
                      separatorBuilder: (_, __) =>
                          RowDivider(color: design.colors.divider),
                      itemBuilder: (context, index) {
                        return CompetitorListItem(
                            learner: displayCompetitors[index]);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _mockCompetitors = List.generate(
  5,
  (index) => LearnerDto(
    id: 'skeleton_$index',
    rank: index + 1,
    name: BoneMock.name,
    avatar: '',
    points: 1000 - (index * 10),
    coursesCompleted: 5,
    streakDays: 3,
  ),
);
