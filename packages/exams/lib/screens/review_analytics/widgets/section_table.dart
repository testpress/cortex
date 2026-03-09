import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import '../../../models/section_performance_overview.dart';
import 'review_analytics_formatters.dart';

class SectionTable extends StatefulWidget {
  const SectionTable({
    super.key,
    required this.sections,
    required this.overall,
  });

  final List<SectionPerformanceOverview> sections;
  final SectionPerformanceOverview overall;

  @override
  State<SectionTable> createState() => _SectionTableState();
}

class _SectionTableState extends State<SectionTable> {
  late final ScrollController _horizontalController;

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final tableContentWidth = 880.0 + (design.spacing.md * 2);
    return Container(
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: design.colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hasOverflow = tableContentWidth > constraints.maxWidth;
          final viewportWidth = constraints.maxWidth;
          final thumbWidth = hasOverflow
              ? (viewportWidth * viewportWidth / tableContentWidth).clamp(
                  36.0,
                  viewportWidth,
                )
              : viewportWidth;

          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SingleChildScrollView(
                    controller: _horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableContentWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _TableRow(
                            isHeader: true,
                            values: [
                              'Section Name',
                              'Total Questions',
                              'Correct',
                              'Incorrect',
                              'Unanswered',
                              'Score',
                              'Accuracy',
                              'Time Spent',
                            ],
                          ),
                          for (final section in widget.sections)
                            _TableRow(
                              values: [
                                section.name,
                                '${section.totalQuestions}',
                                '${section.correct}',
                                '${section.incorrect}',
                                '${section.unanswered}',
                                '${section.score}',
                                '${section.accuracy.toStringAsFixed(1)}%',
                                '${formatDuration(section.timeSpent)} / ${formatDuration(section.totalTime)}',
                              ],
                            ),
                          _TableRow(
                            isOverall: true,
                            values: [
                              widget.overall.name,
                              '${widget.overall.totalQuestions}',
                              '${widget.overall.correct}',
                              '${widget.overall.incorrect}',
                              '${widget.overall.unanswered}',
                              '${widget.overall.score}',
                              '${widget.overall.accuracy.toStringAsFixed(1)}%',
                              '${formatDuration(widget.overall.timeSpent)} / ${formatDuration(widget.overall.totalTime)}',
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (hasOverflow)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        design.spacing.sm,
                        design.spacing.xs,
                        design.spacing.sm,
                        design.spacing.sm,
                      ),
                      child: SizedBox(
                        height: 3,
                        child: AnimatedBuilder(
                          animation: _horizontalController,
                          builder: (context, child) {
                            final canReadMetrics =
                                _horizontalController.hasClients &&
                                _horizontalController
                                    .position
                                    .hasContentDimensions;
                            final maxScroll = canReadMetrics
                                ? _horizontalController.position.maxScrollExtent
                                : 0.0;
                            final offset = canReadMetrics
                                ? _horizontalController.offset.clamp(
                                    0.0,
                                    maxScroll,
                                  )
                                : 0.0;
                            final travel = viewportWidth - thumbWidth;
                            final progress = maxScroll == 0
                                ? 0.0
                                : (offset / maxScroll).clamp(0.0, 1.0);
                            final left = travel * progress;

                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: design.colors.border.withValues(
                                      alpha: 0.4,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      design.radius.full,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: left,
                                  child: Container(
                                    width: thumbWidth,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: design.colors.textSecondary
                                          .withValues(alpha: 0.45),
                                      borderRadius: BorderRadius.circular(
                                        design.radius.full,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.values,
    this.isHeader = false,
    this.isOverall = false,
  });

  final List<String> values;
  final bool isHeader;
  final bool isOverall;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final rowColor = isHeader
        ? design.colors.surface
        : isOverall
        ? design.colors.canvas
        : design.colors.card;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: design.spacing.lg,
        horizontal: design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: rowColor,
        border: Border(bottom: BorderSide(color: design.colors.border)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < values.length; i++)
            SizedBox(
              width: i == 0 ? 140 : 100,
              child: AppText.bodySmall(
                values[i],
                color: design.colors.textPrimary,
                maxLines: 2,
                style: TextStyle(
                  fontWeight: (isHeader || isOverall)
                      ? FontWeight.w700
                      : FontWeight.w600,
                ),
                textAlign: i == 0 ? TextAlign.left : TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
