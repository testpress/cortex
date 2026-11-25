import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

import '../providers/exam_providers.dart';

class OfflineExamActionButton extends ConsumerStatefulWidget {
  final String examId; // This is the contentId/lessonId
  final ExamDto examData;
  final String attemptsUrl;
  final VoidCallback onStartOfflineAttempt;

  const OfflineExamActionButton({
    super.key,
    required this.examId,
    required this.examData,
    required this.attemptsUrl,
    required this.onStartOfflineAttempt,
  });

  @override
  ConsumerState<OfflineExamActionButton> createState() =>
      _OfflineExamActionButtonState();
}

class _OfflineExamActionButtonState
    extends ConsumerState<OfflineExamActionButton> {
  bool _isDownloading = false;
  bool _isSyncing = false;

  Future<void> _downloadExam() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final repo = await ref.read(
        offlineExamRepositoryFactoryProvider(widget.examId).future,
      );
      await repo.downloadExam(widget.examData);
    } catch (e, st) {
      ref.read(sentryServiceProvider).captureException(e, stackTrace: st);
      debugPrint("Failed to download offline exam: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final downloadAsync = ref.watch(offlineExamDownloadProvider(widget.examId));

    return downloadAsync.when(
      data: (download) {
        if (_isDownloading) {
          return Padding(
            padding: EdgeInsets.only(bottom: design.spacing.md),
            child: AppButton.secondary(
              label: l10n.downloadingExam,
              fullWidth: true,
              loading: true,
              onPressed: null,
            ),
          );
        }

        if (download != null) {
          if (download.status == 'SYNCED') {
            return const SizedBox.shrink();
          }

          if (download.status == 'PENDING_SYNC' ||
              download.status == 'SYNCING') {
            final isSyncing = _isSyncing || download.status == 'SYNCING';
            return Padding(
              padding: EdgeInsets.only(bottom: design.spacing.md),
              child: AppButton.primary(
                label: l10n.syncExamAction,
                fullWidth: true,
                loading: isSyncing,
                leading: isSyncing
                    ? null
                    : const Icon(LucideIcons.refreshCw, size: 18),
                onPressed: isSyncing
                    ? null
                    : () async {
                        setState(() {
                          _isSyncing = true;
                        });
                        final success = await ref
                            .read(offlineExamsProvider.notifier)
                            .syncExam(download.id);
                        if (!context.mounted) return;
                        setState(() {
                          _isSyncing = false;
                        });
                        if (success) {
                          AppToast.show(
                            context,
                            message: l10n.examSyncSuccessToast,
                          );
                        } else {
                          AppToast.show(
                            context,
                            message: l10n.examSyncFailedToast,
                            isError: true,
                          );
                        }
                      },
              ),
            );
          }

          final isResuming = download.status == 'IN_PROGRESS';
          final label = isResuming
              ? l10n.resumeOfflineExam
              : l10n.startOfflineExam;

          return Padding(
            padding: EdgeInsets.only(bottom: design.spacing.md),
            child: AppButton.primary(
              label: label,
              onPressed: widget.onStartOfflineAttempt,
              fullWidth: true,
              backgroundColor:
                  design.colors.accent4, // Green/Teal accent for offline
            ),
          );
        }

        // Not downloaded yet, or was fully synced and cleared
        final downloadLabel = l10n.downloadExamOffline;
        return Padding(
          padding: EdgeInsets.only(bottom: design.spacing.md),
          child: AppButton.secondary(
            label: downloadLabel,
            onPressed: _downloadExam,
            fullWidth: true,
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
    );
  }
}
