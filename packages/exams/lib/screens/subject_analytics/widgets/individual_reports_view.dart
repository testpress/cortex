import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/models/review_models.dart';
import '../../../../providers/analytics_providers.dart';
import 'donut_chart.dart';
import '../subject_analytics_screen.dart';

class IndividualReportsView extends ConsumerWidget {
  const IndividualReportsView({
    super.key,
    this.parentId,
    this.activeFilter = 'All',
  });

  final String? parentId;
  final String activeFilter;

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
      widths[colIndex++] = const FixedColumnWidth(60.0); // CORRECT
      widths[colIndex++] = const FixedColumnWidth(70.0); // INCORRECT
      widths[colIndex++] = const FixedColumnWidth(80.0); // UNANSWERED
    } else {
      if (showCorrect) widths[colIndex++] = const FixedColumnWidth(80.0);
      if (showIncorrect) widths[colIndex++] = const FixedColumnWidth(80.0);
      if (showUnanswered) widths[colIndex++] = const FixedColumnWidth(80.0);
    }
    widths[colIndex++] = const FixedColumnWidth(24.0); // CHEVRON
    return widths;
  }

  // Helper to format percentage values: shows no decimal if whole number, 1 decimal otherwise
  String _formatPct(double pct) => pct.toStringAsFixed(pct % 1 == 0 ? 0 : 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final parsedParentId = parentId != null ? int.tryParse(parentId!) : null;

    final subjectsAsync = ref.watch(subjectAnalyticsProvider(parsedParentId));

    if (parsedParentId == null) {
      final donutSubjectsAsync = ref.watch(subjectAnalyticsProvider(3));

      return subjectsAsync.when(
        data: (subjects) {
          return donutSubjectsAsync.when(
            data: (rawDonutCards) {
              final donutCardsData = _filterDonutCards(
                rawDonutCards,
                activeFilter,
              );
              return _buildContent(context, design, subjects, donutCardsData);
            },
            loading: () => const Center(child: AppLoadingIndicator()),
            error: (err, stack) => Center(
              child: AppText.body(
                'Error loading donut cards: $err',
                color: design.colors.error,
              ),
            ),
          );
        },
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (err, stack) => Center(
          child: AppText.body(
            'Error loading subject table: $err',
            color: design.colors.error,
          ),
        ),
      );
    } else {
      return subjectsAsync.when(
        data: (subjects) {
          if (subjects.isNotEmpty) {
            final donutCardsData = _filterDonutCards(subjects, activeFilter);
            return _buildContent(context, design, subjects, donutCardsData);
          } else {
            final selfSubjectAsync = ref.watch(
              subjectAnalyticsByIdProvider(parsedParentId),
            );
            return selfSubjectAsync.when(
              data: (selfSubject) {
                final rawDonutCards = selfSubject != null
                    ? [selfSubject]
                    : <SubjectAnalyticsDto>[];
                final donutCardsData = _filterDonutCards(
                  rawDonutCards,
                  activeFilter,
                );
                return _buildContent(context, design, subjects, donutCardsData);
              },
              loading: () => const Center(child: AppLoadingIndicator()),
              error: (err, stack) => Center(
                child: AppText.body(
                  'Error loading donut cards: $err',
                  color: design.colors.error,
                ),
              ),
            );
          }
        },
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (err, stack) => Center(
          child: AppText.body(
            'Error loading subject table: $err',
            color: design.colors.error,
          ),
        ),
      );
    }
  }

  Widget _buildContent(
    BuildContext context,
    DesignConfig design,
    List<SubjectAnalyticsDto> subjects,
    List<SubjectAnalyticsDto> donutCardsData,
  ) {
    final showCorrect = activeFilter == 'All' || activeFilter == 'Correct';
    final showIncorrect = activeFilter == 'All' || activeFilter == 'Incorrect';
    final showUnanswered =
        activeFilter == 'All' || activeFilter == 'Unanswered';

    final columnWidths = _getTableColumnWidths(
      activeFilter,
      showCorrect,
      showIncorrect,
      showUnanswered,
    );

    return AppScroll(
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        design.spacing.md,
        design.spacing.md,
        design.spacing.xxl,
      ),
      children: [
        // Table container
        _StatsTable(
          subjects: subjects,
          activeFilter: activeFilter,
          showCorrect: showCorrect,
          showIncorrect: showIncorrect,
          showUnanswered: showUnanswered,
          columnWidths: columnWidths,
        ),

        // Donut Cards Section
        if (donutCardsData.isNotEmpty) ...[
          SizedBox(height: design.spacing.lg),
          for (final cardData in donutCardsData) ...[
            _DonutCard(
              data: cardData,
              activeFilter: activeFilter,
              formatPct: _formatPct,
            ),
            SizedBox(height: design.spacing.md),
          ],
        ],
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
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: design.spacing.sm,
                  vertical: design.spacing.sm + design.spacing.xs,
                ),
                child: AppText.xxs(
                  'SUBJECT',
                  maxLines: 1,
                  color: design.colors.textSecondary,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 9.0,
                    letterSpacing: 0.17,
                  ),
                ),
              ),
              if (showCorrect)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.xs,
                    vertical: design.spacing.sm + design.spacing.xs,
                  ),
                  child: AppText.xxs(
                    'CORRECT',
                    textAlign: TextAlign.center,
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
              if (showIncorrect)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.xs,
                    vertical: design.spacing.sm + design.spacing.xs,
                  ),
                  child: AppText.xxs(
                    'INCORRECT',
                    textAlign: TextAlign.center,
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
              if (showUnanswered)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.xs,
                    vertical: design.spacing.sm + design.spacing.xs,
                  ),
                  child: AppText.xxs(
                    'UNANSWERED',
                    textAlign: TextAlign.center,
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
              // Empty space for the > chevron icon in the header
              const SizedBox.shrink(),
            ],
          ),

          // Table Body Rows
          ...subjects.map((subjectAnalytics) {
            final onTap = subjectAnalytics.isLeaf
                ? null
                : () {
                    context.push(
                      '/exams/analytics/${subjectAnalytics.id}',
                      extra: subjectAnalytics,
                    );
                  };
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
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.sm,
                      vertical: design.spacing.sm + design.spacing.xs,
                    ),
                    child: AppText.xs(
                      subjectAnalytics.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                if (showCorrect)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onTap,
                    child: _StatsCell(
                      value: subjectAnalytics.correctAnswerCount.toString(),
                      color: design.correctColor,
                    ),
                  ),
                if (showIncorrect)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onTap,
                    child: _StatsCell(
                      value: subjectAnalytics.incorrectAnswerCount.toString(),
                      color: design.incorrectColor,
                    ),
                  ),
                if (showUnanswered)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onTap,
                    child: _StatsCell(
                      value: subjectAnalytics.unansweredCount.toString(),
                      color: design.unansweredColor,
                    ),
                  ),
                // Chevron column
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
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
                          : Icon(
                              LucideIcons.chevronRight,
                              size: design.iconSize.sm,
                              color: design.colors.textTertiary,
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
      child: AppText.xxs(
        value,
        textAlign: TextAlign.center,
        color: color,
        style: const TextStyle(fontWeight: FontWeight.w500),
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

    return AppCard(
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
                  padding: EdgeInsets.symmetric(horizontal: design.spacing.sm),
                  child: AppText.xs('•', color: dotSeparatorColor),
                ),
                AppText.xs(
                  'Incorrect: ${data.incorrectAnswerCount}',
                  color: incorrectStyle.textColor,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: design.spacing.sm),
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
