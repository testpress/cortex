import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../../providers/explore_providers.dart';

class CategoryFilterBar extends ConsumerWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final categoriesAsync = ref.watch(storeCategoriesProvider);
    final selectedCategory = ref.watch(selectedStoreCategoryProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 48,
          child: AppSemantics.scrollableList(
            label: 'Categories',
            itemCount: categories.length + 1,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + 1,
              separatorBuilder: (context, index) =>
                  SizedBox(width: design.spacing.sm),
              itemBuilder: (context, index) {
                if (index == 0) {
                  // "All" filter
                  final isSelected = selectedCategory == null;
                  return Center(
                    child: AppChip(
                      label: L10n.of(context).filterAll,
                      isSelected: isSelected,
                      onTap: () {
                        ref
                            .read(selectedStoreCategoryProvider.notifier)
                            .select(null);
                      },
                    ),
                  );
                }
                final category = categories[index - 1];
                final isSelected = selectedCategory == category.id.toString();

                return Center(
                  child: AppChip(
                    label: category.name,
                    isSelected: isSelected,
                    onTap: () {
                      ref
                          .read(selectedStoreCategoryProvider.notifier)
                          .select(category.id.toString());
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
