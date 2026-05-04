import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../design/design_provider.dart';

/// A generic horizontal carousel with dot indicators.
/// Supports "peek" behavior where the next item is partially visible.
class AppCarousel extends StatefulWidget {
  const AppCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.viewportFraction = 0.85,
    this.showDots = true,
    this.onPageChanged,
    this.height = 120.0,
    this.itemPadding,
    this.padEnds = true,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double viewportFraction;
  final bool showDots;
  final ValueChanged<int>? onPageChanged;
  final double height;
  final EdgeInsets? itemPadding;
  final bool padEnds;

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  late final PageController _pageController = PageController(
    viewportFraction: widget.viewportFraction,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.itemCount,
            padEnds: widget.padEnds,
            onPageChanged: widget.onPageChanged,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    widget.itemPadding ??
                    EdgeInsets.symmetric(horizontal: design.spacing.xs),
                child: widget.itemBuilder(context, index),
              );
            },
          ),
        ),
        if (widget.showDots && widget.itemCount > 1) ...[
          SizedBox(height: design.spacing.sm),
          SmoothPageIndicator(
            controller: _pageController,
            count: widget.itemCount,
            effect: ScrollingDotsEffect(
              activeDotColor: design.colors.textPrimary,
              dotColor: design.colors.textPrimary.withValues(alpha: 0.2),
              dotHeight: 7,
              dotWidth: 7,
              activeDotScale: 1.0,
              maxVisibleDots: 5,
            ),
          ),
        ],
      ],
    );
  }
}
