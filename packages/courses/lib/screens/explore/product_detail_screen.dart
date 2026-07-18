import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import '../../widgets/explore/product_discount_sheet.dart';
import '../../widgets/explore/product_installment_sheet.dart';
import '../../widgets/explore/product_expandable_course_card.dart';
import '../../providers/explore_providers.dart';
import 'package:core/data/data.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  final ProductDto product;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  bool _isDiscountSheetOpen = false;
  bool _isInstallmentsSheetOpen = false;
  int _selectedSubTabIndex = 0;

  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Widget _buildTab(BuildContext context, String label, int index) {
    final design = Design.of(context);
    final isSelected = _selectedSubTabIndex == index;
    return AppSemantics.button(
      label: label,
      child: GestureDetector(
        onTap: () => setState(() => _selectedSubTabIndex = index),
        behavior: HitTestBehavior.opaque,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: AppText.body(
                  label,
                  color: isSelected
                      ? design.colors.primary
                      : design.colors.textPrimary,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: design.spacing.xs),
              Container(
                height: 2,
                color: isSelected
                    ? design.colors.primary
                    : design.colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseDetails(BuildContext context, ProductCourseDto course) {
    return ProductExpandableCourseCard(course: course);
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final detailAsync = ref.watch(productDetailProvider(widget.product.slug));
    final product = detailAsync.value ?? widget.product;
    final matchingPrices =
        product.prices.where((p) => p.price == product.price).toList();
    final validityDays =
        matchingPrices.length == 1 ? matchingPrices.first.validity : null;

    final hasDescription = product.descriptionHtml.isNotEmpty;
    final hasCourse = product.coursesDetails.isNotEmpty;
    final showTabs = hasDescription && hasCourse;

    return Stack(
      children: [
        Container(
          color: design.colors.card,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: design.colors.card,
                  border: Border(
                    bottom: BorderSide(color: design.colors.divider),
                  ),
                ),
                padding: EdgeInsetsDirectional.fromSTEB(
                  design.spacing.screenPadding,
                  MediaQuery.paddingOf(context).top + design.spacing.md,
                  design.spacing.screenPadding,
                  design.spacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppSemantics.button(
                      label: L10n.of(context).exploreProductBack,
                      onTap: () => Navigator.pop(context),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2, right: 8),
                          child: Icon(
                            LucideIcons.arrowLeft,
                            size: 22,
                            color: design.colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AppText.title(
                        product.title,
                        color: design.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: design.colors.card,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (product.image != null &&
                                product.image!.isNotEmpty)
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: CachedNetworkImage(
                                  imageUrl: product.image!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: design.colors.surfaceVariant,
                                    child: Center(
                                      child: Icon(LucideIcons.image,
                                          color: design.colors.textSecondary),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: design.colors.surfaceVariant,
                                    child: Center(
                                      child: Icon(LucideIcons.image,
                                          color: design.colors.textSecondary),
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.all(design.spacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      AppText.title(
                                        '₹${product.price}',
                                        color: design.colors.textPrimary,
                                      ),
                                      if (product.strikeThroughPrice != null &&
                                          product.strikeThroughPrice!
                                              .isNotEmpty) ...[
                                        SizedBox(width: design.spacing.sm),
                                        AppText.body(
                                          '₹${product.strikeThroughPrice}',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: design.colors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: design.spacing.md),
                                  if (validityDays != null)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: design.spacing.md),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            LucideIcons.calendar,
                                            size: design.iconSize.sm,
                                          ),
                                          SizedBox(width: design.spacing.xs),
                                          AppText.labelBold(
                                            L10n.of(context)
                                                .exploreValidityDays(
                                                    validityDays.toString()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (hasDescription || hasCourse)
                                    Container(
                                        height: 1, color: design.colors.border),
                                  if (showTabs)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: design.spacing.md),
                                      child: Row(
                                        children: [
                                          _buildTab(
                                              context,
                                              L10n.of(context)
                                                  .exploreDescription,
                                              0),
                                          SizedBox(width: design.spacing.md),
                                          _buildTab(
                                              context,
                                              L10n.of(context)
                                                  .exploreCurriculum,
                                              1),
                                        ],
                                      ),
                                    ),
                                  SizedBox(height: design.spacing.md),
                                  if (!showTabs && hasDescription)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: design.spacing.sm),
                                      child: AppText.body(
                                        L10n.of(context).exploreDescription,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  if ((!showTabs && hasDescription) ||
                                      (showTabs && _selectedSubTabIndex == 0))
                                    AppHtmlV2(data: product.descriptionHtml),
                                  if (!showTabs && hasCourse)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: design.spacing.sm),
                                      child: AppText.body(
                                        L10n.of(context).exploreCurriculum,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  if ((!showTabs && hasCourse) ||
                                      (showTabs && _selectedSubTabIndex == 1))
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: product.coursesDetails
                                          .map((course) => _buildCourseDetails(
                                              context, course))
                                          .toList(),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  decoration: BoxDecoration(
                    color: design.colors.card,
                    border: Border(
                      top: BorderSide(color: design.colors.divider),
                    ),
                  ),
                  padding: EdgeInsets.all(design.spacing.md),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          if (product.hasCoupons)
                            AppSemantics.button(
                              label: L10n.of(context).exploreHaveDiscountCode,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isDiscountSheetOpen = true;
                                  });
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: design.spacing.xs),
                                  child: AppText.labelBold(
                                    L10n.of(context).exploreHaveDiscountCode,
                                    color: design.colors.accent2,
                                  ),
                                ),
                              ),
                            ),
                          const Spacer(),
                          AppSemantics.button(
                            label: L10n.of(context).explorePayInstallments,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isInstallmentsSheetOpen = true;
                                });
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: design.spacing.xs),
                                child: AppText.labelBold(
                                  L10n.of(context).explorePayInstallments,
                                  color: design.colors.accent2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: design.spacing.md),
                      AppButton.primary(
                        label: (product.buyNowText?.isNotEmpty == true)
                            ? product.buyNowText!
                            : L10n.of(context).exploreBuyNow,
                        fullWidth: true,
                        backgroundColor: design.colors.accent2,
                        loading: false,
                        onPressed: () async {
                          final dataSource = ref.read(dataSourceProvider);

                          if (!context.mounted) return;
                          final result = await PaymentProcessingScreen.start(
                            context,
                            () => ref
                                .read(exploreRepositoryProvider)
                                .createAndConfirmOrder(product.slug),
                            dataSource,
                          );

                          if (!context.mounted) return;
                          if (result?.status == PaymentResultStatus.success) {
                            ref.invalidate(productDetailProvider(product.slug));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        AppBottomSheet(
          isOpen: _isDiscountSheetOpen,
          onClose: () => setState(() => _isDiscountSheetOpen = false),
          child: ProductDiscountSheet(
            productSlug: product.slug,
            onClose: () => setState(() => _isDiscountSheetOpen = false),
          ),
        ),
        AppBottomSheet(
          isOpen: _isInstallmentsSheetOpen,
          onClose: () => setState(() => _isInstallmentsSheetOpen = false),
          child: ProductInstallmentSheet(
            product: product,
            onClose: () => setState(() => _isInstallmentsSheetOpen = false),
          ),
        ),
      ],
    );
  }
}
