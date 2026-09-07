import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/core.dart';

/// Skeleton loader for the QOTD overview/analytics landing screen.
/// Matches the exact pixel dimensions and widget hierarchy of [QotdOverviewScreen].
class QotdOverviewSkeleton extends StatelessWidget {
  const QotdOverviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      children: [
        AppHeader(
          title: l10n.qotdTitle,
          leading: AppBackButton(onTap: () => context.pop()),
        ),
        Expanded(
          child: SkeletonizerConfig(
            data: SkeletonizerConfigData(
              effect: ShimmerEffect(
                baseColor: design.colors.skeleton,
                highlightColor: design.colors.onSkeleton,
              ),
            ),
            child: Skeletonizer(
              child: AppScroll(
                padding: EdgeInsets.symmetric(
                  horizontal: design.spacing.lg,
                  vertical: design.spacing.md,
                ),
                children: [
                  // Date row
                  Padding(
                    padding: EdgeInsets.only(
                      left: design.spacing.xs,
                      bottom: design.spacing.md,
                    ),
                    child: Row(
                      children: [
                        const Bone.icon(size: 18),
                        SizedBox(width: design.spacing.sm),
                        const Bone.text(words: 3, fontSize: 13),
                      ],
                    ),
                  ),

                  // Progress card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(design.spacing.lg),
                    decoration: BoxDecoration(
                      color: design.colors.surfaceVariant.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: design.colors.border.withValues(alpha: 0.6),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Bone.circle(size: 92),
                        SizedBox(width: design.spacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Bone(
                                width: 80,
                                height: 20,
                                borderRadius: design.radius.pill,
                              ),
                              SizedBox(height: design.spacing.xs),
                              const Bone.text(words: 2, fontSize: 18),
                              SizedBox(height: design.spacing.xs),
                              const Bone.multiText(lines: 2, fontSize: 12),
                              SizedBox(height: design.spacing.md),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: const Bone(
                                  height: 5,
                                  width: double.infinity,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: design.spacing.lg),

                  // Donut breakdown
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(design.spacing.lg),
                    decoration: BoxDecoration(
                      color: design.colors.surfaceVariant.withValues(
                        alpha: 0.25,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: design.colors.border.withValues(alpha: 0.6),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: design.spacing.xs,
                          ),
                          child: const Bone.circle(size: 96),
                        ),
                        SizedBox(width: design.spacing.xl),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildLegendBone(design),
                              SizedBox(height: design.spacing.sm),
                              _buildLegendBone(design),
                              SizedBox(height: design.spacing.sm),
                              _buildLegendBone(design),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: design.spacing.lg),

                  // Metadata cards
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _buildMetadataSkeleton(design)),
                        SizedBox(width: design.spacing.md),
                        Expanded(child: _buildMetadataSkeleton(design)),
                      ],
                    ),
                  ),
                  SizedBox(height: design.spacing.xl),

                  // CTA button
                  Bone(
                    height: 48,
                    width: double.infinity,
                    borderRadius: design.radius.button,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildLegendBone(DesignConfig design) {
    return Row(
      children: [
        Bone(width: 10, height: 10, borderRadius: BorderRadius.circular(3)),
        SizedBox(width: design.spacing.sm),
        const Bone.text(words: 1, fontSize: 13),
        const Spacer(),
        const Bone.text(words: 1, fontSize: 14),
      ],
    );
  }

  static Widget _buildMetadataSkeleton(DesignConfig design) {
    return Container(
      padding: EdgeInsets.all(design.spacing.lg),
      decoration: BoxDecoration(
        color: design.colors.surfaceVariant.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: design.colors.border.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(width: 38, height: 38, borderRadius: BorderRadius.circular(10)),
          SizedBox(height: design.spacing.md),
          const Bone.text(words: 1, fontSize: 11),
          SizedBox(height: design.spacing.xs),
          const Bone.text(words: 2, fontSize: 16),
        ],
      ),
    );
  }
}
