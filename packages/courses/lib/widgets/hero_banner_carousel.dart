import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:core/core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HeroBanner &&
        other.id == id &&
        other.imageUrl == imageUrl &&
        other.title == title &&
        other.link == link;
  }

  @override
  int get hashCode => Object.hash(id, imageUrl, title, link);
}

/// Auto-scrolling image banner carousel for the home dashboard.
class HeroBannerCarousel extends StatefulWidget {
  const HeroBannerCarousel({
    super.key,
    required this.banners,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.isLoading = false,
  });

  final List<HeroBanner> banners;
  final Duration autoPlayInterval;
  final bool isLoading;

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
      if (!MotionPreferences.shouldAnimate(context)) return;

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
  void didUpdateWidget(HeroBannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.banners, oldWidget.banners)) {
      _timer?.cancel();
      if (_currentIndex >= widget.banners.length) {
        _currentIndex = 0;
      }
      if (widget.banners.length > 1) {
        _startTimer();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isSkeleton = widget.isLoading;

    if (widget.banners.isEmpty && !isSkeleton) {
      return const SizedBox.shrink();
    }

    return Skeletonizer(
      enabled: isSkeleton,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
        child: AspectRatio(
          aspectRatio: 2.5,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(design.radius.xl)),
            child: isSkeleton
                ? const Bone(
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Stack(
                    children: [
                      Listener(
                        onPointerDown: (_) => _timer?.cancel(),
                        onPointerUp: (_) {
                          if (widget.banners.length > 1) {
                            _timer?.cancel();
                            _startTimer();
                          }
                        },
                        onPointerCancel: (_) {
                          if (widget.banners.length > 1) {
                            _timer?.cancel();
                            _startTimer();
                          }
                        },
                        child: PageView.builder(
                          controller: _controller,
                          physics: const BouncingScrollPhysics(),
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
                                    ? CachedNetworkImage(
                                        imageUrl: banner.imageUrl,
                                        fit: BoxFit.cover,
                                        fadeInDuration: Duration.zero,
                                        filterQuality: FilterQuality.high,
                                        memCacheWidth: 800,
                                        alignment: Alignment.topCenter,
                                        placeholder: (context, url) => Container(
                                          color: Color.lerp(
                                            design.colors.primaryContainer,
                                            design.colors.surfaceVariant,
                                            0.5,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
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
                                      ? design.colors.onPrimary
                                      : design.colors.onPrimary.withValues(alpha: 0.6),
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
      ),
    );
  }
}
