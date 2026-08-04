import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

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
            AppSemantics.button(
              label: l10n.actionGoBack,
              child: AppFocusable(
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
      error: (err, stack) => Center(child: AppErrorView(error: err)),
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

    final title = exam.title;

    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.md),
      child: AppCard(
        padding: EdgeInsets.all(design.spacing.md),
        child: AppSemantics.container(
          label: title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ExamCardHeader(exam: exam),
              SizedBox(height: design.spacing.md),
              _ExamCardStats(exam: exam),
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
  final OfflineExamDownloadsTableData exam;

  const _ExamCardHeader({required this.exam});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final status = exam.status;

    // Badge configuration per status
    final Color badgeBg;
    final Color badgeFg;
    final Widget badgeLeading;
    final String badgeLabel;

    switch (status) {
      case 'IN_PROGRESS':
        badgeBg = design.colors.primary.withValues(alpha: 0.12);
        badgeFg = design.colors.primary;
        badgeLeading = Icon(LucideIcons.pencil, size: 14, color: badgeFg);
        badgeLabel = l10n.inProgressStatus;
        break;
      case 'PENDING_SYNC':
        badgeBg = design.colors.warning.withValues(alpha: 0.15);
        badgeFg = design.colors.warning;
        badgeLeading = Icon(LucideIcons.clock, size: 14, color: badgeFg);
        badgeLabel = l10n.pendingSyncStatus;
        break;
      case 'SYNCING':
        badgeBg = design.colors.warning.withValues(alpha: 0.15);
        badgeFg = design.colors.warning;
        badgeLeading = SizedBox(
          width: 14,
          height: 14,
          child: FittedBox(child: AppLoadingIndicator(color: badgeFg)),
        );
        badgeLabel = l10n.syncingStatus;
        break;
      case 'SYNCED':
        badgeBg = design.colors.success.withValues(alpha: 0.1);
        badgeFg = design.colors.success;
        badgeLeading = Icon(LucideIcons.checkCircle2, size: 14, color: badgeFg);
        badgeLabel = l10n.submittedStatus;
        break;
      default: // DOWNLOADED
        badgeBg = design.colors.success.withValues(alpha: 0.1);
        badgeFg = design.colors.success;
        badgeLeading = Icon(LucideIcons.checkCircle2, size: 14, color: badgeFg);
        badgeLabel = l10n.downloadedStatus;
    }

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
            children: [AppText.cardTitle(exam.title)],
          ),
        ),
        SizedBox(width: design.spacing.sm),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.sm,
            vertical: design.spacing.xs,
          ),
          decoration: BoxDecoration(
            color: badgeBg,
            border: Border.all(color: badgeFg.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(design.radius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              badgeLeading,
              SizedBox(width: design.spacing.xs),
              AppText.labelSmall(badgeLabel, color: badgeFg),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExamCardStats extends StatelessWidget {
  final OfflineExamDownloadsTableData exam;

  const _ExamCardStats({required this.exam});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final totalMarks =
        exam.questionCount *
        (double.tryParse(exam.markPerQuestion ?? '1') ?? 1.0);
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
                    AppText.labelBold(exam.duration),
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
                    AppText.labelBold('${exam.questionCount}'),
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
            final shouldDelete = await showConfirmationDialog(
              context,
              title: l10n.deleteExamTitle,
              content: l10n.deleteExamConfirmationMessage,
              confirmText: l10n.deleteAction,
            );

            if (shouldDelete == true && context.mounted) {
              await ref.read(offlineExamsProvider.notifier).deleteExam(exam.id);
              if (context.mounted) {
                AppToast.show(context, message: l10n.examDeletedToast);
              }
            }
          },
        ),
        if (exam.status != 'SYNCED') ...[
          SizedBox(width: design.spacing.sm),
          AppButton(
            padding: EdgeInsets.symmetric(
              horizontal: design.spacing.md,
              vertical: design.spacing.xs,
            ),
            label: l10n.attendExamAction,
            variant: AppButtonVariant.primary,
            leading: Icon(
              LucideIcons.play,
              size: 18,
              color: design.colors.onPrimary,
            ),
            onPressed: () {
              context.push('/exams/test/${exam.contentId}?isOffline=true');
            },
          ),
        ],
      ],
    );
  }
}
