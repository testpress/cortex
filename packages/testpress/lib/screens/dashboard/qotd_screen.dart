import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'qotd/qotd_overview_screen.dart';
import 'qotd/qotd_quiz_screen.dart';

/// Entry point screen for QOTD. Routes between the overview and quiz views.
class QotdScreen extends ConsumerStatefulWidget {
  const QotdScreen({super.key});

  @override
  ConsumerState<QotdScreen> createState() => _QotdScreenState();
}

class _QotdScreenState extends ConsumerState<QotdScreen> {
  bool _isInQuizMode = false;
  int _initialQuizIndex = 0;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final qotdAsync = ref.watch(qotdProvider);

    return AppShell(
      backgroundColor: _isInQuizMode
          ? design.colors.canvas
          : design.colors.card,
      child: qotdAsync.when(
        data: (questions) {
          if (questions.isEmpty) {
            return Column(
              children: [
                AppSemantics.header(
                  label: l10n.qotdTitle,
                  child: AppHeader(
                    title: l10n.qotdTitle,
                    leading: AppBackButton(onTap: () => context.pop()),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(design.spacing.lg),
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 480),
                        padding: EdgeInsets.symmetric(
                          horizontal: design.spacing.lg,
                          vertical: design.spacing.xl,
                        ),
                        decoration: BoxDecoration(
                          color: design.colors.card,
                          borderRadius: design.radius.card,
                          border: Border.all(color: design.colors.border),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: design.colors.primary.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                LucideIcons.helpCircle,
                                size: 32,
                                color: design.colors.primary,
                              ),
                            ),
                            SizedBox(height: design.spacing.lg),
                            AppText.title(
                              l10n.qotdEmptyStateTitle,
                              color: design.colors.textPrimary,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: design.spacing.xs),
                            AppText.body(
                              l10n.qotdEmptyStateBody,
                              color: design.colors.textSecondary,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: design.spacing.xl),
                            AppSemantics.button(
                              label: l10n.qotdBackToDashboard,
                              onTap: () => context.pop(),
                              child: AppButton.primary(
                                label: l10n.qotdBackToDashboard,
                                onPressed: () => context.pop(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          if (_isInQuizMode) {
            return QotdQuizScreen(
              questions: questions,
              initialIndex: _initialQuizIndex,
              onCloseQuiz: () {
                ref.invalidate(qotdProvider);
                ref.invalidate(qotdSummaryProvider);
                setState(() => _isInQuizMode = false);
              },
            );
          }

          return QotdOverviewScreen(
            questions: questions,
            onStartQuiz: (index) => setState(() {
              _initialQuizIndex = index;
              _isInQuizMode = true;
            }),
          );
        },
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (error, stack) => Column(
          children: [
            AppSemantics.header(
              label: l10n.qotdTitle,
              child: AppHeader(
                title: l10n.qotdTitle,
                leading: AppBackButton(onTap: () => context.pop()),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(design.spacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText.body(
                        l10n.qotdErrorFailedToLoad,
                        color: design.colors.textSecondary,
                      ),
                      SizedBox(height: design.spacing.md),
                      AppSemantics.button(
                        label: l10n.qotdRetry,
                        onTap: () {
                          ref.invalidate(qotdProvider);
                          ref.invalidate(qotdSummaryProvider);
                        },
                        child: AppButton.secondary(
                          label: l10n.qotdRetry,
                          onPressed: () {
                            ref.invalidate(qotdProvider);
                            ref.invalidate(qotdSummaryProvider);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
