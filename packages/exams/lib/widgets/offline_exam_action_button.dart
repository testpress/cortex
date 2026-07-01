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
      debugPrint(
        '[OfflineDebug] Initiating download for exam: ${widget.examId}',
      );
      final repo = await ref.read(
        offlineExamRepositoryFactoryProvider(widget.examId).future,
      );
      await repo.downloadExam(widget.examData);

      debugPrint('[OfflineDebug] Exam download completed successfully!');
    } catch (e) {
      debugPrint("[OfflineDebug] Failed to download offline exam: $e");
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
    final dbFuture = ref.watch(appDatabaseProvider.future);

    return FutureBuilder<AppDatabase>(
      future: dbFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final db = snapshot.data!;

        return StreamBuilder<OfflineExamDownloadsTableData?>(
          stream: db.watchDownloadByContentId(widget.examId),
          builder: (context, attemptSnapshot) {
            final download = attemptSnapshot.data;

            if (_isDownloading) {
              return Padding(
                padding: EdgeInsets.only(bottom: design.spacing.md),
                child: _buildButtonContainer(
                  context,
                  l10n.downloadingExam,
                  null, // Disabled
                  isPrimary: false,
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
                child: AppSemantics.button(
                  label: label,
                  onTap: widget.onStartOfflineAttempt,
                  child: _buildButtonContainer(
                    context,
                    label,
                    widget.onStartOfflineAttempt,
                    isPrimary: true,
                    bgColorOverride:
                        design.colors.accent4, // Green/Teal accent for offline
                  ),
                ),
              );
            }

            // Not downloaded yet, or was fully synced and cleared
            final downloadLabel = l10n.downloadExamOffline;
            return Padding(
              padding: EdgeInsets.only(bottom: design.spacing.md),
              child: AppSemantics.button(
                label: downloadLabel,
                onTap: _downloadExam,
                child: _buildButtonContainer(
                  context,
                  downloadLabel,
                  _downloadExam,
                  isPrimary: false,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildButtonContainer(
    BuildContext context,
    String label,
    VoidCallback? action, {
    required bool isPrimary,
    Color? bgColorOverride,
  }) {
    final design = Design.of(context);

    final Color bgColor;
    final Color textColor;
    final Border? border;

    if (action == null) {
      bgColor = design.colors.border.withAlpha(128); // 0.5 opacity
      textColor = design.colors.textSecondary;
      border = null;
    } else if (bgColorOverride != null) {
      bgColor = bgColorOverride;
      textColor =
          design.colors.onPrimary; // Assumes accent colors have white text
      border = null;
    } else if (isPrimary) {
      bgColor = design.colors.primary;
      textColor = design.colors.onPrimary;
      border = null;
    } else {
      bgColor = design.colors.surface;
      textColor = design.colors.primary;
      border = Border.all(color: design.colors.primary, width: 1.5);
    }

    return GestureDetector(
      onTap: action,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(design.spacing.md),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(design.radius.lg),
          border: border,
        ),
        child: AppText.body(
          label,
          textAlign: TextAlign.center,
          style: design.typography.body.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
