import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../providers/explore_providers.dart';
import 'product_card.dart';

final _skeletonProducts = List.filled(
  6,
  ProductDto(
    id: 0,
    title: 'Loading product name',
    slug: '',
    price: '9999.00',
    strikeThroughPrice: '12000.00',
    courses: const [],
    image: 'https://example.com/placeholder.jpg',
  ),
);

class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final productsAsync = ref.watch(storeProductsProvider);

    return productsAsync.when(
      loading: () => _buildGrid(context, _skeletonProducts, isLoading: true),
      error: (_, __) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.6,
        child: AppErrorView(
          onRetry: () => ref.invalidate(storeProductsProvider),
        ),
      ),
      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(design.spacing.xl),
              child: const AppText.body('No products found.'),
            ),
          );
        }
        return _buildGrid(context, products, isLoading: false);
      },
    );
  }

  Widget _buildGrid(
    BuildContext context,
    List<ProductDto> products, {
    required bool isLoading,
  }) {
    final design = Design.of(context);

    return Skeletonizer(
      enabled: isLoading,
      child: Padding(
        padding: EdgeInsets.all(design.spacing.md),
        child: AppSemantics.scrollableList(
          label: 'Products',
          itemCount: products.length,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - design.spacing.md) / 2;
              return Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  spacing: design.spacing.md,
                  runSpacing: design.spacing.md,
                  children: products
                      .map((p) => SizedBox(
                            width: itemWidth,
                            child: ProductCard(product: p),
                          ))
                      .toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
