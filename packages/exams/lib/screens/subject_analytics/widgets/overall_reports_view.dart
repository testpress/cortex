import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../../../providers/analytics_providers.dart';
import '../subject_analytics_screen.dart';
import 'bar_chart.dart';

import 'package:skeletonizer/skeletonizer.dart';

class OverallReportsView extends ConsumerStatefulWidget {
  const OverallReportsView({
    super.key,
    this.parentId,
    this.activeFilter = 'All',
  });

  final String? parentId;
  final String activeFilter;

  @override
  ConsumerState<OverallReportsView> createState() => _OverallReportsViewState();
}

class _OverallReportsViewState extends ConsumerState<OverallReportsView> {
  final ScrollController _scrollController = ScrollController();
  int? get _parsedParentId =>
      widget.parentId != null ? int.tryParse(widget.parentId!) : null;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(subjectAnalyticsPaginationProvider(_parsedParentId).notifier)
          .loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildSingleLegendItem(
    String filter,
    DesignConfig design,
    BuildContext context,
  ) {
    final l10n = L10n.of(context);
    return switch (filter) {
      'Correct' => _LegendItem(
        label: l10n.analyticsStrengthCorrect,
        color: design.correctColor,
      ),
      'Incorrect' => _LegendItem(
        label: l10n.analyticsWeaknessIncorrect,
        color: design.incorrectColor,
      ),
      'Unanswered' => _LegendItem(
        label: l10n.analyticsUnanswered,
        color: design.unansweredColor,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final subjectsAsync = ref.watch(subjectAnalyticsProvider(_parsedParentId));
    final paginationAsync = ref.watch(
      subjectAnalyticsPaginationProvider(_parsedParentId),
    );

    final isFetchingNextPage =
        paginationAsync.valueOrNull?.isLoadingMore ?? false;
    final isFetchingInitial = paginationAsync.isLoading;

    final hasData = subjectsAsync.valueOrNull?.isNotEmpty == true;
    final isInitialLoading =
        !hasData && (subjectsAsync.isLoading || isFetchingInitial);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Legend - dynamic height, horizontal padding using design tokens, bottom border
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm + design.spacing.xs,
          ),
          decoration: BoxDecoration(
            color: design.colors.card,
            border: Border(
              bottom: BorderSide(color: design.colors.divider, width: 1.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.activeFilter == 'All'
                ? [
                    _LegendItem(
                      label: l10n.analyticsStrength,
                      color: design.correctColor,
                    ),
                    SizedBox(width: design.spacing.md),
                    _LegendItem(
                      label: l10n.analyticsWeakness,
                      color: design.incorrectColor,
                    ),
                    SizedBox(width: design.spacing.md),
                    _LegendItem(
                      label: l10n.analyticsUnanswered,
                      color: design.unansweredColor,
                    ),
                  ]
                : [
                    _buildSingleLegendItem(
                      widget.activeFilter,
                      design,
                      context,
                    ),
                  ],
          ),
        ),

        // List
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () => ref.refresh(
                  subjectAnalyticsPaginationProvider(_parsedParentId).future,
                ),
                builder:
                    (
                      context,
                      refreshState,
                      pulledExtent,
                      refreshTriggerPullDistance,
                      refreshIndicatorExtent,
                    ) {
                      return Opacity(
                        opacity: (pulledExtent / refreshTriggerPullDistance)
                            .clamp(0.0, 1.0),
                        child: Center(
                          child: AppLoadingIndicator(
                            color: design.colors.primary,
                          ),
                        ),
                      );
                    },
              ),
              subjectsAsync.when(
                data: (subjects) {
                  if (subjects.isEmpty && !isInitialLoading) {
                    return SliverFillRemaining(
                      child: Center(
                        child: AppText.body(l10n.analyticsNoSubjectsFound),
                      ),
                    );
                  }

                  // If loading, show skeleton list
                  final displayList = isInitialLoading
                      ? List.generate(15, (_) => _skeletonSubject)
                      : subjects;

                  return Skeletonizer.sliver(
                    enabled: isInitialLoading,
                    child: SliverPadding(
                      padding: EdgeInsets.symmetric(
                        vertical: design.spacing.sm + design.spacing.xs,
                      ),
                      sliver: SliverList.separated(
                        itemCount:
                            displayList.length + (isFetchingNextPage ? 3 : 0),
                        separatorBuilder: (context, index) => SizedBox(
                          height: design.spacing.sm + design.spacing.xs,
                        ),
                        itemBuilder: (context, index) {
                          if (index >= displayList.length) {
                            return Skeletonizer(
                              enabled: true,
                              child: BarRow(
                                subjectAnalytics: _skeletonSubject,
                                activeFilter: widget.activeFilter,
                              ),
                            );
                          }

                          final subjectAnalytics = displayList[index];

                          return subjectAnalytics.isLeaf
                              ? AppFocusable(
                                  onTap: () {
                                    if (isInitialLoading) return;
                                    context.push(
                                      '/exams/analytics/topic/${subjectAnalytics.id}',
                                      extra: subjectAnalytics,
                                    );
                                  },
                                  child: BarRow(
                                    subjectAnalytics: subjectAnalytics,
                                    activeFilter: widget.activeFilter,
                                  ),
                                )
                              : AppFocusable(
                                  onTap: () {
                                    if (isInitialLoading) return;
                                    context.push(
                                      '/exams/analytics/${subjectAnalytics.id}',
                                      extra: subjectAnalytics,
                                    );
                                  },
                                  child: BarRow(
                                    subjectAnalytics: subjectAnalytics,
                                    activeFilter: widget.activeFilter,
                                  ),
                                );
                        },
                      ),
                    ),
                  );
                },
                loading: () => Skeletonizer.sliver(
                  enabled: true,
                  child: SliverPadding(
                    padding: EdgeInsets.symmetric(
                      vertical: design.spacing.sm + design.spacing.xs,
                    ),
                    sliver: SliverList.separated(
                      itemCount: 15,
                      separatorBuilder: (context, index) => SizedBox(
                        height: design.spacing.sm + design.spacing.xs,
                      ),
                      itemBuilder: (context, index) => BarRow(
                        subjectAnalytics: _skeletonSubject,
                        activeFilter: widget.activeFilter,
                      ),
                    ),
                  ),
                ),
                error: (err, stack) => SliverFillRemaining(
                  child: Center(
                    child: AppText.body(
                      'Error loading subjects: $err',
                      color: design.colors.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: design.spacing.sm,
          height: design.spacing.sm,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: design.spacing.sm),
        AppText.xs(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            letterSpacing: -0.08,
          ),
          color: design.colors.textPrimary,
        ),
      ],
    );
  }
}

final _skeletonSubject = const SubjectAnalyticsDto(
  id: 0,
  name: 'Loading Subject Name',
  totalQuestionCount: 100,
  correctAnswerCount: 40,
  incorrectAnswerCount: 40,
  unansweredCount: 20,
  correctPercentage: 40.0,
  isLeaf: false,
);
