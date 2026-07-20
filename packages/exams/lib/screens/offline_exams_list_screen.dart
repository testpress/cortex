import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';

class OfflineExamsListScreen extends ConsumerWidget {
  const OfflineExamsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);

    return ColoredBox(
      color: design.colors.card,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: const [
            _OfflineExamsHeader(),
            Expanded(child: _OfflineExamsListBody()),
          ],
        ),
      ),
    );
  }
}

class _OfflineExamsHeader extends StatelessWidget {
  const _OfflineExamsHeader();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(
          bottom: BorderSide(color: design.colors.border, width: 1),
        ),
        boxShadow: design.shadows.surfaceSoft,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: design.spacing.xs,
          horizontal: design.spacing.xs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppFocusable(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(design.radius.md),
              child: Padding(
                padding: EdgeInsets.all(design.spacing.xs),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Icon(
                    LucideIcons.arrowLeft,
                    color: design.colors.textPrimary,
                    size: design.iconSize.md,
                  ),
                ),
              ),
            ),
            SizedBox(width: design.spacing.sm),
            Expanded(
              child: AppSemantics.header(
                label: l10n.drawerOfflineExams,
                child: AppText.title(
                  l10n.drawerOfflineExams,
                  color: design.colors.textPrimary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineExamsListBody extends ConsumerWidget {
  const _OfflineExamsListBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineExamsAsync = ref.watch(offlineExamsProvider);
    final design = Design.of(context);

    return offlineExamsAsync.when(
      data: (exams) {
        if (exams.isEmpty) {
          return const _OfflineExamsEmptyState();
        }

        return AppSemantics.scrollableList(
          label: 'Offline Exams List',
          itemCount: exams.length,
          child: ListView.builder(
            padding: EdgeInsets.all(design.spacing.lg),
            itemCount: exams.length,
            itemBuilder: (context, index) {
              return _OfflineExamCard(exam: exams[index]);
            },
          ),
        );
      },
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (err, stack) => Center(child: AppText.body(err.toString())),
    );
  }
}

class _OfflineExamsEmptyState extends StatelessWidget {
  const _OfflineExamsEmptyState();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(design.spacing.xl),
            decoration: BoxDecoration(
              color: design.colors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.fileText,
              size: 48,
              color: design.colors.textSecondary,
            ),
          ),
          SizedBox(height: design.spacing.lg),
          AppText.title(l10n.drawerOfflineExams),
          SizedBox(height: design.spacing.xs),
          AppText.body(
            l10n.noDownloadedExamAvailable,
            color: design.colors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _OfflineExamCard extends ConsumerWidget {
  final OfflineExamDownloadsTableData exam;

  const _OfflineExamCard({required this.exam});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);

    final lessonAsync = ref.watch(lessonDetailProvider(exam.contentId));
    final lesson = lessonAsync.valueOrNull;
    final title = lesson?.title ?? 'Exam ${exam.examId}';
    final examMetadata = lesson?.exam;

    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.md),
      child: AppCard(
        padding: EdgeInsets.all(design.spacing.md),
        child: AppSemantics.container(
          label: title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ExamCardHeader(title: title),
              SizedBox(height: design.spacing.md),
              _ExamCardStats(examMetadata: examMetadata),
              SizedBox(height: design.spacing.md),
              Container(height: 1, color: design.colors.border),
              SizedBox(height: design.spacing.md),
              _ExamCardActions(exam: exam),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExamCardHeader extends StatelessWidget {
  final String title;

  const _ExamCardHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: design.colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(design.radius.md),
          ),
          child: Center(
            child: Icon(
              LucideIcons.fileText,
              color: design.colors.primary,
              size: 20,
            ),
          ),
        ),
        SizedBox(width: design.spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [AppText.cardTitle(title)],
          ),
        ),
        SizedBox(width: design.spacing.sm),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.sm,
            vertical: design.spacing.xs,
          ),
          decoration: BoxDecoration(
            color: design.colors.success.withValues(alpha: 0.1),
            border: Border.all(
              color: design.colors.success.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(design.radius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.checkCircle2,
                size: 14,
                color: design.colors.success,
              ),
              SizedBox(width: design.spacing.xs),
              AppText.labelSmall(
                l10n.downloadedStatus,
                color: design.colors.success,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExamCardStats extends StatelessWidget {
  final ExamDto? examMetadata;

  const _ExamCardStats({required this.examMetadata});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final totalMarks = examMetadata != null
        ? (examMetadata!.questionCount *
              (double.tryParse(examMetadata!.markPerQuestion ?? '1') ?? 1.0))
        : 0.0;
    final marksStr = totalMarks == totalMarks.toInt()
        ? totalMarks.toInt().toString()
        : totalMarks.toString();

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Icon(LucideIcons.clock, size: 24, color: design.colors.primary),
              SizedBox(width: design.spacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelSmall(
                      l10n.examDuration,
                      color: design.colors.textSecondary,
                    ),
                    SizedBox(height: design.spacing.xs),
                    AppText.labelBold(examMetadata?.duration ?? '-'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(width: 1, height: 32, color: design.colors.border),
        SizedBox(width: design.spacing.xs),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Icon(
                LucideIcons.helpCircle,
                size: 24,
                color: design.colors.primary,
              ),
              SizedBox(width: design.spacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelSmall(
                      l10n.totalQuestionsLabel,
                      color: design.colors.textSecondary,
                    ),
                    SizedBox(height: design.spacing.xs),
                    AppText.labelBold('${examMetadata?.questionCount ?? 0}'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(width: 1, height: 32, color: design.colors.border),
        SizedBox(width: design.spacing.xs),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Icon(LucideIcons.award, size: 24, color: design.colors.primary),
              SizedBox(width: design.spacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelSmall(
                      l10n.examTotalMarks,
                      color: design.colors.textSecondary,
                    ),
                    SizedBox(height: design.spacing.xs),
                    AppText.labelBold(marksStr),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExamCardActions extends ConsumerWidget {
  final OfflineExamDownloadsTableData exam;

  const _ExamCardActions({required this.exam});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton(
          height: design.spacing.xl + design.spacing.sm, // 40px
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.xs,
          ),
          label: l10n.deleteAction,
          variant: AppButtonVariant.secondary,
          foregroundColor: design.colors.error,
          backgroundColor: design.colors.card,
          borderColor: design.colors.error,
          leading: Icon(
            LucideIcons.trash2,
            size: 18,
            color: design.colors.error,
          ),
          onPressed: () async {
            final shouldDelete = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: design.colors.card,
                  title: AppText.headline(
                    l10n.deleteExamTitle,
                    color: design.colors.textPrimary,
                  ),
                  content: AppText.body(
                    l10n.deleteExamConfirmationMessage,
                    color: design.colors.textSecondary,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: AppText.labelBold(
                        l10n.labelCancel,
                        color: design.colors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: AppText.labelBold(
                        l10n.deleteAction,
                        color: design.colors.error,
                      ),
                    ),
                  ],
                );
              },
            );

            if (shouldDelete == true) {
              await ref.read(offlineExamsProvider.notifier).deleteExam(exam.id);
              if (context.mounted) {
                AppToast.show(context, message: l10n.examDeletedToast);
              }
            }
          },
        ),
        SizedBox(width: design.spacing.sm),
        AppButton(
          height: design.spacing.xl + design.spacing.sm, // 40px
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.xs,
          ),
          label: l10n.attendExamAction,
          variant: AppButtonVariant.primary,
          leading: const Icon(
            LucideIcons.play,
            size: 18,
            color: Color(0xFFFFFFFF),
          ),
          onPressed: () {
            context.push('/exams/test/${exam.contentId}');
          },
        ),
      ],
    );
  }
}
