import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../widgets/leaderboard/leaderboard_subtabs.dart';
import '../../widgets/leaderboard/rank_list_body.dart';
import '../../widgets/leaderboard/competitors_body.dart';

enum LeaderboardTab { rankList, competitors }

final leaderboardTabProvider =
    StateProvider<LeaderboardTab>((ref) => LeaderboardTab.rankList);

final leaderboardTimelineProvider =
    StateProvider<LeaderboardTimeline>((ref) => LeaderboardTimeline.thisWeek);

final leaderboardStreamProvider =
    StreamProvider.autoDispose<List<LearnerDto>>((ref) async* {
  final repo = await ref.watch(leaderboardRepositoryProvider.future);
  final timeline = ref.watch(leaderboardTimelineProvider);

  // Check if we have cached data
  final cached = await repo.watchLeaderboard(timeline, limit: 200).first;

  if (cached.isEmpty) {
    // Await the refresh so the provider remains in AsyncLoading state until the network completes
    await repo.refreshLeaderboard(timeline, limit: 200);
  } else {
    // If we have data, fire-and-forget refresh to update the cache in background
    repo.refreshLeaderboard(timeline, limit: 200);
  }

  yield* repo.watchLeaderboard(timeline, limit: 200);
});

final competitorsProvider =
    FutureProvider.autoDispose<List<LearnerDto>>((ref) async {
  final repo = await ref.watch(leaderboardRepositoryProvider.future);
  return repo.getCompetitors();
});

class TopLearnersScreen extends ConsumerWidget {
  const TopLearnersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final activeTab = ref.watch(leaderboardTabProvider);
    final l10n = L10n.of(context);
    final settings = ref.watch(instituteSettingsProvider);
    final leaderboardLabel = settings?.leaderboardLabel?.trim();
    final displayTitle =
        (leaderboardLabel != null && leaderboardLabel.isNotEmpty)
            ? leaderboardLabel
            : l10n.leaderboardTitle;

    return Container(
      color: design.colors.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Area
            Container(
              decoration: BoxDecoration(
                color: design.colors.card,
                border: Border(
                  bottom: BorderSide(
                    color: design.colors.border,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.only(
                      left: design.spacing.md,
                      right: design.spacing.md,
                      top: design.spacing.md,
                      bottom: design.spacing.sm,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.all(design.spacing.xs),
                            child: Icon(
                              LucideIcons.arrowLeft,
                              size: 24,
                              color: design.colors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: design.spacing.xs),
                        Expanded(
                          child: AppText.headline(
                            displayTitle,
                            color: design.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Subtabs
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: design.spacing.md),
                    child: LeaderboardSubtabs(
                      activeTab: activeTab,
                      onChanged: (tab) =>
                          ref.read(leaderboardTabProvider.notifier).state = tab,
                    ),
                  ),
                  SizedBox(height: design.spacing.md),
                ],
              ),
            ),

            // Body Area
            Expanded(
              child: activeTab == LeaderboardTab.rankList
                  ? Builder(builder: (context) {
                      final asyncLearners =
                          ref.watch(leaderboardStreamProvider);
                      final selectedTimeline =
                          ref.watch(leaderboardTimelineProvider);
                      return RankListBody(
                        learners: asyncLearners.valueOrNull ?? [],
                        selectedTimeline: selectedTimeline,
                        onTimelineChanged: (t) => ref
                            .read(leaderboardTimelineProvider.notifier)
                            .state = t,
                        isLoading: asyncLearners.isLoading,
                        hasError: asyncLearners.hasError,
                      );
                    })
                  : Builder(builder: (context) {
                      final asyncCompetitors = ref.watch(competitorsProvider);
                      return CompetitorsBody(
                        competitors: asyncCompetitors.valueOrNull ?? [],
                        isLoading: asyncCompetitors.isLoading,
                        hasError: asyncCompetitors.hasError,
                      );
                    }),
            ),
          ],
        ),
      ),
    );
  }
}
