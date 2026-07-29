import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../providers/custom_exam_builder_provider.dart';
import '../providers/custom_exam_config_provider.dart';
import '../widgets/custom_exam_subject_bottom_sheet.dart';
import '../widgets/custom_exam_mode_bottom_sheet.dart';
import '../models/questionnaire_block.dart';

class CustomExamBuilderScreen extends ConsumerStatefulWidget {
  final String courseId;

  const CustomExamBuilderScreen({super.key, required this.courseId});

  @override
  ConsumerState<CustomExamBuilderScreen> createState() =>
      _CustomExamBuilderScreenState();
}

class _CustomExamBuilderScreenState
    extends ConsumerState<CustomExamBuilderScreen> {
  bool _isSubjectBottomSheetOpen = false;
  bool _isModeBottomSheetOpen = false;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final design = Design.of(context);
    final padding = MediaQuery.paddingOf(context);
    final builderState = ref.watch(customExamBuilderProvider(widget.courseId));
    final configAsync = ref.watch(customExamConfigProvider(widget.courseId));

    return DecoratedBox(
      decoration: BoxDecoration(color: design.colors.card),
      child: Stack(
        children: [
          // ── Scrollable body ────────────────────────────────────────────
          Positioned.fill(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: padding.top + 64)),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    design.spacing.md,
                    design.spacing.lg,
                    design.spacing.md,
                    0,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (configAsync.isLoading)
                        _buildSkeleton(design)
                      else if (configAsync.hasError)
                        AppErrorView(
                          error: configAsync.error!,
                          onRetry: () => ref.invalidate(
                            customExamConfigProvider(widget.courseId),
                          ),
                        )
                      else if (builderState.blocks.isEmpty)
                        _buildEmptyState(design)
                      else
                        ...builderState.blocks.asMap().entries.map(
                          (e) => _buildSummaryCard(design, e.key, e.value),
                        ),

                      SizedBox(height: design.spacing.lg),

                      // + Add (more) subjects button — full width
                      if (!configAsync.isLoading && !configAsync.hasError)
                        builderState.blocks.isEmpty
                            ? AppButton.primary(
                                label: '+ ${l10n.customExamAddQuestionnaire}',
                                fullWidth: true,
                                onPressed: _openSubjectSheet,
                              )
                            : AppButton.secondary(
                                label:
                                    '+ ${l10n.customExamAddMoreQuestionnaires}',
                                fullWidth: true,
                                borderColor: design.colors.border,
                                foregroundColor: design.colors.textSecondary,
                                onPressed: _openSubjectSheet,
                              ),

                      // Bottom padding so content clears the fixed footer
                      SizedBox(height: padding.bottom + 96),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // ── Fixed header ───────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(design, padding),
          ),

          // ── Fixed bottom bar: Next → right-aligned ─────────────────────
          if (builderState.blocks.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomBar(design, padding, builderState),
            ),

          // ── Subject bottom sheet ───────────────────────────────────────
          AppBottomSheet(
            isOpen: _isSubjectBottomSheetOpen,
            onClose: () => setState(() => _isSubjectBottomSheetOpen = false),
            child: _isSubjectBottomSheetOpen
                ? CustomExamSubjectBottomSheet(
                    courseId: widget.courseId,
                    onClose: () =>
                        setState(() => _isSubjectBottomSheetOpen = false),
                  )
                : const SizedBox.shrink(),
          ),

          // ── Mode bottom sheet ──────────────────────────────────────────
          AppBottomSheet(
            isOpen: _isModeBottomSheetOpen,
            onClose: () => setState(() => _isModeBottomSheetOpen = false),
            child: _isModeBottomSheetOpen
                ? CustomExamModeBottomSheet(
                    courseId: widget.courseId,
                    onClose: () =>
                        setState(() => _isModeBottomSheetOpen = false),
                    onSuccess: (examId, attempt, {required bool isQuizMode}) {
                      setState(() => _isModeBottomSheetOpen = false);
                      context.push(
                        '/exams/test/$examId/player'
                        '?isQuizMode=$isQuizMode'
                        '&isCustomTest=true',
                        extra: attempt,
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(DesignConfig design, EdgeInsets padding) {
    final l10n = L10n.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(bottom: BorderSide(color: design.colors.border)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          design.spacing.md,
          padding.top + design.spacing.md,
          design.spacing.md,
          design.spacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppIconButton(
              accessibilityLabel: 'Go back',
              onTap: () => context.pop(),
              icon: LucideIcons.arrowLeft,
              color: design.colors.textPrimary,
              size: design.iconSize.lg,
            ),
            Expanded(
              child: AppSemantics.header(
                label: l10n.customExamTitle,
                child: AppText.headline(
                  l10n.customExamTitle,
                  color: design.colors.textPrimary,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Footer / Next bar ──────────────────────────────────────────────────────

  Widget _buildBottomBar(
    DesignConfig design,
    EdgeInsets padding,
    CustomExamBuilderState builderState,
  ) {
    final l10n = L10n.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(top: BorderSide(color: design.colors.border)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          design.spacing.md,
          design.spacing.md,
          design.spacing.md,
          padding.bottom + design.spacing.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppSemantics.button(
              label: l10n.customExamNext,
              enabled: builderState.blocks.isNotEmpty,
              onTap: builderState.blocks.isEmpty
                  ? () {}
                  : () => setState(() => _isModeBottomSheetOpen = true),
              child: AppButton.primary(
                label: l10n.customExamNext,
                onPressed: builderState.blocks.isEmpty
                    ? null
                    : () => setState(() => _isModeBottomSheetOpen = true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────

  Widget _buildEmptyState(DesignConfig design) {
    final l10n = L10n.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(design.spacing.xl),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: design.radius.card,
        border: Border.all(
          color: design.colors.border,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(design.spacing.lg),
            decoration: BoxDecoration(
              color: design.colors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.clipboardPlus,
              size: design.iconSize.xl,
              color: design.colors.primary,
            ),
          ),
          SizedBox(height: design.spacing.md),
          AppText.headline(
            l10n.customExamEmptyStateTitle,
            color: design.colors.textPrimary,
          ),
          SizedBox(height: design.spacing.xs),
          AppText.body(
            l10n.customExamEmptyStateDesc,
            color: design.colors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton(DesignConfig design) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: design.spacing.xl * 2),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: design.radius.card,
        border: Border.all(color: design.colors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: design.colors.surfaceVariant,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: design.spacing.md),
          Container(
            width: 150,
            height: 24,
            decoration: BoxDecoration(
              color: design.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: design.spacing.sm),
          Container(
            width: 250,
            height: 16,
            decoration: BoxDecoration(
              color: design.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary card ───────────────────────────────────────────────────────────

  Widget _buildSummaryCard(
    DesignConfig design,
    int index,
    QuestionnaireBlock block,
  ) {
    final l10n = L10n.of(context);
    final diffText = block.difficultyLabels.isEmpty
        ? l10n.customExamAll
        : block.difficultyLabels.join(' · ');
    final typesText = block.questionTypeLabels.isEmpty
        ? l10n.customExamAll
        : block.questionTypeLabels.join(' · ');

    return Container(
      margin: EdgeInsets.only(bottom: design.spacing.md),
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: design.radius.card,
        border: Border.all(color: design.colors.border),
        boxShadow: design.shadows.surfaceSoft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppText.cardTitle(
                  block.subjectName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              AppIconButton(
                accessibilityLabel: 'Remove ${block.subjectName}',
                onTap: () => ref
                    .read(customExamBuilderProvider(widget.courseId).notifier)
                    .removeBlock(index),
                icon: LucideIcons.trash2,
                size: design.iconSize.md,
                color: design.colors.error,
              ),
            ],
          ),
          SizedBox(height: design.spacing.md),
          Container(height: 1, color: design.colors.divider),
          SizedBox(height: design.spacing.md),
          _cardRow(
            design,
            LucideIcons.hash,
            '${block.noOfQuestions} ${l10n.customExamQuestionsLabel}',
          ),
          SizedBox(height: design.spacing.xs),
          _cardRow(
            design,
            LucideIcons.barChart2,
            '${l10n.customExamDifficultyLevel}: $diffText',
          ),
          SizedBox(height: design.spacing.xs),
          _cardRow(
            design,
            LucideIcons.fileText,
            '${l10n.customExamQuestionTypes}: $typesText',
          ),
        ],
      ),
    );
  }

  Widget _cardRow(DesignConfig design, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: design.iconSize.sm, color: design.colors.textTertiary),
        SizedBox(width: design.spacing.sm),
        AppText.cardSubtitle(label, color: design.colors.textSecondary),
      ],
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void _openSubjectSheet() {
    ref
        .read(customExamBuilderProvider(widget.courseId).notifier)
        .resetDrillDown();
    setState(() => _isSubjectBottomSheetOpen = true);
  }
}
