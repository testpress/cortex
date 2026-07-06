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

  Future<void> _downloadExam() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final repo = await ref.read(
        offlineExamRepositoryFactoryProvider(widget.examId).future,
      );
      await repo.downloadExam(widget.examData);
    } catch (e) {
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
    final repoAsync = ref.watch(
      offlineExamRepositoryFactoryProvider(widget.examId),
    );

    return repoAsync.when(
      data: (repo) {
        return StreamBuilder<OfflineExamDownloadsTableData?>(
          stream: repo.watchDownloadStatus(),
          builder: (context, attemptSnapshot) {
            final download = attemptSnapshot.data;

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
              if (download.status == 'PENDING_SYNC') {
                bool isPastDeadline = false;

                final endDateStr = widget.examData.endDate;
                final gracePeriod = widget.examData.gracePeriod;
                final gracePeriodMinutes =
                    int.tryParse(gracePeriod ?? '0') ?? 0;

                if (endDateStr != null && endDateStr.isNotEmpty) {
                  final endDate = DateTime.tryParse(endDateStr);
                  if (endDate != null) {
                    final absoluteDeadline = endDate.add(
                      Duration(minutes: gracePeriodMinutes),
                    );
                    if (DateTime.now().isAfter(absoluteDeadline)) {
                      isPastDeadline = true;
                    }
                  }
                }

                if (isPastDeadline) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: design.spacing.md),
                    child: _buildBanner(
                      context,
                      l10n.deadlinePassedCannotSync,
                      design.colors.error,
                      design.colors.onError,
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(bottom: design.spacing.md),
                    child: _buildBanner(
                      context,
                      l10n.pendingSyncConnectToUpload,
                      design.colors.warning,
                      design.colors.onWarning,
                    ),
                  );
                }
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
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
    );
  }

  Widget _buildBanner(
    BuildContext context,
    String message,
    Color bgColor,
    Color textColor,
  ) {
    final design = Design.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(design.radius.lg),
      ),
      child: AppText.body(
        message,
        textAlign: TextAlign.center,
        style: design.typography.body.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
