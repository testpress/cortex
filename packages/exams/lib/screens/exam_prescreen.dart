import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import '../providers/exam_providers.dart';
import '../repositories/exam_repository.dart';
import '../widgets/exam_history_section.dart';
import '../widgets/exam_mode_bottom_sheet.dart';
import '../widgets/exam_prescreen_bottom_bar.dart';
import '../widgets/exam_prescreen_metadata.dart';

class ExamPrescreen extends ConsumerStatefulWidget {
  final String testId;
  final LessonDto? lesson;
  final VoidCallback onClose;
  final Future<void> Function(bool isQuizMode, {bool isPartial, bool isOffline})
  onStartAttempt;
  final bool isOfflineOnly;

  const ExamPrescreen({
    super.key,
    required this.testId,
    this.lesson,
    required this.onClose,
    required this.onStartAttempt,
    this.isOfflineOnly = false,
  });

  @override
  ConsumerState<ExamPrescreen> createState() => _ExamPrescreenState();
}

class _ExamPrescreenState extends ConsumerState<ExamPrescreen> {
  bool _isModeSheetOpen = false;
  bool _selectedRetakeIsPartial = false;

  @override
  void initState() {
    super.initState();
    // If there is already an active in-progress attempt for this exam,
    // skip the prescreen entirely and go straight to the player.
    Future.microtask(() async {
      if (!mounted) return;

      final current = ref.read(examAttemptProvider);
      final examId = current.exam?.id;
      final isActiveAttempt =
          current.status == ExamAttemptStatus.inProgress ||
          current.status == ExamAttemptStatus.submitting;

      if (isActiveAttempt && examId == widget.testId) {
        await _startAttemptAndRefresh(current.isQuizMode);
        return;
      }
    });
  }

  Future<void> _startAttemptAndRefresh(
    bool isQuizMode, {
    bool isPartial = false,
    bool isOffline = false,
  }) async {
    await widget.onStartAttempt(
      isQuizMode,
      isPartial: isPartial,
      isOffline: isOffline,
    );
    if (!mounted) return;
    final attemptsUrl = ApiEndpoints.lessonAttempts(widget.testId);
    ref.invalidate(examAttemptsProvider(attemptsUrl));
    ref.invalidate(lessonDetailProvider(widget.testId));
  }

  void _handleOnlineStart({
    required bool isPartial,
    required bool showModeSelection,
  }) async {
    if (showModeSelection) {
      setState(() {
        _selectedRetakeIsPartial = isPartial;
        _isModeSheetOpen = true;
      });
    } else {
      ref.read(examAttemptProvider.notifier).reset();
      await _startAttemptAndRefresh(false, isPartial: isPartial);
    }
  }

  void _handleSelectMode(bool isQuizMode) async {
    setState(() => _isModeSheetOpen = false);
    ref.read(examAttemptProvider.notifier).reset();
    await _startAttemptAndRefresh(
      isQuizMode,
      isPartial: _selectedRetakeIsPartial,
    );
  }

