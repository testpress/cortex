import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../announcements/announcements_list_screen.dart';

/// A dashboard section that displays announcement/post categories as "Quick Links",
/// styled with each category's backend-provided color code.
class QuickLinksSectionWidget extends ConsumerWidget {
  const QuickLinksSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(postCategoriesProvider);
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.only(
            left: design.spacing.md,
            right: design.spacing.md,
            top: design.spacing.md,
            bottom: design.spacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.title(l10n.announcementsQuickLinks),
              SizedBox(height: design.spacing.sm),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: categories.map((category) {
                    final color = ColorUtils.parseHexColor(
                      category.color,
                      defaultColor: design.colors.primary,
                    );

                    return Padding(
                      padding: EdgeInsets.only(right: design.spacing.sm),
                      child: AppSemantics.button(
                        label: category.name,
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            AppRoute(
                              page: AnnouncementsListScreen(
                                initialCategory: category,
                              ),
                            ),
                          );
                        },
                        child: AppFocusable(
                          borderRadius: design.radius.pill,
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              AppRoute(
                                page: AnnouncementsListScreen(
                                  initialCategory: category,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: design.spacing.md,
                              vertical: design.spacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: design.colors.card,
                              borderRadius: design.radius.pill,
                              border: Border.all(
                                color: design.colors.border,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: design.spacing.xs),
                                AppText.labelBold(
                                  category.name,
                                  color: design.colors.textPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Padding(
        padding: EdgeInsets.all(design.spacing.md),
        child: Skeletonizer(
          enabled: true,
          child: Row(
            children: List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.only(right: design.spacing.sm),
                child: Container(
                  width: 100,
                  height: 36,
                  decoration: BoxDecoration(
                    color: design.colors.surfaceVariant,
                    borderRadius: design.radius.pill,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
