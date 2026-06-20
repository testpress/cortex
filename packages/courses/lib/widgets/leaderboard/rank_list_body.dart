import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'leaderboard_list_item.dart';
import 'timeline_chip.dart';

class RankListBody extends StatelessWidget {
  const RankListBody({
    super.key,
    required this.learners,
    required this.selectedTimeline,
    required this.onTimelineChanged,
    this.isLoading = false,
    this.hasError = false,
  });

  final List<LearnerDto> learners;
  final LeaderboardTimeline selectedTimeline;
  final ValueChanged<LeaderboardTimeline> onTimelineChanged;
  final bool isLoading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
              horizontal: design.spacing.md, vertical: design.spacing.md),
          child: Row(
            children: [
              TimelineChip(
                label: l10n.leaderboardTimelineThisWeek,
                icon: LucideIcons.calendarDays,
                isSelected: selectedTimeline == LeaderboardTimeline.thisWeek,
                onTap: () => onTimelineChanged(LeaderboardTimeline.thisWeek),
              ),
              SizedBox(width: design.spacing.sm),
              TimelineChip(
                label: l10n.leaderboardTimelineThisMonth,
                icon: LucideIcons.calendar,
                isSelected: selectedTimeline == LeaderboardTimeline.thisMonth,
                onTap: () => onTimelineChanged(LeaderboardTimeline.thisMonth),
              ),
              SizedBox(width: design.spacing.sm),
              TimelineChip(
                label: l10n.leaderboardTimelineAllTime,
                icon: LucideIcons.infinity,
                isSelected: selectedTimeline == LeaderboardTimeline.allTime,
                onTap: () => onTimelineChanged(LeaderboardTimeline.allTime),
              ),
            ],
          ),
        ),

        // The List
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: design.spacing.md,
              right: design.spacing.md,
              bottom: design.spacing.md,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: design.colors.card,
                borderRadius: BorderRadius.circular(24),
                boxShadow: design.shadows.surfaceSoft,
              ),
              clipBehavior: Clip.hardEdge,
              child: Builder(
                builder: (context) {
                  if (hasError) {
                    return Center(
                      child: AppText.body(l10n.leaderboardErrorLoading,
                          color: design.colors.error),
                    );
                  }
                  if (!isLoading && learners.isEmpty) {
                    return Center(
                      child: AppText.body(l10n.leaderboardNoLearnersFound,
                          color: design.colors.textSecondary),
                    );
                  }

                  final displayLearners = isLoading ? _mockLearners : learners;

                  return Skeletonizer(
                    enabled: isLoading,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: displayLearners.length,
                      separatorBuilder: (_, __) =>
                          RowDivider(color: design.colors.divider),
                      itemBuilder: (context, index) {
                        return LeaderboardListItem(
                            learner: displayLearners[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final _mockLearners = List.generate(
  10,
  (index) => LearnerDto(
    id: 'skeleton_$index',
    rank: index + 1,
    name: BoneMock.name,
    avatar: '',
    points: 1000 - (index * 10),
  ),
);
