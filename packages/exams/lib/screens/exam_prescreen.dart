import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import '../providers/exam_providers.dart';
import '../repositories/exam_repository.dart';
import '../widgets/exam_mode_selection_dialog.dart';

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
      if (widget.lesson?.slug != null) {
        ref.read(examDetailProvider(widget.lesson!.slug!).future);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final lessonDetailAsync = ref.watch(lessonDetailProvider(widget.testId));
    final lesson = widget.lesson ?? lessonDetailAsync.valueOrNull?.toDto();

    if (lesson == null && lessonDetailAsync.isLoading) {
      return Container(
        color: design.colors.overlay, // Semi-transparent backdrop
        child: const Center(child: AppLoadingIndicator()),
      );
    }

    final fetchedLesson = lessonDetailAsync.valueOrNull;
    final slug = lesson?.slug ?? fetchedLesson?.slug;

    AsyncValue<ExamDto>? examDetailAsync;
    if (slug != null) {
      examDetailAsync = ref.watch(examDetailProvider(slug));
    }

    final exam = examDetailAsync?.valueOrNull;

    // Metadata is loading if we don't have the exam data yet and no errors have occurred.
    // This guarantees it shimmers immediately on frame 1 instead of showing an empty layout.
    final bool hasError =
        (examDetailAsync?.hasError ?? false) || lessonDetailAsync.hasError;
    final bool isMetadataLoading = exam == null && !hasError;

    // Parse duration format from e.g. "03:00:00" to "180 mins"
    String durationText = 'N/A';
    if (exam?.duration != null || lesson?.duration != null) {
      final rawDuration = exam?.duration ?? lesson?.duration ?? '';
      final parts = rawDuration.split(':');
      if (parts.length == 3) {
        final hours = int.tryParse(parts[0]) ?? 0;
        final minutes = int.tryParse(parts[1]) ?? 0;
        final totalMinutes = (hours * 60) + minutes;
        durationText = '$totalMinutes mins';
      }
    }
    // Calculate total marks dynamically from real exam metadata
    String totalMarksText = 'Marks: --';
    if (exam != null) {
      final double mark = double.tryParse(exam.markPerQuestion ?? '') ?? 0.0;
      if (mark > 0 && exam.questionCount > 0) {
        final total = exam.questionCount * mark;
        totalMarksText = 'Marks: ${total % 1 == 0 ? total.toInt() : total}';
      } else if (exam.questionCount > 0) {
        // Fallback or general representation if markPerQuestion isn't set
        totalMarksText = 'Marks: ${exam.questionCount}';
      }
    }

    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: design.colors.overlay, // Semi-transparent overlay backdrop
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {}, // Prevent click propagation inside the card
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: design.colors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(design.radius.xl),
                topRight: Radius.circular(design.radius.xl),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.lg,
                    vertical: design.spacing.md,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.title(
                        'Choose an option',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: widget.onClose,
                        child: Icon(
                          LucideIcons.x,
                          color: design.colors.textSecondary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: design.colors.border),

                Padding(
                  padding: EdgeInsets.all(design.spacing.lg),
                  child: SkeletonizerConfig(
                    data: SkeletonizerConfigData(
                      effect: ShimmerEffect(
                        baseColor: design.colors.skeleton,
                        highlightColor: design.colors.onSkeleton,
                        duration: MotionPreferences.duration(
                          context,
                          const Duration(milliseconds: 800),
                        ),
                      ),
                    ),
                    child: Skeletonizer(
                      enabled: isMetadataLoading,
                      child: Column(
                        children: [
                          // Metadata Info (Clean text-only header layout)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.headline(
                                lesson?.title ??
                                    exam?.title ??
                                    'Question Paper',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  color: design.colors.textPrimary,
                                ),
                              ),
                              SizedBox(height: design.spacing.sm),
                              Row(
                                children: [
                                  if (isMetadataLoading ||
                                      exam?.questionCount != null) ...[
                                    // Questions Count
                                    Icon(
                                      LucideIcons.fileText,
                                      size: 16,
                                      color: design.colors.textSecondary,
                                    ),
                                    SizedBox(width: design.spacing.xs),
                                    AppText.caption(
                                      '${exam?.questionCount ?? '--'} Questions',
                                      color: design.colors.textSecondary,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(width: design.spacing.lg),
                                  ],

                                  if (isMetadataLoading ||
                                      durationText != 'N/A') ...[
                                    // Duration
                                    Icon(
                                      LucideIcons.clock,
                                      size: 16,
                                      color: design.colors.textSecondary,
                                    ),
                                    SizedBox(width: design.spacing.xs),
                                    AppText.caption(
                                      durationText,
                                      color: design.colors.textSecondary,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(width: design.spacing.lg),
                                  ],

                                  if (isMetadataLoading ||
                                      totalMarksText != 'Marks: --') ...[
                                    // Marks
                                    AppText.caption(
                                      totalMarksText,
                                      color: design.colors.textSecondary,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: design.spacing.lg),

                          // Start Exam Online Option Button
                          if ((exam?.allowRetake ?? true) ||
                              !((lesson?.hasAttempts ?? false) &&
                                  (exam?.pausedAttemptsCount ?? 0) == 0))
                            GestureDetector(
                              onTap: () async {
                                if (isMetadataLoading) return;

                                final bool isResuming = ((exam?.pausedAttemptsCount ?? 0) > 0 && !(exam?.disableAttemptResume ?? false));

                                if (!isResuming && exam?.enableQuizMode == true) {
                                  showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel: 'Dismiss',
                                    pageBuilder: (context, animation, secondaryAnimation) => ExamModeSelectionDialog(
                                      onSelectRegular: () async {
                                        Navigator.pop(context);
                                        ref.read(examAttemptProvider.notifier).reset();
                                        await widget.onStartAttempt(false);
                                      },
                                      onSelectQuiz: () async {
                                        Navigator.pop(context);
                                        ref.read(examAttemptProvider.notifier).reset();
                                        await widget.onStartAttempt(true);
                                      },
                                    ),
                                  );
                                } else {
                                  ref.read(examAttemptProvider.notifier).reset();
                                  await widget.onStartAttempt(false);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(design.spacing.md),
                                decoration: BoxDecoration(
                                  color: design.colors.primary,
                                  borderRadius: BorderRadius.circular(
                                    design.radius.lg,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                        design.spacing.sm,
                                      ),
                                      decoration: BoxDecoration(
                                        color: design.colors.onPrimary
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(
                                          design.radius.md,
                                        ),
                                      ),
                                      child: Icon(
                                        LucideIcons.play,
                                        color: design.colors.onPrimary,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(width: design.spacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ((exam?.pausedAttemptsCount ?? 0) >
                                                        0 &&
                                                    !(exam?.disableAttemptResume ??
                                                        false))
                                                ? 'Resume Exam Online'
                                                : 'Start Exam Online',
                                            style: TextStyle(
                                              color: design.colors.onPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            ((exam?.pausedAttemptsCount ?? 0) >
                                                        0 &&
                                                    !(exam?.disableAttemptResume ??
                                                        false))
                                                ? 'Resume from where you left off'
                                                : 'Take the test in exam mode with timer',
                                            style: TextStyle(
                                              color: design.colors.onPrimary
                                                  .withValues(alpha: 0.8),
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
