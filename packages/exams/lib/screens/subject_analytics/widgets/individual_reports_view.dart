import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/models/review_models.dart';
import '../../../../providers/analytics_providers.dart';
import 'donut_chart.dart';
import '../subject_analytics_screen.dart';

import 'package:skeletonizer/skeletonizer.dart';

// Helper to format percentage values: shows no decimal if whole number, 1 decimal otherwise
String _formatPct(double pct) => pct.toStringAsFixed(pct % 1 == 0 ? 0 : 2);

class IndividualReportsView extends ConsumerStatefulWidget {
  const IndividualReportsView({
    super.key,
    this.parentId,
    this.activeFilter = 'All',
  });

  final String? parentId;
  final String activeFilter;

  @override
  ConsumerState<IndividualReportsView> createState() =>
      _IndividualReportsViewState();
}

class _IndividualReportsViewState extends ConsumerState<IndividualReportsView> {
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

  List<SubjectAnalyticsDto> _filterDonutCards(
    List<SubjectAnalyticsDto> data,
    String filter,
  ) {
    return switch (filter) {
      'Correct' => data.where((s) => s.correctAnswerCount > 0).toList(),
      'Incorrect' => data.where((s) => s.incorrectAnswerCount > 0).toList(),
      'Unanswered' => data.where((s) => s.unansweredCount > 0).toList(),
      _ => data,
    };
  }

  Map<int, TableColumnWidth> _getTableColumnWidths(
    String filter,
    bool showCorrect,
    bool showIncorrect,
    bool showUnanswered,
  ) {
    final Map<int, TableColumnWidth> widths = {};
    int colIndex = 0;
    widths[colIndex++] = const FlexColumnWidth();
    if (filter == 'All') {
      widths[colIndex++] = const FixedColumnWidth(65.0); // CORRECT
      widths[colIndex++] = const FixedColumnWidth(75.0); // INCORRECT
      widths[colIndex++] = const FixedColumnWidth(85.0); // UNANSWERED
    } else {
      if (showCorrect) widths[colIndex++] = const FixedColumnWidth(85.0);
      if (showIncorrect) widths[colIndex++] = const FixedColumnWidth(85.0);
      if (showUnanswered) widths[colIndex++] = const FixedColumnWidth(85.0);
    }
    widths[colIndex++] = const FixedColumnWidth(24.0); // CHEVRON
    return widths;
  }

  final _skeletonSubject = const SubjectAnalyticsDto(
    id: 0,
    name: 'Loading Subject Name Long',
    totalQuestionCount: 8888,
    correctAnswerCount: 8888,
    incorrectAnswerCount: 8888,
    unansweredCount: 8888,
    correctPercentage: 40.0,
    isLeaf: false,
  );

