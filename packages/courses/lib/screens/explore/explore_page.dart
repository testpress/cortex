import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';

import '../../providers/explore_providers.dart';
import '../../widgets/explore/category_filter_bar.dart';
import '../../widgets/explore/product_list.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final padding = MediaQuery.paddingOf(context);

    return Column(
      children: [
        // Header Section
        Container(
          color: design.colors.card,
          padding: EdgeInsets.only(bottom: design.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Search Section
              Padding(
                padding: EdgeInsets.fromLTRB(
                  padding.left > design.spacing.md
                      ? padding.left
                      : design.spacing.md,
                  padding.top + design.spacing.md,
                  padding.right > design.spacing.md
                      ? padding.right
                      : design.spacing.md,
                  design.spacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.lg(
                      l10n.exploreTabTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: design.spacing.md),
                    AppSearchBar(
                      controller: _searchController,
                      hintText: l10n.exploreSearchHint,
                      backgroundColor: design.colors.surface,
                      onChanged: (value) {
                        ref
                            .read(exploreSearchQueryProvider.notifier)
                            .update(value);
                      },
                    ),
                  ],
                ),
              ),

              // Category Filter Bar
              const CategoryFilterBar(),
            ],
          ),
        ),

        // Product List Section
        Expanded(
          child: Container(
            color: design.colors.canvas,
            child: const SingleChildScrollView(
              child: ProductList(),
            ),
          ),
        ),
      ],
    );
  }
}
