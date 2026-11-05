import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import '../../widgets/store/product_discount_sheet.dart';
import '../../widgets/store/product_installment_sheet.dart';
import '../../widgets/store/product_subscription_sheet.dart';
import '../../widgets/store/product_plan_section.dart';
import '../../widgets/store/product_plan_comparison_section.dart';
import '../../widgets/store/product_expandable_course_card.dart';
import '../../widgets/store/product_faculty_summary.dart';
import '../../widgets/store/product_faculty_section.dart';
import 'faculty_profile_screen.dart';
import '../../providers/store_providers.dart';
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
  bool _isSubscriptionSheetOpen = false;
  bool _hasChosenPlan = false;
  int _selectedSubTabIndex = 0;
  int? _selectedPlanId;
  int? _selectedDurationInDays;
  int? _selectedPlanDetailId;

  final TextEditingController _couponController = TextEditingController();
  final GlobalKey _facultySectionKey = GlobalKey();

  void _scrollToFacultySection() {
    final targetContext = _facultySectionKey.currentContext;
    if (targetContext != null) {
      final design = Design.of(context);
      final shouldAnimate = MotionPreferences.shouldAnimate(context);
      Scrollable.ensureVisible(
        targetContext,
        duration: shouldAnimate ? design.motion.normal : Duration.zero,
        curve: MotionPreferences.curve(context, design.motion.easeOut),
      );
    }
  }

  void _openFacultyProfile(ProductFacultyDto faculty) {
    Navigator.of(context).push(
      AppRoute(
        page: FacultyProfileScreen(faculty: faculty),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeSelection(widget.product);
  }

  void _initializeSelection(ProductDto product) {
    if (product.plans.isNotEmpty) {
      final firstPlan = product.plans.first;
      _selectedPlanId = firstPlan.id;

      final allDurations = <int>{};
      for (final plan in product.plans) {
        for (final detail in plan.planDetails) {
          allDurations.add(detail.durationInDays);
        }
      }
      final sortedDurations = allDurations.toList()..sort();
      _selectedDurationInDays = sortedDurations.firstOrNull;

      final matchingDetail = firstPlan.planDetails
              .where((d) => d.durationInDays == _selectedDurationInDays)
              .firstOrNull ??
          firstPlan.planDetails.firstOrNull;

      if (matchingDetail != null) {
        _selectedPlanDetailId = matchingDetail.id;
        _hasChosenPlan = true;
      }
    } else {
      final allPlanDetails = [for (final p in product.plans) ...p.planDetails];
      if (allPlanDetails.length == 1) {
        _hasChosenPlan = true;
        _selectedPlanDetailId = allPlanDetails.first.id;
      }
    }
  }

  void _onSelectPlan(int planId, ProductDto product) {
    final plan = product.plans.where((p) => p.id == planId).firstOrNull;
    if (plan == null) return;

    final matchingDetail = plan.planDetails
        .where((d) => d.durationInDays == _selectedDurationInDays)
        .firstOrNull;

    if (matchingDetail == null && _selectedDurationInDays != null) {
      return;
    }

    setState(() {
      _selectedPlanId = planId;
      _hasChosenPlan = true;

      final effectiveDetail = matchingDetail ?? plan.planDetails.firstOrNull;
      if (effectiveDetail != null) {
        _selectedPlanDetailId = effectiveDetail.id;
        _selectedDurationInDays = effectiveDetail.durationInDays;
      }
    });

    if (_selectedPlanDetailId != null) {
      ref
          .read(productDiscountNotifierProvider(product.slug).notifier)
          .setSelectedPlanDetailId(_selectedPlanDetailId!);
    }
  }

  void _onSelectDuration(int duration, ProductDto product) {
    setState(() {
      _selectedDurationInDays = duration;

      final activePlan =
          product.plans.where((p) => p.id == _selectedPlanId).firstOrNull ??
              product.plans.firstOrNull;

      final matchingDetail = activePlan?.planDetails
          .where((d) => d.durationInDays == duration)
          .firstOrNull;

      if (matchingDetail != null) {
        _selectedPlanDetailId = matchingDetail.id;
        _hasChosenPlan = true;
      } else {
        final altPlan = product.plans
            .where(
                (p) => p.planDetails.any((d) => d.durationInDays == duration))
            .firstOrNull;
        if (altPlan != null) {
          _selectedPlanId = altPlan.id;
          final altDetail = altPlan.planDetails
              .firstWhere((d) => d.durationInDays == duration);
          _selectedPlanDetailId = altDetail.id;
          _hasChosenPlan = true;
        }
      }
    });

    if (_selectedPlanDetailId != null) {
      ref
          .read(productDiscountNotifierProvider(product.slug).notifier)
          .setSelectedPlanDetailId(_selectedPlanDetailId!);
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Widget _buildAppliedCouponCard(
    BuildContext context,
    DesignConfig design, {
    required String? appliedCouponCode,
    required double? savedAmount,
    required String productSlug,
  }) {
    final l10n = L10n.of(context);
    final isCoupon = appliedCouponCode != null && appliedCouponCode.isNotEmpty;
    final semanticLabel = savedAmount != null && savedAmount > 0
        ? '${isCoupon ? l10n.storeCouponApplied : l10n.storeSpecialDiscountApplied}. ${l10n.storeYouSaved(savedAmount.toStringAsFixed(2))}'
        : (isCoupon
            ? l10n.storeCouponApplied
            : l10n.storeSpecialDiscountApplied);

    return AppSemantics.container(
      label: semanticLabel,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: design.colors.success.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(design.radius.md),
        ),
        child: Row(
          children: [
            Icon(
              LucideIcons.tag,
              color: design.colors.success,
              size: 24,
            ),
            SizedBox(width: design.spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.labelBold(
                    isCoupon
                        ? appliedCouponCode.toUpperCase()
                        : l10n.storeSpecialDiscount,
                    color: design.colors.success,
                  ),
                  const SizedBox(height: 2),
                  AppText.caption(
                    savedAmount != null && savedAmount > 0
                        ? l10n.storeYouSaved(savedAmount.toStringAsFixed(2))
                        : (isCoupon
                            ? l10n.storeCouponApplied
                            : l10n.storeSpecialDiscountApplied),
                    color: design.colors.success,
                  ),
                ],
              ),
            ),
            if (isCoupon)
              AppSemantics.button(
                label: L10n.of(context).labelRemove,
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(productDiscountNotifierProvider(productSlug)
                            .notifier)
                        .removeCoupon();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.xCircle,
                        size: design.iconSize.md,
                        color: design.colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
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

  Widget _buildBenefitsSection(
    BuildContext context,
    DesignConfig design,
    ProductDto product,
  ) {
    if (product.benefits.isEmpty) return const SizedBox.shrink();
    final l10n = L10n.of(context);

    return AppSemantics.container(
      label: l10n.storeWhatYouGet,
      child: Container(
        padding: EdgeInsets.all(design.spacing.md),
        decoration: BoxDecoration(
          color: design.colors.surfaceVariant.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(design.radius.lg),
          border: Border.all(color: design.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.sparkles,
                  size: design.iconSize.md,
                  color: design.colors.primary,
                ),
                SizedBox(width: design.spacing.sm),
                AppText.cardTitle(
                  l10n.storeWhatYouGet,
                  color: design.colors.textPrimary,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(height: design.spacing.md),
            ...product.benefits.map((benefit) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: design.spacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Icon(
                        LucideIcons.checkCircle2,
                        size: 18,
                        color: design.colors.success,
                      ),
                    ),
                    SizedBox(width: design.spacing.sm),
                    Expanded(
                      child: AppText.body(
                        benefit.name,
                        color: design.colors.textPrimary,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseDetails(
    BuildContext context,
    ProductCourseDto course,
    VoidCallback onBuyTap,
  ) {
    return ProductExpandableCourseCard(
      course: course,
      onBuyTap: onBuyTap,
      onPreviewTap: (lesson) {
        final previewLesson =
            lesson.courseId == null || lesson.courseId!.isEmpty
                ? lesson.copyWith(courseId: course.id.toString())
                : lesson;
        LessonRouter.navigateToLesson(
          context,
          id: previewLesson.id,
          type: previewLesson.type,
          extra: previewLesson,
          isPreview: true,
        );
      },
    );
  }

  void _initiatePurchase({
    required ProductDto product,
    required List<PlanDetailDto> allPlanDetails,
    required OrderDto? discountOrder,
  }) async {
    if (allPlanDetails.isNotEmpty && !_hasChosenPlan) {
      setState(() {
        _isSubscriptionSheetOpen = true;
      });
      return;
    }

    final dataSource = ref.read(dataSourceProvider);

    final existingOrderId = ref
        .read(productDiscountNotifierProvider(product.slug).notifier)
        .orderId;

    if (!mounted) return;
    final result = await PaymentProcessingScreen.start(
      context,
      () => discountOrder != null
          ? (discountOrder.status == 'Completed'
              ? Future.value(discountOrder)
              : ref
                  .read(storeRepositoryProvider)
                  .confirmOrder(discountOrder.id, {}))
          : (existingOrderId != null
              ? ref
                  .read(storeRepositoryProvider)
                  .confirmOrder(existingOrderId, {})
              : ref.read(storeRepositoryProvider).createAndConfirmOrder(
                    product.slug,
                    planDetailId: _selectedPlanDetailId,
                  )),
      dataSource,
    );

    if (!mounted) return;
    if (result?.status == PaymentResultStatus.success) {
      refreshStoreAfterPurchase(ref, productSlug: product.slug);

      final redirect = result?.redirectRoute;
      if (redirect != null && mounted) {
        context.go(redirect);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    ref.listen<AsyncValue<ProductDto>>(
      productDetailProvider(widget.product.slug),
      (prev, next) {
        final loadedProduct = next.valueOrNull;
        if (loadedProduct != null &&
            loadedProduct.plans.isNotEmpty &&
            _selectedPlanId == null) {
          _initializeSelection(loadedProduct);
          if (mounted) setState(() {});
        }
      },
    );
    final detailAsync = ref.watch(productDetailProvider(widget.product.slug));
    final product = detailAsync.valueOrNull ?? widget.product;
    final discountAsync =
        ref.watch(productDiscountNotifierProvider(product.slug));
    final discountOrder = discountAsync.valueOrNull;
    final appliedCouponCode = ref
        .watch(productDiscountNotifierProvider(product.slug).notifier)
        .appliedCouponCode;

    final allPlanDetails = [for (final p in product.plans) ...p.planDetails];
    final selectedPlanDetail = _selectedPlanDetailId != null
        ? allPlanDetails.where((d) => d.id == _selectedPlanDetailId).firstOrNull
        : (_hasChosenPlan ? allPlanDetails.firstOrNull : null);

    final basePriceStr =
        selectedPlanDetail != null ? selectedPlanDetail.price : product.price;
    final strikeThroughStr = selectedPlanDetail != null
        ? selectedPlanDetail.strikeThroughPrice
        : product.strikeThroughPrice;

    final originalPriceVal = double.tryParse(basePriceStr.replaceAll(',', ''));
    final discountedVal = discountOrder != null
        ? double.tryParse(discountOrder.total.replaceAll(',', ''))
        : null;

    final savedFromItems = () {
      if (discountOrder != null && discountOrder.orderItems.isNotEmpty) {
        final item = discountOrder.orderItems.first;
        final before = double.tryParse(
            item.priceBeforeDiscounts?.replaceAll(',', '') ?? '');
        final price = double.tryParse(item.price.replaceAll(',', ''));
        if (before != null && price != null && before > price) {
          return before - price;
        }
      }
      return null;
    }();

    final savedAmount = savedFromItems ??
        ((originalPriceVal != null &&
                discountedVal != null &&
                originalPriceVal > discountedVal)
            ? (originalPriceVal - discountedVal)
            : null);
    final matchingPrices =
        product.prices.where((p) => p.price == basePriceStr).toList();
    final validityDays = selectedPlanDetail != null
        ? selectedPlanDetail.durationInDays
        : (matchingPrices.length == 1 ? matchingPrices.first.validity : null);

    final selectedPlan = selectedPlanDetail != null
        ? product.plans
            .where(
                (p) => p.planDetails.any((d) => d.id == selectedPlanDetail.id))
            .firstOrNull
        : null;

    final planCourseIds = {
      for (final plan in product.plans) ...plan.courseIds,
    };
    final baseCurriculumCourses = product.coursesDetails
        .where((course) => !planCourseIds.contains(course.id))
        .toList();
    final curriculumCourses = baseCurriculumCourses.isNotEmpty
        ? baseCurriculumCourses
        : (selectedPlan != null
            ? product.coursesDetails
                .where((c) => selectedPlan.courseIds.contains(c.id))
                .toList()
            : product.coursesDetails);

    final hasDescription = product.descriptionHtml.isNotEmpty;
    final hasCourse = curriculumCourses.isNotEmpty;
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
                  MediaQuery.paddingOf(context).top + design.spacing.xs,
                  design.spacing.screenPadding,
                  design.spacing.xs,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppSemantics.button(
                      label: L10n.of(context).storeProductBack,
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
                    AppIconButton(
                      icon: LucideIcons.messagesSquare,
                      size: 22,
                      color: design.colors.textPrimary,
                      accessibilityLabel: L10n.of(context).drawerMessages,
                      onTap: () => context.push('/messages'),
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
                            if (product.thumbnailUrl != null &&
                                product.thumbnailUrl!.isNotEmpty)
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: CachedNetworkImage(
                                  imageUrl: product.thumbnailUrl!,
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
                                  if (product.shortDescription.isNotEmpty) ...[
                                    AppText.bodySmall(
                                      product.shortDescription,
                                      color: design.colors.textSecondary,
                                    ),
                                    SizedBox(height: design.spacing.sm),
                                  ],
                                  if (product.plans.isNotEmpty) ...[
                                    if (discountOrder != null) ...[
                                      _buildAppliedCouponCard(
                                        context,
                                        design,
                                        appliedCouponCode: appliedCouponCode,
                                        savedAmount: savedAmount,
                                        productSlug: product.slug,
                                      ),
                                      SizedBox(height: design.spacing.md),
                                    ],
                                    if (product.faculty.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: design.spacing.md),
                                        child: ProductFacultySummary(
                                          faculty: product.faculty,
                                          onTap: _scrollToFacultySection,
                                        ),
                                      ),
                                    ProductPlanSection(
                                      product: product,
                                      selectedPlanId: _selectedPlanId,
                                      selectedDurationInDays:
                                          _selectedDurationInDays,
                                      onSelectPlan: (planId) =>
                                          _onSelectPlan(planId, product),
                                      onSelectDuration: (duration) =>
                                          _onSelectDuration(duration, product),
                                    ),
                                    SizedBox(height: design.spacing.lg),
                                    ProductPlanComparisonSection(
                                      product: product,
                                      selectedPlanId: _selectedPlanId,
                                      onSelectPlan: (planId) =>
                                          _onSelectPlan(planId, product),
                                    ),
                                    SizedBox(height: design.spacing.md),
                                  ] else ...[
                                    if (discountOrder != null) ...[
                                      AppText.body(
                                        '₹$basePriceStr',
                                        style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: design.colors.textSecondary,
                                        ),
                                      ),
                                      SizedBox(height: design.spacing.xs / 2),
                                      AppText.title(
                                        '₹${discountOrder.total}',
                                        color: design.colors.textPrimary,
                                      ),
                                      SizedBox(height: design.spacing.md),
                                      _buildAppliedCouponCard(
                                        context,
                                        design,
                                        appliedCouponCode: appliedCouponCode,
                                        savedAmount: savedAmount,
                                        productSlug: product.slug,
                                      ),
                                    ] else
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          AppText.title(
                                            product.isFree
                                                ? L10n.of(context).free
                                                : '₹$basePriceStr',
                                            color: design.colors.textPrimary,
                                          ),
                                          if (!product.isFree &&
                                              strikeThroughStr != null &&
                                              strikeThroughStr.isNotEmpty) ...[
                                            SizedBox(width: design.spacing.sm),
                                            AppText.body(
                                              '₹$strikeThroughStr',
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color:
                                                    design.colors.textSecondary,
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
                                                  .storeValidityDays(
                                                      validityDays.toString()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (product.faculty.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: design.spacing.sm),
                                        child: ProductFacultySummary(
                                          faculty: product.faculty,
                                          onTap: _scrollToFacultySection,
                                        ),
                                      ),
                                    if (product.benefits.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: design.spacing.md),
                                        child: _buildBenefitsSection(
                                            context, design, product),
                                      ),
                                  ],
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
                                              L10n.of(context).storeDescription,
                                              0),
                                          SizedBox(width: design.spacing.md),
                                          _buildTab(
                                              context,
                                              L10n.of(context).storeCurriculum,
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
                                        L10n.of(context).storeDescription,
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
                                        L10n.of(context).storeCurriculum,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  if ((!showTabs && hasCourse) ||
                                      (showTabs && _selectedSubTabIndex == 1))
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: curriculumCourses
                                          .map((course) => _buildCourseDetails(
                                                context,
                                                course,
                                                () => _initiatePurchase(
                                                  product: product,
                                                  allPlanDetails:
                                                      allPlanDetails,
                                                  discountOrder: discountOrder,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  if (product.faculty.isNotEmpty)
                                    ProductFacultySection(
                                      key: _facultySectionKey,
                                      faculty: product.faculty,
                                      onSelectFaculty: _openFacultyProfile,
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
                          if (!product.isFree && discountOrder == null)
                            AppSemantics.button(
                              label: L10n.of(context).storeHaveDiscountCode,
                              child: GestureDetector(
                                onTap: () {
                                  if (allPlanDetails.isNotEmpty &&
                                      _selectedPlanDetailId == null) {
                                    final firstPlanId = allPlanDetails.first.id;
                                    ref
                                        .read(productDiscountNotifierProvider(
                                                product.slug)
                                            .notifier)
                                        .setSelectedPlanDetailId(firstPlanId);
                                  }
                                  setState(() {
                                    _isDiscountSheetOpen = true;
                                  });
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: design.spacing.xs),
                                  child: AppText.labelBold(
                                    L10n.of(context).storeHaveDiscountCode,
                                    color: design.colors.accent2,
                                  ),
                                ),
                              ),
                            ),
                          const Spacer(),
                          if (allPlanDetails.isEmpty)
                            AppSemantics.button(
                              label: L10n.of(context).storePayInstallments,
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
                                    L10n.of(context).storePayInstallments,
                                    color: design.colors.accent2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: design.spacing.md),
                      AppButton.primary(
                        label: allPlanDetails.isNotEmpty
                            ? (_hasChosenPlan
                                ? L10n.of(context).storeProceedToBuy
                                : L10n.of(context).storeSubscribe)
                            : ((product.buyNowText?.isNotEmpty == true)
                                ? product.buyNowText!
                                : L10n.of(context).storeBuyNow),
                        fullWidth: true,
                        backgroundColor: design.colors.accent2,
                        loading: false,
                        onPressed: () => _initiatePurchase(
                          product: product,
                          allPlanDetails: allPlanDetails,
                          discountOrder: discountOrder,
                        ),
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
          onClose: () {
            ref
                .read(productDiscountNotifierProvider(product.slug).notifier)
                .clearError();
            setState(() => _isDiscountSheetOpen = false);
          },
          child: ProductDiscountSheet(
            productSlug: product.slug,
            product: product,
            originalPrice: basePriceStr,
            onClose: () {
              ref
                  .read(productDiscountNotifierProvider(product.slug).notifier)
                  .clearError();
              setState(() => _isDiscountSheetOpen = false);
            },
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
        AppBottomSheet(
          isOpen: _isSubscriptionSheetOpen,
          onClose: () => setState(() => _isSubscriptionSheetOpen = false),
          child: ProductSubscriptionSheet(
            product: product,
            initialSelectedPlanDetailId: _selectedPlanDetailId,
            onPlanSelected: (detailId) {
              setState(() {
                _selectedPlanDetailId = detailId;
                _hasChosenPlan = true;
              });
              ref
                  .read(productDiscountNotifierProvider(product.slug).notifier)
                  .setSelectedPlanDetailId(detailId);
            },
            onClose: () => setState(() => _isSubscriptionSheetOpen = false),
          ),
        ),
      ],
    );
  }
}
