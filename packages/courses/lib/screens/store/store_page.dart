import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';

import '../../providers/store_providers.dart';
import '../../widgets/store/category_filter_bar.dart';
import '../../widgets/store/product_list.dart';

class StorePage extends ConsumerStatefulWidget {
  const StorePage({super.key});

  @override
  ConsumerState<StorePage> createState() => _StorePageState();
}

class _StorePageState extends ConsumerState<StorePage> {
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

    return Column(
      children: [
        // Header Section
        Container(
          color: design.colors.card,
          padding: EdgeInsets.only(bottom: design.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: l10n.storeTabTitle,
                backgroundColor: design.colors
                    .transparent, // transparent so outer container color shows
                secondaryContent: AppSearchBar(
                  controller: _searchController,
                  hintText: l10n.storeSearchHint,
                  backgroundColor: design.colors.surface,
                  onChanged: (value) {
                    ref.read(storeSearchQueryProvider.notifier).update(value);
                  },
                ),
              ),
              const CategoryFilterBar(),
            ],
          ),
        ),

        Expanded(
          child: Container(
            color: design.colors.canvas,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200) {
                  ref.read(storeProductsProvider.notifier).fetchNextPage();
                }
                return false;
              },
              child: const SingleChildScrollView(
                child: ProductList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
