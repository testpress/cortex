import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class AskDoubtEmptyState extends StatelessWidget {
  const AskDoubtEmptyState({
    super.key,
    required this.onExplainConcept,
    required this.onSolveProblem,
    required this.onPracticeQuestions,
    required this.onStudyTips,
  });

  final VoidCallback onExplainConcept;
  final VoidCallback onSolveProblem;
  final VoidCallback onPracticeQuestions;
  final VoidCallback onStudyTips;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: design.spacing.xl * 2),
              AppText.xl2(
                l10n.aiDoubtEmptyTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: design.spacing.xl),
              Column(
                children: [
                  _SuggestionRow(
                    leading: _SuggestionCard(
                      icon: LucideIcons.bookOpen,
                      label: l10n.aiDoubtSuggestionExplainLabel,
                      iconColor: design.colors.accent4,
                      onTap: onExplainConcept,
                    ),
                    trailing: _SuggestionCard(
                      icon: LucideIcons.calculator,
                      label: l10n.aiDoubtSuggestionSolveLabel,
                      iconColor: design.colors.accent2,
                      onTap: onSolveProblem,
                    ),
                  ),
                  SizedBox(height: design.spacing.sm),
                  _SuggestionRow(
                    leading: _SuggestionCard(
                      icon: LucideIcons.fileQuestion,
                      label: l10n.aiDoubtSuggestionPracticeLabel,
                      iconColor: design.colors.accent1,
                      onTap: onPracticeQuestions,
                    ),
                    trailing: _SuggestionCard(
                      icon: LucideIcons.lightbulb,
                      label: l10n.aiDoubtSuggestionTipsLabel,
                      iconColor: design.colors.accent3,
                      onTap: onStudyTips,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final minimumHeight =
        design.spacing.xxxl + design.spacing.xl + design.spacing.sm;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minimumHeight),
      child: AppCard(
        onTap: onTap,
        showShadow: true,
        padding: EdgeInsets.all(design.spacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: design.iconSize.action),
            SizedBox(height: design.spacing.sm),
            AppText.bodySmall(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.leading, required this.trailing});

  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: leading),
          SizedBox(width: design.spacing.sm),
          Expanded(child: trailing),
        ],
      ),
    );
  }
}
