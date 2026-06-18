import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import '../providers/exam_providers.dart';
import '../repositories/exam_repository.dart';
import '../widgets/exam_mode_option_card.dart';

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
  bool? _selectedIsQuizMode = false;
  bool _isOpen = true;

  void _handleClose() {
    if (!_isOpen) return;
    setState(() {
      _isOpen = false;
    });
  }

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
    final l10n = L10n.of(context);

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

    final bool isResuming =
        exam != null &&
        (exam.pausedAttemptsCount > 0 && !exam.disableAttemptResume);

    final bool showModeSelection =
        !isMetadataLoading &&
        exam != null &&
        exam.enableQuizMode == true &&
        !isResuming;

    final bool isButtonEnabled =
        !isMetadataLoading &&
        (!showModeSelection || _selectedIsQuizMode != null);

    return AppBottomSheet(
      isOpen: _isOpen,
      onClose: _handleClose,
      onAnimationComplete: widget.onClose,
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
            padding: EdgeInsets.only(bottom: design.spacing.lg),
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
                SizedBox(height: design.spacing.md),
                // Handle Bar
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: design.spacing.xl * 1.5,
                    height: 4,
                    decoration: BoxDecoration(
                      color: design.colors.border,
                      borderRadius: BorderRadius.circular(design.radius.full),
                    ),
                  ),
                ),

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

                          // Inline Mode Selection Options
                          if (showModeSelection) ...[
                            ExamModeOptionCard(
                              title: l10n.examModeRegularTitle,
                              description: l10n.examModeRegularDesc,
                              icon: LucideIcons.fileText,
                              isSelected: _selectedIsQuizMode == false,
                              onTap: () {
                                setState(() {
                                  _selectedIsQuizMode = false;
                                });
                              },
                            ),
                            SizedBox(height: design.spacing.md),
                            ExamModeOptionCard(
                              title: l10n.examModeQuizTitle,
                              description: l10n.examModeQuizDesc,
                              icon: LucideIcons.checkCircle,
                              isSelected: _selectedIsQuizMode == true,
                              onTap: () {
                                setState(() {
                                  _selectedIsQuizMode = true;
                                });
                              },
                            ),
                            SizedBox(height: design.spacing.lg),
                          ],

                          // Start Exam Online Option Button
                          if ((exam?.allowRetake ?? true) ||
                              !((lesson?.hasAttempts ?? false) &&
                                  (exam?.pausedAttemptsCount ?? 0) == 0))
                            AppSemantics.button(
                              label: isResuming
                                  ? 'Resume Exam Online'
                                  : 'Start Exam Online',
                              onTap: isButtonEnabled
                                  ? () async {
                                      ref
                                          .read(examAttemptProvider.notifier)
                                          .reset();
                                      final isQuizMode =
                                          _selectedIsQuizMode ?? false;
                                      await widget.onStartAttempt(isQuizMode);
                                    }
                                  : null,
                              enabled: isButtonEnabled,
                              child: GestureDetector(
                                onTap: isButtonEnabled
                                    ? () async {
                                        ref
                                            .read(examAttemptProvider.notifier)
                                            .reset();
                                        final isQuizMode =
                                            _selectedIsQuizMode ?? false;
                                        await widget.onStartAttempt(isQuizMode);
                                      }
                                    : null,
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(design.spacing.md),
                                  decoration: BoxDecoration(
                                    color: isButtonEnabled
                                        ? design.colors.primary
                                        : design.colors.border.withValues(
                                            alpha: 0.5,
                                          ),
                                    borderRadius: BorderRadius.circular(
                                      design.radius.lg,
                                    ),
                                  ),
                                  child: AppText.body(
                                    isResuming
                                        ? l10n.resumeExamOnline
                                        : l10n.startExamOnline,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isButtonEnabled
                                          ? design.colors.onPrimary
                                          : design.colors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(height: design.spacing.xs),
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
