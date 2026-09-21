import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'exam_prescreen_action_button.dart';
import 'offline_exam_action_button.dart';

/// Bottom action bar for ExamPrescreen handling offline and online start/resume/retake actions.
class ExamPrescreenBottomBar extends StatelessWidget {
  final String testId;
  final ExamDto? exam;
  final LessonDto? lesson;
  final String attemptsUrl;
  final bool isOfflineOnly;
  final bool isMetadataLoading;
  final bool isAttemptsLoading;
  final bool isButtonEnabled;
  final bool isResuming;
  final bool isRetaking;
  final VoidCallback? onStartOnline;
  final VoidCallback? onRetakeIncorrect;
  final Future<void> Function() onStartOffline;

  const ExamPrescreenBottomBar({
    super.key,
    required this.testId,
    required this.exam,
    required this.lesson,
    required this.attemptsUrl,
    required this.isOfflineOnly,
    required this.isMetadataLoading,
    required this.isAttemptsLoading,
    required this.isButtonEnabled,
    required this.isResuming,
    required this.isRetaking,
    required this.onStartOnline,
    required this.onRetakeIncorrect,
    required this.onStartOffline,
  });

  /// Helper to determine if the bottom bar should be hidden during loading
  static bool shouldHideBottomBar({
    required bool isMetadataLoading,
    required bool isAttemptsLoading,
    required bool isOfflineOnly,
  }) {
    return isMetadataLoading || (!isOfflineOnly && isAttemptsLoading);
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final bool canAttempt =
        isOfflineOnly ||
        (exam?.allowRetake ?? true) ||
        !((lesson?.hasAttempts ?? false) &&
            (exam?.pausedAttemptsCount ?? 0) == 0);

    if (!canAttempt) {
      return Container(
        color: design.colors.card,
        padding: EdgeInsets.fromLTRB(
          design.spacing.md,
          design.spacing.md,
          design.spacing.md,
          design.spacing.lg,
        ),
        child: Center(
          child: AppText.label(
            l10n.examMaxAttemptsReached,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final bool isAssessment = lesson?.type == LessonType.assessment;

    return Container(
      color: design.colors.card,
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        design.spacing.md,
        design.spacing.md,
        design.spacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (exam != null && !isAssessment)
            OfflineExamActionButton(
              examId: testId,
              examData: exam!,
              attemptsUrl: attemptsUrl,
              onStartOfflineAttempt: onStartOffline,
            ),
          if (!isOfflineOnly)
            ExamPrescreenActionButton(
              isButtonEnabled: isButtonEnabled,
              isResuming: isResuming,
              isRetaking: isRetaking,
              onTap: isButtonEnabled ? onStartOnline : null,
              onRetakeIncorrectTap: isButtonEnabled ? onRetakeIncorrect : null,
            ),
        ],
      ),
    );
  }
}
