import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'dart:async';

class HeroBanner {
  final String id;
  final String imageUrl;
  final String title;
  final String link;

  const HeroBanner({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.link,
  });
}

/// Auto-scrolling image banner carousel for the home dashboard.
class HeroBannerCarousel extends StatefulWidget {
  const HeroBannerCarousel({
    super.key,
    required this.banners,
    this.autoPlayInterval = const Duration(seconds: 4),
  });

  final List<HeroBanner> banners;
  final Duration autoPlayInterval;

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  late final PageController _controller;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    if (widget.banners.length > 1) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (!mounted) return;
      if (_currentIndex < widget.banners.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: AspectRatio(
        aspectRatio: 16 / 7,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(design.radius.xl)),
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: widget.banners.length,
                itemBuilder: (context, index) {
                  final banner = widget.banners[index];
                  return Container(
                    color: design.colors.surfaceVariant,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        banner.imageUrl.isNotEmpty
                            ? Image.network(
                                banner.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: Color.lerp(
                                        design.colors.primaryContainer,
                                        design.colors.surfaceVariant,
                                        0.5,
                                      ),
                                    ),
                              )
                            : Container(
                                color: Color.lerp(
                                  design.colors.primaryContainer,
                                  design.colors.surfaceVariant,
                                  0.5,
                                ),
                              ),
                        // Soft gradient overlay for contrast
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x00000000), Color(0x66000000)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (widget.banners.length > 1)
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.banners.length, (index) {
                      final isActive = _currentIndex == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 6,
                        width: isActive ? 24 : 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFFFFFFF)
                              : const Color(0x99FFFFFF),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
