import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../providers/forum_providers.dart';

/// A design-system aligned bottom sheet for selecting forum categories.
class ForumCategorySheet extends ConsumerWidget {
  final String courseId;
  final String? selectedCategoryId;
  final bool isOpen;
  final VoidCallback onClose;
  final ValueChanged<String> onCategorySelected;

  const ForumCategorySheet({
    super.key,
    required this.courseId,
    required this.selectedCategoryId,
    required this.isOpen,
    required this.onClose,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final categoriesAsync = ref.watch(forumCategoriesProvider(courseId));
    final categories = categoriesAsync.valueOrNull ?? const <ForumCategoryDto>[];

    // Default to the first category if none selected
    final effectiveSelectedId = selectedCategoryId ?? 
        (categories.isNotEmpty ? categories.first.id : null);

    return AppBottomSheet(
      isOpen: isOpen,
      onClose: onClose,
      child: Container(
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(design.radius.xl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(design.spacing.md),
              child: AppText.title(l10n.forumPostSelectCategoryTitle),
            ),
            Container(height: 1, color: design.colors.divider),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...categoriesAsync.when(
                      data: (_) => categories.map(
                        (category) => AppFocusable(
                          onTap: () {
                            onCategorySelected(category.id);
                            onClose();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: design.spacing.xl,
                              vertical: design.spacing.md,
                            ),
                            child: AppText.body(
                              category.name,
                              color: category.id == effectiveSelectedId
                                  ? design.colors.accent2
                                  : design.colors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      loading: () => [
                        Padding(
                          padding: EdgeInsets.all(design.spacing.lg),
                          child: AppText.body(l10n.labelLoading),
                        ),
                      ],
                      error: (error, stackTrace) => [
                        Padding(
                          padding: EdgeInsets.all(design.spacing.lg),
                          child: AppText.body(l10n.errorGenericMessage),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: design.spacing.sm),
          ],
        ),
      ),
    );
  }
}
