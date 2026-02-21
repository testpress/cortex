import 'package:flutter/widgets.dart';
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
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double viewportFraction;
  final bool showDots;
  final ValueChanged<int>? onPageChanged;

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
  }

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
          height: 120, // Default height, adjustment might be needed
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.itemCount,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              widget.onPageChanged?.call(index);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
                child: widget.itemBuilder(context, index),
              );
            },
          ),
        ),
        if (widget.showDots && widget.itemCount > 1) ...[
          SizedBox(height: design.spacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.itemCount,
              (index) => _DotIndicator(isActive: index == _currentPage),
            ),
          ),
        ],
      ],
    );
  }
}

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: design.spacing.xs / 2),
      width: isActive ? 24 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? design.colors.textSecondary : design.colors.border,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
