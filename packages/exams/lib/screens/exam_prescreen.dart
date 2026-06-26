import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';
import '../providers/exam_providers.dart';
import '../repositories/exam_repository.dart';
import '../widgets/exam_mode_option_card.dart';
import '../widgets/exam_prescreen_metadata.dart';
import '../widgets/exam_prescreen_action_button.dart';

class ExamPrescreen extends ConsumerStatefulWidget {
  final String testId;
  final LessonDto? lesson;
  final VoidCallback onClose;
  final Future<void> Function(bool isQuizMode) onStartAttempt;

  const ExamPrescreen({
    super.key,
    required this.testId,
    this.lesson,
    required this.onClose,
    required this.onStartAttempt,
  });

  @override
  ConsumerState<ExamPrescreen> createState() => _ExamPrescreenState();
}

class _ExamPrescreenState extends ConsumerState<ExamPrescreen> {
  bool _isModeSheetOpen = false;

  @override
  void initState() {
    super.initState();
    // If there is already an active in-progress attempt for this exam,
    // skip the prescreen entirely and go straight to the player.
    Future.microtask(() {
      if (!mounted) return;

      final current = ref.read(examAttemptProvider);
      final examId = current.exam?.id;
      final isActiveAttempt =
          current.status == ExamAttemptStatus.inProgress ||
          current.status == ExamAttemptStatus.submitting;

      if (isActiveAttempt && examId == widget.testId) {
        widget.onStartAttempt(current.isQuizMode);
        return;
      }

      // Preload exam details for the metadata display
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final lessonDetailAsync = ref.watch(lessonDetailProvider(widget.testId));
    final fetchedLesson = lessonDetailAsync.valueOrNull?.toDto();
    final lesson = widget.lesson?.mergeWith(fetchedLesson) ?? fetchedLesson;

    if (lesson == null && lessonDetailAsync.isLoading) {
      return Container(
        color: design.colors.overlay, // Semi-transparent backdrop
        child: const Center(child: AppLoadingIndicator()),
      );
    }

    final exam = lesson?.exam;

    // Metadata is loading if we don't have the exam data yet and we are still fetching.
    // This guarantees it shimmers immediately on frame 1 instead of showing an empty layout.
    final bool isMetadataLoading =
        exam == null && !(lesson?.isDetailFetched ?? false);

    // Parse duration format from e.g. "03:00:00" to "180 mins"
    String durationVal = isMetadataLoading ? '120' : '--';
    String? durationSuffix = isMetadataLoading ? 'mins' : null;
    if (exam?.duration != null || lesson?.duration != null) {
      final rawDuration = exam?.duration ?? lesson?.duration ?? '';
      final parts = rawDuration.split(':');
      if (parts.length == 3) {
        final hours = int.tryParse(parts[0]) ?? 0;
        final mins = int.tryParse(parts[1]) ?? 0;
        final totalMinutes = (hours * 60) + mins;
        durationVal = '$totalMinutes';
        durationSuffix = 'mins';
      }
    }
    // Calculate total marks dynamically from real exam metadata
    String totalMarksVal = isMetadataLoading ? '100' : '--';
    if (exam != null) {
      final double mark = double.tryParse(exam.markPerQuestion ?? '') ?? 0.0;
      if (mark > 0 && exam.questionCount > 0) {
        final total = exam.questionCount * mark;
        totalMarksVal = '${total % 1 == 0 ? total.toInt() : total}';
      } else if (exam.questionCount > 0) {
        // Fallback or general representation if markPerQuestion isn't set
        totalMarksVal = '${exam.questionCount}';
      }
    }

    String correctMarks = isMetadataLoading ? '+1.0 Marks' : '--';
    String wrongMarks = isMetadataLoading ? '-0.5 Marks' : '--';
    if (exam != null) {
      final double mark = double.tryParse(exam.markPerQuestion ?? '') ?? 0.0;
      correctMarks = '+${mark % 1 == 0 ? mark.toInt() : mark} Marks';

      final double neg = double.tryParse(exam.negativeMarks ?? '') ?? 0.0;
      final String negVal = neg % 1 == 0
          ? neg.toInt().abs().toString()
          : neg.abs().toString();
      wrongMarks = neg == 0.0
          ? '0 Marks'
          : '-$negVal Mark${neg == 1.0 ? '' : 's'}';
    }

    String startDateStr = isMetadataLoading ? 'Oct 14, 2024, 10:00 AM' : '';
    String endDateStr = isMetadataLoading ? 'Oct 14, 2024, 12:00 PM' : '';
    if (exam?.startDate != null || exam?.endDate != null) {
      try {
        startDateStr = exam?.startDate != null
            ? DateFormatter.formatDateTime(
                DateTime.parse(exam!.startDate!).toLocal(),
              )
            : 'N/A';
        endDateStr = exam?.endDate != null
            ? DateFormatter.formatDateTime(
                DateTime.parse(exam!.endDate!).toLocal(),
              )
            : 'N/A';
      } catch (_) {}
    }

    final bool isResuming =
        exam != null &&
        (exam.pausedAttemptsCount > 0 && !exam.disableAttemptResume);

    final bool showModeSelection =
        !isMetadataLoading &&
        exam != null &&
        exam.enableQuizMode == true &&
        !isResuming;

    final bool isButtonEnabled =
        !isMetadataLoading && (!showModeSelection || _isModeSheetOpen == false);

    return Stack(
      children: [
        LessonDetailShell(
          title:
              lesson?.title ?? exam?.title ?? L10n.of(context).examDetailsTitle,
          onBack: widget.onClose,
          stickyFooter: true,
          backgroundColor: design.colors.card,
          bottomBar: isMetadataLoading
              ? null
              : ((exam?.allowRetake ?? true) ||
                    !((lesson?.hasAttempts ?? false) &&
                        (exam?.pausedAttemptsCount ?? 0) == 0))
              ? Container(
                  color: design.colors.card,
                  padding: EdgeInsets.fromLTRB(
                    design.spacing.md,
                    design.spacing.md,
                    design.spacing.md,
                    design.spacing.lg,
                  ),
                  child: ExamPrescreenActionButton(
                    isButtonEnabled: isButtonEnabled,
                    isResuming: isResuming,
                    onTap: isButtonEnabled
                        ? () async {
                            if (showModeSelection) {
                              setState(() {
                                _isModeSheetOpen = true;
                              });
                            } else {
                              ref.read(examAttemptProvider.notifier).reset();
                              await widget.onStartAttempt(false);
                            }
                          }
                        : null,
                  ),
                )
              : null,
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                design.spacing.lg,
                design.spacing.md,
                design.spacing.lg,
                design.spacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ExamPrescreenMetadata(
                    isMetadataLoading: isMetadataLoading,
                    title: null,
                    startDateStr: startDateStr,
                    endDateStr: endDateStr,
                    questionCountStr: '${exam?.questionCount ?? '--'}',
                    durationVal: durationVal,
                    durationSuffix: durationSuffix,
                    totalMarksVal: totalMarksVal,
                    correctMarks: correctMarks,
                    wrongMarks: wrongMarks,
                  ),
                  SizedBox(height: design.spacing.lg),
                ],
              ),
            ),
          ),
        ),
        if (showModeSelection)
          AppBottomSheet(
            isOpen: _isModeSheetOpen,
            onClose: () => setState(() => _isModeSheetOpen = false),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                design.spacing.sm,
                0,
                design.spacing.sm,
                design.spacing.md,
              ),
              child: SafeArea(
                top: false,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    design.spacing.lg,
                    design.spacing.md,
                    design.spacing.lg,
                    design.spacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color: design.colors.card,
                    borderRadius: BorderRadius.all(
                      Radius.circular(design.radius.xxl),
                    ),
                    boxShadow: design.shadows.floating,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: design.spacing.xl * 1.5,
                          height: 4,
                          decoration: BoxDecoration(
                            color: design.colors.border,
                            borderRadius: BorderRadius.circular(
                              design.radius.full,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: design.spacing.xl),
                      ExamModeOptionCard(
                        title: l10n.examModeRegularTitle,
                        description: l10n.examModeRegularDesc,
                        icon: LucideIcons.fileText,
                        isSelected: false,
                        onTap: () async {
                          setState(() => _isModeSheetOpen = false);
                          ref.read(examAttemptProvider.notifier).reset();
                          await widget.onStartAttempt(false);
                        },
                      ),
                      SizedBox(height: design.spacing.md),
                      ExamModeOptionCard(
                        title: l10n.examModeQuizTitle,
                        description: l10n.examModeQuizDesc,
                        icon: LucideIcons.checkCircle,
                        isSelected: false,
                        onTap: () async {
                          setState(() => _isModeSheetOpen = false);
                          ref.read(examAttemptProvider.notifier).reset();
                          await widget.onStartAttempt(true);
                        },
                      ),
                      SizedBox(height: design.spacing.lg),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
