import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import '../providers/exam_providers.dart';

class ExamPrescreen extends ConsumerStatefulWidget {
  final String testId;
  final LessonDto? lesson;
  final VoidCallback onClose;
  final Future<void> Function() onStartAttempt;

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
    // Preload exam details
    Future.microtask(() {
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

    final slug = lesson?.slug;

    AsyncValue<ExamDto>? examDetailAsync;
    if (slug != null) {
      examDetailAsync = ref.watch(examDetailProvider(slug));
    }

    final exam = examDetailAsync?.valueOrNull;

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
                  child: Column(
                    children: [
                      // Metadata Info (Clean text-only header layout)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.headline(
                            lesson?.title ?? exam?.title ?? 'Question Paper',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: design.colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: design.spacing.sm),
                          Row(
                            children: [
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

                              // Marks
                              AppText.caption(
                                totalMarksText, // Default total marks
                                color: design.colors.textSecondary,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: design.spacing.lg),

                      // Start Exam Online Option Button
                      GestureDetector(
                        onTap: () async {
                          ref.read(examAttemptProvider.notifier).reset();
                          await widget.onStartAttempt();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(design.spacing.md),
                          decoration: BoxDecoration(
                            color: design.colors.primary, // Premium dynamic brand color
                            borderRadius: BorderRadius.circular(design.radius.lg),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(design.spacing.sm),
                                decoration: BoxDecoration(
                                  color: design.colors.onPrimary.withValues(alpha: 0.15), // Light semi-transparent overlay
                                  borderRadius: BorderRadius.circular(design.radius.md),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start Exam Online',
                                      style: TextStyle(
                                        color: design.colors.onPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Take the test in exam mode with timer',
                                      style: TextStyle(
                                        color: design.colors.onPrimary.withValues(alpha: 0.8),
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
                      SizedBox(height: design.spacing.md),

                      GestureDetector(
                        onTap: () {
                          // PDF Download capability can be wired here or triggered as a custom callback
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(design.spacing.md),
                          decoration: BoxDecoration(
                            color: design.colors.card, // Premium adaptive card background
                            borderRadius: BorderRadius.circular(design.radius.lg),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(design.spacing.sm),
                                decoration: BoxDecoration(
                                  color: design.isDark ? const Color(0x1AFFFFFF) : const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(design.radius.md),
                                ),
                                child: Icon(
                                  LucideIcons.download,
                                  color: design.isDark ? design.colors.textPrimary : const Color(0xFF475569),
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: design.spacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Download PDF',
                                      style: TextStyle(
                                        color: design.colors.textPrimary, // Adaptive primary text
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Save question paper for offline practice',
                                      style: TextStyle(
                                        color: design.colors.textSecondary, // Adaptive secondary text
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
