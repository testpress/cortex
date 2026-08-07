import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/core.dart';
import '../../providers/exam_results_provider.dart';
import '../../models/exam_result_response_dto.dart';

class MyResultsScreen extends ConsumerStatefulWidget {
  const MyResultsScreen({super.key});

  @override
  ConsumerState<MyResultsScreen> createState() => _MyResultsScreenState();
}

class _MyResultsScreenState extends ConsumerState<MyResultsScreen> {
  String _activeTab = 'model';

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      color: design.colors.canvas,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: design.colors.card),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    design.spacing.md,
                    design.spacing.md,
                    design.spacing.screenPadding,
                    design.spacing.md,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppSemantics.button(
                        label: l10n.curriculumBackButton,
                        onTap: () => context.pop(),
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 2,
                            ), // Optical alignment
                            child: Icon(
                              LucideIcons.arrowLeft,
                              color: design.colors.textPrimary,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: design.spacing.sm),
                      Expanded(
                        child: AppSemantics.header(
                          label: l10n.drawerMyResults,
                          child: AppText.title(
                            l10n.drawerMyResults,
                            color: design.colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: design.colors.card,
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.md,
                vertical: design.spacing.sm,
              ),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'Model Exam',
                    isSelected: _activeTab == 'model',
                    onTap: () => setState(() => _activeTab = 'model'),
                  ),
                  SizedBox(width: design.spacing.md),
                  _FilterChip(
                    label: 'Weekly Exam',
                    isSelected: _activeTab == 'weekly',
                    onTap: () => setState(() => _activeTab = 'weekly'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _activeTab == 'model'
                  ? _ExamResultsTabView(
                      key: const ValueKey('model'),
                      provider: modelExamResultsProvider.call,
                    )
                  : _ExamResultsTabView(
                      key: const ValueKey('weekly'),
                      provider: weeklyExamResultsProvider.call,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExamResultsTabView extends ConsumerStatefulWidget {
  final AutoDisposeFutureProvider<ExamResultResponseDto> Function({
    required int page,
    required int limit,
  })
  provider;

  const _ExamResultsTabView({super.key, required this.provider});

  @override
  ConsumerState<_ExamResultsTabView> createState() =>
      _ExamResultsTabViewState();
}

class _ExamResultsTabViewState extends ConsumerState<_ExamResultsTabView> {
  int _currentPage = 1;

  // Layout height estimates used to calculate how many table rows fit on screen.
  static const double _tableHeaderHeight = 46;
  static const double _paginationHeight = 56;
  static const double _verticalMargins = 24;
  static const double _rowHeight = 48.0;

  int _calculateLimit(double maxHeight) {
    final available =
        maxHeight - _tableHeaderHeight - _paginationHeight - _verticalMargins;
    final limit = (available / _rowHeight).floor();
    return limit.clamp(5, 20);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final limit = _calculateLimit(constraints.maxHeight);
        final state = ref.watch(
          widget.provider(page: _currentPage, limit: limit),
        );
        final l10n = L10n.of(context);
        final design = Design.of(context);

        return state.when(
          data: (data) {
            // We let the empty data fall through so _ResultsTable can render
            // its header row and a centered "No results found" message.
            return Column(
              children: [
                Expanded(
                  child: AppRefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(
                        widget.provider(page: _currentPage, limit: limit),
                      );
                    },
                    child: AppSemantics.scrollableList(
                      itemCount: data.data.length,
                      label: l10n.drawerMyResults,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        child: _ResultsTable(results: data.data),
                      ),
                    ),
                  ),
                ),
                _PaginationControl(
                  currentPage: data.currentPage,
                  totalCount: data.totalCount,
                  limit: data.limit,
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                  },
                ),
              ],
            );
          },
          loading: () {
            final mockData = List.generate(limit, (_) => _mockExamResultRow());
            return Skeletonizer(
              enabled: true,
              ignoreContainers: true,
              effect: ShimmerEffect(
                baseColor: design.colors.skeleton,
                highlightColor: design.colors.onSkeleton,
              ),
              child: Column(
                children: [
                  Expanded(child: _ResultsTable(results: mockData)),
                  _PaginationControl(
                    currentPage: 1,
                    totalCount: limit * 2,
                    limit: limit,
                    onPageChanged: (_) {},
                  ),
                ],
              ),
            );
          },
          error: (error, stack) => AppErrorView(
            title: l10n.errorGenericTitle,
            message: error.toString(),
            error: error,
          ),
        );
      },
    );
  }
}

class _ResultsTable extends StatelessWidget {
  final List<ExamResultDto> results;