  Widget _buildWithSkeleton(
    BuildContext context,
    List<SubjectAnalyticsDto> subjects,
    List<SubjectAnalyticsDto> donutCardsData,
  ) {
    final design = Design.of(context);
    final subjectsAsync = ref.watch(subjectAnalyticsProvider(_parsedParentId));
    final paginationAsync = ref.watch(
      subjectAnalyticsPaginationProvider(_parsedParentId),
    );

    final isFetchingInitial = paginationAsync.isLoading;
    final isFetchingNextPage =
        paginationAsync.valueOrNull?.isLoadingMore ?? false;
    final hasMorePages = paginationAsync.valueOrNull?.hasMore ?? false;

    final hasData = subjectsAsync.valueOrNull?.isNotEmpty == true;
    final isInitialLoading =
        !hasData && (subjectsAsync.isLoading || isFetchingInitial);

    final displaySubjects = isInitialLoading
        ? List.generate(5, (_) => _skeletonSubject)
        : List<SubjectAnalyticsDto>.from(subjects);

    final displayDonuts = isInitialLoading
        ? List.generate(2, (_) => _skeletonSubject)
        : List<SubjectAnalyticsDto>.from(donutCardsData);

    if (isFetchingNextPage && !isInitialLoading) {
      displaySubjects.addAll(List.generate(3, (_) => _skeletonSubject));
      if (displayDonuts.isNotEmpty) {
        displayDonuts.addAll(List.generate(1, (_) => _skeletonSubject));
      }
    }

    return Skeletonizer(
      enabled: isInitialLoading,
      child: _buildContent(
        context,
        design,
        displaySubjects,
        displayDonuts,
        hasMorePages,
        isFetchingNextPage,
        () => ref
            .read(subjectAnalyticsPaginationProvider(_parsedParentId).notifier)
            .loadMore(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final subjectsAsync = ref.watch(subjectAnalyticsProvider(_parsedParentId));

    return subjectsAsync.when(
      skipLoadingOnReload: true,
      data: (subjects) {
        if (_parsedParentId == null) {
          final donutCardsData = _filterDonutCards(
            subjects,
            widget.activeFilter,
          );
          return _buildWithSkeleton(context, subjects, donutCardsData);
        } else {
          if (subjects.isNotEmpty) {
            final donutCardsData = _filterDonutCards(
              subjects,
              widget.activeFilter,
            );
            return _buildWithSkeleton(context, subjects, donutCardsData);
          } else {
            final selfSubjectAsync = ref.watch(
              subjectAnalyticsByIdProvider(_parsedParentId!),
            );
            return selfSubjectAsync.when(
              skipLoadingOnReload: true,
              data: (selfSubject) {
                final rawDonutCards = selfSubject != null
                    ? [selfSubject]
                    : <SubjectAnalyticsDto>[];
                final donutCardsData = _filterDonutCards(
                  rawDonutCards,
                  widget.activeFilter,
                );
                return _buildWithSkeleton(context, subjects, donutCardsData);
              },
              loading: () => _buildWithSkeleton(context, [], []),
              error: (err, stack) => Center(
                child: AppText.body(
                  'Error loading donut cards: $err',
                  color: design.colors.error,
                ),
              ),
            );
          }
        }
      },
      loading: () => _buildWithSkeleton(context, [], []),
      error: (err, stack) => Center(
        child: AppText.body(
          'Error loading subject table: $err',
          color: design.colors.error,
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    DesignConfig design,
    List<SubjectAnalyticsDto> subjects,
    List<SubjectAnalyticsDto> donutCardsData,
    bool hasMorePages,
    bool isFetchingNextPage,
    VoidCallback onLoadMore,
  ) {
    final showCorrect =
        widget.activeFilter == 'All' || widget.activeFilter == 'Correct';
    final showIncorrect =
        widget.activeFilter == 'All' || widget.activeFilter == 'Incorrect';
    final showUnanswered =
        widget.activeFilter == 'All' || widget.activeFilter == 'Unanswered';

    final columnWidths = _getTableColumnWidths(
      widget.activeFilter,
      showCorrect,
      showIncorrect,
      showUnanswered,
    );
    return CustomScrollView(
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
                  opacity: (pulledExtent / refreshTriggerPullDistance).clamp(
                    0.0,
                    1.0,
                  ),
                  child: Center(
                    child: AppLoadingIndicator(color: design.colors.primary),
                  ),
                );
              },
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            design.spacing.md,
            design.spacing.md,
            design.spacing.md,
            design.spacing.xxl,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Table container
              if (subjects.isEmpty)
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(design.spacing.xl),
                  child: AppText.body(
                    'No subjects found.',
                    color: design.colors.textSecondary,
                  ),
                )
              else ...[
                _StatsTable(
                  subjects: subjects,
                  activeFilter: widget.activeFilter,
                  showCorrect: showCorrect,
                  showIncorrect: showIncorrect,
                  showUnanswered: showUnanswered,
                  columnWidths: columnWidths,
                ),
                if (hasMorePages && !isFetchingNextPage) ...[
                  SizedBox(height: design.spacing.md),
                  Center(
                    child: GestureDetector(
                      onTap: onLoadMore,
                      behavior: HitTestBehavior.opaque,
                      child: AppText.xs(
                        'Load More Subjects',
                        color: design.colors.primary,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: design.spacing.md),
                ] else ...[
                  SizedBox(height: design.spacing.lg),
                ],
              ],

              // Donut Cards Section
              if (donutCardsData.isNotEmpty) ...[
                for (final cardData in donutCardsData) ...[
                  _DonutCard(
                    data: cardData,
                    activeFilter: widget.activeFilter,
                    formatPct: _formatPct,
                  ),
                  SizedBox(height: design.spacing.md),
                ],
              ],
            ]),
          ),
        ),
      ],
    );
  }
}

class _StatsTable extends StatelessWidget {
  const _StatsTable({
    required this.subjects,
    required this.activeFilter,
    required this.showCorrect,
    required this.showIncorrect,
    required this.showUnanswered,
    required this.columnWidths,
  });

