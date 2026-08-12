import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../models/course_content.dart';
import '../../providers/learnlens_provider.dart';
import 'mcq/video_mcq_initial_card.dart';
import 'mcq/video_mcq_stepper_card.dart';
import 'mcq/video_mcq_summary_card.dart';

class VideoMcqTab extends ConsumerStatefulWidget {
  final Lesson lesson;
  final ValueChanged<Duration>? onSeek;
  final VoidCallback? onOpenFilterSheet;
  final String difficulty;
  final int questionCount;

  const VideoMcqTab({
    super.key,
    required this.lesson,
    this.onSeek,
    this.onOpenFilterSheet,
    this.difficulty = 'medium',
    this.questionCount = 10,
  });

  @override
  ConsumerState<VideoMcqTab> createState() => _VideoMcqTabState();
}

class _VideoMcqTabState extends ConsumerState<VideoMcqTab>
    with AutomaticKeepAliveClientMixin {
  bool _hasGenerated = false;
  bool _isLoading = false;
  String? _errorMessage;
  List<LearnLensQuizQuestionDto> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isQuizCompleted = false;
  final Map<int, String> _selectedAnswers = {};
  final Set<int> _showHints = {};

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadQuiz() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _hasGenerated = true;
      _currentQuestionIndex = 0;
      _isQuizCompleted = false;
      _selectedAnswers.clear();
      _showHints.clear();
    });

    final contentId = int.tryParse(widget.lesson.id) ?? 0;
    final sessionMap =
        await ref.read(learnlensSessionProvider(contentId).future);

    final sessionToken = sessionMap?['session_token'] as String? ?? '';
    final settings = ref.read(instituteSettingsProvider);
    final orgUuid = (settings?.learnlensEnabled == true)
        ? (settings?.learnlensOrgID ?? '')
        : '';
    final assetId = widget.lesson.learnlensAssetId ??
        widget.lesson.uuid ??
        widget.lesson.id;

    if (sessionToken.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = L10n.of(context).videoMcqSessionError;
      });
      return;
    }

    try {
      final repository = ref.read(learnLensRepositoryProvider);
      final quizResponse = await repository.fetchQuiz(
        orgUuid: orgUuid,
        assetId: assetId,
        sessionToken: sessionToken,
        difficulty: widget.difficulty,
        questionCount: widget.questionCount,
      );

      setState(() {
        _questions = quizResponse.questions;
        _isLoading = false;
      });
    } catch (e, stack) {
      debugPrint('Error loading quiz: $e\n$stack');
      ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
      setState(() {
        _isLoading = false;
        _errorMessage = L10n.of(context).videoMcqFailedToLoad;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final design = Design.of(context);
    final l10n = L10n.of(context);

    if (!_hasGenerated && !_isLoading) {
      return VideoMcqInitialCard(
        difficulty: widget.difficulty,
        questionCount: widget.questionCount,
        onGenerate: _loadQuiz,
        onOpenFilterSheet: widget.onOpenFilterSheet,
      );
    }

    if (_isLoading) {
      return Padding(
        padding: EdgeInsets.all(design.spacing.xl),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: design.spacing.lg),
              AppText.body(
                l10n.videoMcqGenerating,
                color: design.colors.textSecondary,
              ),
              SizedBox(height: design.spacing.xl),
              AppLoadingIndicator(color: design.colors.accent2),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: EdgeInsets.all(design.spacing.xl),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.alertCircle,
                  color: design.colors.error, size: 36),
              SizedBox(height: design.spacing.md),
              AppText.body(
                _errorMessage!,
                color: design.colors.textPrimary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: design.spacing.md),
              AppButton.primary(
                label: l10n.videoMcqRetry,
                onPressed: _loadQuiz,
              ),
            ],
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(design.spacing.xl),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.helpCircle,
                  color: design.colors.textTertiary, size: 48),
              SizedBox(height: design.spacing.md),
              AppText.subtitle(
                l10n.videoMcqNoQuestionsGenerated,
                color: design.colors.textPrimary,
              ),
              SizedBox(height: design.spacing.xs),
              AppText.caption(
                l10n.videoMcqNoQuestionsDesc,
                color: design.colors.textSecondary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: design.spacing.md),
              AppButton.primary(
                label: l10n.videoMcqRetry,
                onPressed: _loadQuiz,
              ),
            ],
          ),
        ),
      );
    }

    if (_isQuizCompleted) {
      return VideoMcqSummaryCard(
        questions: _questions,
        selectedAnswers: _selectedAnswers,
        onRetake: () {
          setState(() {
            _currentQuestionIndex = 0;
            _isQuizCompleted = false;
            _selectedAnswers.clear();
            _showHints.clear();
          });
        },
        onBack: () {
          setState(() {
            _hasGenerated = false;
            _isLoading = false;
            _isQuizCompleted = false;
            _questions.clear();
            _selectedAnswers.clear();
            _showHints.clear();
          });
        },
      );
    }

    return VideoMcqStepperCard(
      question: _questions[_currentQuestionIndex],
      currentIndex: _currentQuestionIndex,
      totalQuestions: _questions.length,
      difficulty: widget.difficulty,
      selectedOption: _selectedAnswers[_currentQuestionIndex],
      showHint: _showHints.contains(_currentQuestionIndex),
      onToggleHint: () {
        setState(() {
          if (_showHints.contains(_currentQuestionIndex)) {
            _showHints.remove(_currentQuestionIndex);
          } else {
            _showHints.add(_currentQuestionIndex);
          }
        });
      },
      onSelectOption: (option) {
        setState(() {
          _selectedAnswers[_currentQuestionIndex] = option;
        });
      },
      onPrevious: () {
        setState(() {
          if (_currentQuestionIndex > 0) {
            _currentQuestionIndex--;
          }
        });
      },
      onNext: () {
        setState(() {
          if (_currentQuestionIndex < _questions.length - 1) {
            _currentQuestionIndex++;
          } else {
            _isQuizCompleted = true;
          }
        });
      },
      onSeek: widget.onSeek,
    );
  }
}