  const _ResultsTable({required this.results});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      margin: EdgeInsets.all(design.spacing.sm),
      decoration: BoxDecoration(
        color: design.colors.surface,
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: design.colors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(design.radius.md),
        child: _buildTableContent(context, design),
      ),
    );
  }

  Widget _buildTableContent(BuildContext context, DesignConfig design) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeleton.keep(child: _buildHeaderRow(design)),
            if (results.isEmpty)
              Container(
                width:
                    900, // Approximate width of headers to keep it visually centered
                padding: EdgeInsets.symmetric(vertical: design.spacing.xl * 2),
                alignment: Alignment.center,
                child: AppText.body(
                  'No results found',
                  color: design.colors.textSecondary,
                ),
              )
            else
              ...results.asMap().entries.map((entry) {
                final index = entry.key;
                final result = entry.value;
                return _buildDataRow(design, result, index);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(DesignConfig design) {
    return Container(
      color: design.colors.surfaceVariant.withValues(alpha: 0.5),
      padding: EdgeInsets.symmetric(
        vertical: design.spacing.md,
        horizontal: design.spacing.md,
      ),
      child: Row(
        children: [
          _buildCell(
            design,
            'Date',
            105,
            isHeader: true,
            align: TextAlign.left,
          ),
          _buildCell(
            design,
            'Exam',
            180,
            isHeader: true,
            align: TextAlign.left,
            maxLines: null,
          ),
          _buildCell(design, 'PHY', 60, isHeader: true),
          _buildCell(design, 'CHE', 60, isHeader: true),
          _buildCell(design, 'BIO', 60, isHeader: true),
          _buildCell(design, 'Mat', 60, isHeader: true),
          _buildCell(design, 'APT', 60, isHeader: true),
          _buildCell(design, 'DRW', 60, isHeader: true),
          _buildCell(design, 'P-I', 60, isHeader: true),
          _buildCell(design, 'P-II', 60, isHeader: true),
          _buildCell(design, 'Total', 70, isHeader: true),
          _buildCell(design, 'Max', 60, isHeader: true),
          _buildCell(design, 'Highest', 70, isHeader: true),
          _buildCell(design, '%', 70, isHeader: true),
          _buildCell(design, 'Grade', 60, isHeader: true),
          _buildCell(design, 'Rank', 70, isHeader: true),
          _buildCell(design, 'Appeared', 80, isHeader: true),
          _buildCell(design, 'OMR', 60, isHeader: true),
        ],
      ),
    );
  }

  Widget _buildDataRow(DesignConfig design, ExamResultDto result, int index) {
    final bgColor = index.isEven
        ? design.colors.surface
        : design.colors.surfaceVariant.withValues(alpha: 0.2);
    return Container(
      color: bgColor,
      padding: EdgeInsets.symmetric(
        vertical: design.spacing.md,
        horizontal: design.spacing.md,
      ),
      child: Row(
        children: [
          _buildCell(
            design,
            result.date ?? '-',
            105,
            isBold: true,
            color: design.colors.accent2,
            align: TextAlign.left,
          ),
          _buildCell(
            design,
            result.examName ?? '-',
            180,
            align: TextAlign.left,
            maxLines: null,
          ),
          _buildCell(design, result.physics ?? '-', 60),
          _buildCell(design, result.chemistry ?? '-', 60),
          _buildCell(design, result.biology ?? '-', 60),
          _buildCell(design, result.maths ?? '-', 60),
          _buildCell(design, result.aptitude ?? '-', 60),
          _buildCell(design, result.drawing ?? '-', 60),
          _buildCell(design, result.p1 ?? '-', 60),
          _buildCell(design, result.p2 ?? '-', 60),
          _buildCell(design, result.totalMarks ?? '-', 70, isBold: true),
          _buildCell(design, result.maxMarks ?? '-', 60),
          _buildCell(design, result.highestMarks ?? '-', 70),
          _buildCell(
            design,
            result.percent != null ? '${result.percent}%' : '-',
            70,
          ),
          _buildCell(
            design,
            result.grade ?? '-',
            60,
            isBold: true,
            color: design.colors.accent2,
          ),
          _buildCell(design, result.rank ?? '-', 70, isBold: true),
          _buildCell(design, result.stuAppeared ?? '-', 80),
          _buildCell(design, result.omr ?? '-', 60),
        ],
      ),
    );
  }

  Widget _buildCell(
    DesignConfig design,
    String text,
    double width, {
    bool isHeader = false,
    bool isBold = false,
    Color? color,
    TextAlign align = TextAlign.center,
    int? maxLines = 1,
  }) {
    return SizedBox(
      width: width,
      child: AppText.xs(
        text,
        color:
            color ??
            (isHeader ? design.colors.accent2 : design.colors.textPrimary),
        textAlign: align,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: isHeader || isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _PaginationControl extends StatelessWidget {
  final int currentPage;
  final int totalCount;
  final int limit;
  final ValueChanged<int> onPageChanged;

  const _PaginationControl({
    required this.currentPage,
    required this.totalCount,
    required this.limit,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final totalPages = (totalCount / (limit > 0 ? limit : 10)).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();

    final visiblePages = _buildVisiblePages(currentPage, totalPages);

    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Skeleton.keep(
            child: _PaginationTextBtn(
              text: 'Previous',
              icon: LucideIcons.chevronLeft,
              isLeadingIcon: true,
              isEnabled: currentPage > 1,
              onTap: () => onPageChanged(currentPage - 1),
            ),
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: visiblePages.map((p) {
                  if (p == -1) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.xs,
                      ),
                      child: AppText.xs(
                        '...',
                        color: design.colors.textSecondary,
                      ),
                    );
                  }
                  final isSelected = p == currentPage;
                  return GestureDetector(
                    onTap: isSelected ? null : () => onPageChanged(p),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: design.spacing.xs,
                      ),
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? design.colors.primary
                            : design.colors.surface,
                        border: Border.all(
                          color: isSelected
                              ? design.colors.primary
                              : design.colors.border,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText.sm(
                        p.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        color: isSelected
                            ? design.colors.onPrimary
                            : design.colors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Skeleton.keep(
            child: _PaginationTextBtn(
              text: 'Next',
              icon: LucideIcons.chevronRight,
              isLeadingIcon: false,
              isEnabled: currentPage < totalPages,
              onTap: () => onPageChanged(currentPage + 1),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaginationTextBtn extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool isLeadingIcon;
  final bool isEnabled;
  final VoidCallback onTap;

  const _PaginationTextBtn({
    required this.text,
    this.icon,
    this.isLeadingIcon = true,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final color = isEnabled
        ? design.colors.primary
        : design.colors.textTertiary;

    return AppSemantics.button(
      label: text,
      onTap: isEnabled ? onTap : null,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.sm,
            vertical: design.spacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null && isLeadingIcon) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 1.5), // Optical alignment
                  child: Icon(icon, size: 16, color: color),
                ),
                SizedBox(width: design.spacing.xs),
              ],
              AppText.sm(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold),
                color: color,
              ),
              if (icon != null && !isLeadingIcon) ...[
                SizedBox(width: design.spacing.xs),
                Padding(
                  padding: const EdgeInsets.only(top: 1.5), // Optical alignment
                  child: Icon(icon, size: 16, color: color),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final chipDecoration = BoxDecoration(
      color: isSelected ? design.colors.primary : design.colors.card,
      borderRadius: BorderRadius.all(Radius.circular(999)),
      border: Border.all(
        color: isSelected ? design.colors.primary : design.colors.border,
      ),
    );
    const chipPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
    final chipChild = AppText.label(
      label,
      color: isSelected ? design.colors.textInverse : design.colors.textPrimary,
      style: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );

    final chipWidget = MotionPreferences.shouldAnimate(context)
        ? AnimatedContainer(
            duration: MotionPreferences.duration(context, design.motion.fast),
            padding: chipPadding,
            decoration: chipDecoration,
            child: chipChild,
          )
        : Container(
            padding: chipPadding,
            decoration: chipDecoration,
            child: chipChild,
          );

    return AppSemantics.button(
      label: label,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: chipWidget,
      ),
    );
  }
}

// ── Top-level pure helpers ──────────────────────────────────────────────────

/// Constructs the list of visible page numbers for the pagination control.
/// Returns -1 as a sentinel value for ellipsis (…) positions.
List<int> _buildVisiblePages(int current, int total) {
  if (total <= 5) return List.generate(total, (i) => i + 1);
  final pages = <int>[1];
  if (current <= 3) {
    pages.addAll([2, 3, -1, total]);
  } else if (current >= total - 2) {
    pages.addAll([-1, total - 2, total - 1, total]);
  } else {
    pages.addAll([-1, current - 1, current, current + 1, -1, total]);
  }
  return pages;
}

/// Constructs a single mock [ExamResultDto] row used for skeleton loading states.
ExamResultDto _mockExamResultRow() => ExamResultDto(
  date: BoneMock.date,
  examName: BoneMock.name,
  physics: '00',
  chemistry: '00',
  biology: '00',
  maths: '00',
  aptitude: '00',
  drawing: '00',
  p1: '00',
  p2: '00',
  totalMarks: '000',
  maxMarks: '000',
  highestMarks: '000',
  percent: '00.00',
  grade: 'A',
  rank: '000',
  stuAppeared: '0000',
  omr: 'NA',
);