  final List<SubjectAnalyticsDto> subjects;
  final String activeFilter;
  final bool showCorrect;
  final bool showIncorrect;
  final bool showUnanswered;
  final Map<int, TableColumnWidth> columnWidths;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(design.radius.lg),
        border: Border.all(color: design.colors.border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          // Table Header Row
          TableRow(
            decoration: BoxDecoration(color: design.colors.surfaceVariant),
            children: [
              _HeaderCell(
                label: l10n.analyticsSubjectUppercase,
                horizontalPadding: design.spacing.sm,
              ),
              if (showCorrect)
                _HeaderCell(
                  label: l10n.analyticsCorrectUppercase,
                  textAlign: TextAlign.center,
                  horizontalPadding: design.spacing.xs,
                ),
              if (showIncorrect)
                _HeaderCell(
                  label: l10n.analyticsIncorrectUppercase,
                  textAlign: TextAlign.center,
                  horizontalPadding: design.spacing.xs,
                ),
              if (showUnanswered)
                _HeaderCell(
                  label: l10n.analyticsUnansweredUppercase,
                  textAlign: TextAlign.center,
                  horizontalPadding: design.spacing.xs,
                ),
              // Empty space for the > chevron icon in the header
              Skeleton.keep(child: const SizedBox.shrink()),
            ],
          ),

          // Table Body Rows
          ...subjects.map((subjectAnalytics) {
            final isSkeleton = subjectAnalytics.id == 0;

            void onTap() {
              if (isSkeleton) return;
              if (subjectAnalytics.isLeaf) {
                context.push(
                  '/exams/analytics/topic/${subjectAnalytics.id}',
                  extra: subjectAnalytics,
                );
              } else {
                context.push(
                  '/exams/analytics/${subjectAnalytics.id}',
                  extra: subjectAnalytics,
                );
              }
            }

            return TableRow(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: subjectAnalytics == subjects.last
                        ? design.colors.transparent
                        : design.colors.divider,
                    width: 1,
                  ),
                ),
              ),
              children: [
                _TappableCell(
                  isSkeleton: isSkeleton,
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.sm,
                      vertical: design.spacing.sm + design.spacing.xs,
                    ),
                    child: Skeletonizer(
                      enabled: isSkeleton,
                      child: AppText.sm(
                        subjectAnalytics.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        color: design.colors.textPrimary,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                if (showCorrect)
                  _TappableCell(
                    isSkeleton: isSkeleton,
                    onTap: onTap,
                    child: Skeletonizer(
                      enabled: isSkeleton,
                      child: _StatsCell(
                        value: '${subjectAnalytics.correctAnswerCount}',
                        color: design.colors.success,
                      ),
                    ),
                  ),
                if (showIncorrect)
                  _TappableCell(
                    isSkeleton: isSkeleton,
                    onTap: onTap,
                    child: Skeletonizer(
                      enabled: isSkeleton,
                      child: _StatsCell(
                        value: '${subjectAnalytics.incorrectAnswerCount}',
                        color: design.incorrectColor,
                      ),
                    ),
                  ),
                if (showUnanswered)
                  _TappableCell(
                    isSkeleton: isSkeleton,
                    onTap: onTap,
                    child: Skeletonizer(
                      enabled: isSkeleton,
                      child: _StatsCell(
                        value: '${subjectAnalytics.unansweredCount}',
                        color: design.unansweredColor,
                      ),
                    ),
                  ),
                // Chevron column
                _TappableCell(
                  isSkeleton: isSkeleton,
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: design.spacing.xs,
                      top: design.spacing.sm + design.spacing.xs,
                      bottom: design.spacing.sm + design.spacing.xs,
                    ),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: subjectAnalytics.isLeaf
                          ? const SizedBox.shrink()
                          : Skeletonizer(
                              enabled: isSkeleton,
                              child: Icon(
                                LucideIcons.chevronRight,
                                size: design.iconSize.sm,
                                color: design.colors.textTertiary,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _StatsCell extends StatelessWidget {
  const _StatsCell({required this.value, required this.color});

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.xs,
        vertical: design.spacing.sm + design.spacing.xs,
      ),
      child: AppText.xs(
        value,
        textAlign: TextAlign.center,
        color: color,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _DonutCard extends StatelessWidget {
  const _DonutCard({
    required this.data,
    required this.activeFilter,
    required this.formatPct,
  });

  final SubjectAnalyticsDto data;
  final String activeFilter;
  final String Function(double) formatPct;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final isSkeleton =
        (Skeletonizer.maybeOf(context)?.enabled == true) || (data.id == 0);

    final correctPct = data.correctPercentage;
    final incorrectPct = data.incorrectPercentage;
    final unansweredPct = data.unansweredPercentage;

    final isCorrectActive = activeFilter == 'All' || activeFilter == 'Correct';
    final isIncorrectActive =
        activeFilter == 'All' || activeFilter == 'Incorrect';
    final isUnansweredActive =
        activeFilter == 'All' || activeFilter == 'Unanswered';

    ({Color color, Color textColor, Color legendTextColor}) getCategoryStyle({
      required Color baseColor,
      required bool isActive,
    }) {
      if (isSkeleton) {
        return (
          color: design.colors.surfaceVariant,
          textColor: design.colors.surfaceVariant,
          legendTextColor: design.colors.surfaceVariant,
        );
      }
      return (
        color: isActive ? baseColor : design.colors.surfaceVariant,
        textColor: isActive ? baseColor : design.colors.textTertiary,
        legendTextColor: isActive
            ? design.colors.textPrimary
            : design.colors.textTertiary,
      );
    }

    final correctStyle = getCategoryStyle(
      baseColor: design.correctColor,
      isActive: isCorrectActive,
    );
    final incorrectStyle = getCategoryStyle(
      baseColor: design.incorrectColor,
      isActive: isIncorrectActive,
    );
    final unansweredStyle = getCategoryStyle(
      baseColor: design.unansweredColor,
      isActive: isUnansweredActive,
    );

    final Color dotSeparatorColor = activeFilter == 'All'
        ? design.colors.textSecondary
        : design.colors.textTertiary;

    return Skeletonizer(
      enabled: data.id == 0,
      child: AppCard(
        padding: EdgeInsets.all(design.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Name and Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText.xs(
                    data.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                AppText.xs(
                  'Total: ${data.totalQuestionCount}',
                  color: design.colors.textSecondary,
                ),
              ],
            ),
            SizedBox(height: design.spacing.sm),

            // Counts row
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.xs(
                    'Correct: ${data.correctAnswerCount}',
                    color: correctStyle.textColor,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.sm,
                    ),
                    child: AppText.xs('•', color: dotSeparatorColor),
                  ),
                  AppText.xs(
                    'Incorrect: ${data.incorrectAnswerCount}',
                    color: incorrectStyle.textColor,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.sm,
                    ),
                    child: AppText.xs('•', color: dotSeparatorColor),
                  ),
                  AppText.xs(
                    'Unanswered: ${data.unansweredCount}',
                    color: unansweredStyle.textColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: design.spacing.md),

            // Chart + Legend Row
            Row(
              children: [
                // Donut Chart
                DonutChart(
                  correctPct: correctPct,
                  incorrectPct: incorrectPct,
                  unansweredPct: unansweredPct,
                  correctColor: correctStyle.color,
                  incorrectColor: incorrectStyle.color,
                  unansweredColor: unansweredStyle.color,
                  size: design.spacing.xxl + design.spacing.sm,
                ),
                SizedBox(width: design.spacing.lg),

                // Legend
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendRow(
                        color: correctStyle.color,
                        text: '${formatPct(correctPct)}% correct',
                        textColor: correctStyle.legendTextColor,
                      ),
                      SizedBox(height: design.spacing.sm),
                      _LegendRow(
                        color: incorrectStyle.color,
                        text: '${formatPct(incorrectPct)}% incorrect',
                        textColor: incorrectStyle.legendTextColor,
                      ),
                      SizedBox(height: design.spacing.sm),
                      _LegendRow(
                        color: unansweredStyle.color,
                        text: '${formatPct(unansweredPct)}% unanswered',
                        textColor: unansweredStyle.legendTextColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.text,
    required this.textColor,
  });

  final Color color;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Row(
      children: [
        Container(
          width: design.spacing.sm,
          height: design.spacing.sm,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: design.spacing.sm),
        Expanded(child: AppText.xs(text, color: textColor)),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.label,
    this.textAlign,
    required this.horizontalPadding,
  });

  final String label;
  final TextAlign? textAlign;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Skeleton.keep(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: design.spacing.sm + design.spacing.xs,
        ),
        child: AppText.xxs(
          label,
          textAlign: textAlign,
          maxLines: 1,
          overflow: TextOverflow.visible,
          color: design.colors.textSecondary,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 9.0,
            letterSpacing: 0.17,
          ),
        ),
      ),
    );
  }
}

class _TappableCell extends StatelessWidget {
  const _TappableCell({
    required this.onTap,
    required this.isSkeleton,
    required this.child,
  });

  final VoidCallback? onTap;
  final bool isSkeleton;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isSkeleton ? null : onTap,
      child: child,
    );
  }
}
