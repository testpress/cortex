import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

class ExploreDetailsCard extends StatelessWidget {
  const ExploreDetailsCard({super.key, required this.onExamReviewTap});

  final VoidCallback onExamReviewTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: design.colors.border.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSemantics.header(
            label: 'Explore More Details',
            child: AppText.body(
              'Explore More Details',
              color: design.colors.textPrimary,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: design.spacing.md),
          Column(
            children: [
              _ExploreTile(
                title: 'Overall Performance',
                description:
                    'View detailed summary of your overall performance metrics',
                onTap: () => debugPrint('Overall Performance: coming soon'),
              ),
              SizedBox(height: design.spacing.sm),
              _ExploreTile(
                title: 'Subject-wise Performance',
                description:
                    'Analyze your performance across different subjects',
                onTap: () =>
                    debugPrint('Subject-wise Performance: coming soon'),
              ),
              SizedBox(height: design.spacing.sm),
              _ExploreTile(
                title: 'Exam Review',
                description:
                    'Review each question with answers and explanations',
                onTap: onExamReviewTap,
              ),
              SizedBox(height: design.spacing.sm),
              _ExploreTile(
                title: 'Insights & Recommendations',
                description:
                    'Get personalized insights and improvement suggestions',
                onTap: () => debugPrint('Insights: coming soon'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExploreTile extends StatelessWidget {
  const _ExploreTile({
    required this.title,
    required this.description,
    required this.onTap,
  });

  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return AppSemantics.button(
      label: title,
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(design.radius.md),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(design.spacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(design.radius.md),
            border: Border.all(color: design.colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.body(
                title,
                color: design.colors.textPrimary,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: design.spacing.xs),
              AppText.caption(description, color: design.colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