  Future<void> _handleStartOffline() async {
    ref.read(examAttemptProvider.notifier).reset();
    // Force regular mode as per spec
    await _startAttemptAndRefresh(false, isPartial: false, isOffline: true);
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final lessonDetailAsync = ref.watch(lessonDetailProvider(widget.testId));
    final fetchedLesson = lessonDetailAsync.valueOrNull;
    final lesson = fetchedLesson?.mergeWith(widget.lesson) ?? widget.lesson;
    final exam = lesson?.exam;

    if (lesson?.hasEnded == true) {
      final formattedEnd = lesson?.end != null
          ? TimeFormatter.formatDate(lesson!.end!)
          : null;
      final detailMessage = (formattedEnd != null && formattedEnd.isNotEmpty)
          ? l10n.accessExpiredOn(formattedEnd)
          : l10n.contentAccessEnded;

      return LessonDetailShell(
        title: lesson?.title ?? exam?.title ?? l10n.examDetailsTitle,
        onBack: widget.onClose,
        child: ContentNoticeView(
          icon: LucideIcons.calendarClock,
          title: l10n.accessExpired,
          message: detailMessage,
        ),
      );
    }

    if (lesson?.isLocked == true) {
      return LessonDetailShell(
        title: lesson?.title ?? exam?.title ?? l10n.examDetailsTitle,
        onBack: widget.onClose,
        child: ContentNoticeView(
          icon: LucideIcons.lock,
          title: l10n.errorAccessDeniedTitle,
          message: l10n.completePreviousContentToUnlock,
        ),
      );
    }

    if (lesson?.isScheduled == true) {
      final scheduledLesson = lesson!;
      final scheduledMsg = scheduledLesson.scheduledMessage;
      final detailMessage = (scheduledMsg != null && scheduledMsg.isNotEmpty)
          ? scheduledMsg
          : l10n.liveStreamScheduledDefault;

      return LessonDetailShell(
        title: scheduledLesson.title.isNotEmpty
            ? scheduledLesson.title
            : exam?.title ?? l10n.examDetailsTitle,
        onBack: widget.onClose,
        child: ContentNoticeView(
          icon: LucideIcons.calendarClock,
          title: l10n.liveStreamScheduledDefault,
          message: detailMessage,
        ),
      );
    }

    if (lessonDetailAsync.hasError) {
      return LessonDetailShell(
        title: lesson?.title ?? exam?.title ?? l10n.examDetailsTitle,
        onBack: widget.onClose,
        child: Center(
          child: AppErrorView(
            error: lessonDetailAsync.error,
            onRetry: () => ref.invalidate(lessonDetailProvider(widget.testId)),
          ),
        ),
      );
    }

    final attemptsUrl = ApiEndpoints.lessonAttempts(widget.testId);
    final attemptsAsync = ref.watch(examAttemptsProvider(attemptsUrl));

    final bool isAttemptsLoading = attemptsAsync.isLoading;
    final bool hasRunningAttempt =
        attemptsAsync.valueOrNull?.any(
          (a) =>
              a.state?.toLowerCase() == 'running' ||
              a.state?.toLowerCase() == 'submitting',
        ) ??
        false;

    final bool hasCompletedAttempts =
        attemptsAsync.valueOrNull?.any(
          (a) => a.state?.toLowerCase() == 'completed',
        ) ??
        false;

    final bool isMetadataLoading =
        !(lesson?.isDetailFetched ?? false) && !lessonDetailAsync.hasError;

    final bool canResumePaused =
        ((exam?.pausedAttemptsCount ?? 0) > 0) &&
        !(exam?.disableAttemptResume ?? false);

    final bool isResuming =
        hasRunningAttempt || (!attemptsAsync.hasValue && canResumePaused);

    final bool isRetaking = hasCompletedAttempts && !isResuming;

    final bool isAssessment = lesson?.type == LessonType.assessment;

    final bool showModeSelection =
        !isMetadataLoading &&
        exam != null &&
        exam.enableQuizMode == true &&
        !isResuming &&
        !widget.isOfflineOnly &&
        !isAssessment;

    final bool isButtonEnabled =
        !isMetadataLoading && (!showModeSelection || !_isModeSheetOpen);

    final bool hideBottomBar = ExamPrescreenBottomBar.shouldHideBottomBar(
      isMetadataLoading: isMetadataLoading,
      isAttemptsLoading: isAttemptsLoading,
      isOfflineOnly: widget.isOfflineOnly,
    );

    return Stack(
      children: [
        LessonDetailShell(
          title: lesson?.title ?? exam?.title ?? l10n.examDetailsTitle,
          onBack: widget.onClose,
          stickyFooter: true,
          backgroundColor: design.colors.card,
          bottomBar: hideBottomBar
              ? null
              : ExamPrescreenBottomBar(
                  testId: widget.testId,
                  exam: exam,
                  lesson: lesson,
                  attemptsUrl: attemptsUrl,
                  isOfflineOnly: widget.isOfflineOnly,
                  isMetadataLoading: isMetadataLoading,
                  isAttemptsLoading: isAttemptsLoading,
                  isButtonEnabled: isButtonEnabled,
                  isResuming: isResuming,
                  isRetaking: isRetaking,
                  onStartOnline: () => _handleOnlineStart(
                    isPartial: false,
                    showModeSelection: showModeSelection,
                  ),
                  onRetakeIncorrect: () => _handleOnlineStart(
                    isPartial: true,
                    showModeSelection: showModeSelection,
                  ),
                  onStartOffline: _handleStartOffline,
                ),
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
                    exam: exam,
                    lesson: lesson,
                    isMetadataLoading: isMetadataLoading,
                  ),
                  SizedBox(height: design.spacing.lg),
                  ExamHistorySection(
                    attemptsAsync: attemptsAsync,
                    exam: exam,
                    lesson: lesson,
                    isMetadataLoading: isMetadataLoading,
                    isOfflineOnly: widget.isOfflineOnly,
                  ),
                  SizedBox(height: design.spacing.lg),
                ],
              ),
            ),
          ),
        ),
        if (showModeSelection)
          ExamModeBottomSheet(
            isOpen: _isModeSheetOpen,
            onClose: () => setState(() => _isModeSheetOpen = false),
            onSelectMode: _handleSelectMode,
          ),
      ],
    );
  }
}
