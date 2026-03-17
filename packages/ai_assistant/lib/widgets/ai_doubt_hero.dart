import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class AIDoubtHero extends StatefulWidget {
  final String userName;
  final VoidCallback? onAskDoubtTap;
  final VoidCallback? onSearchSolutionTap;

  const AIDoubtHero({
    super.key,
    required this.userName,
    this.onAskDoubtTap,
    this.onSearchSolutionTap,
  });

  @override
  State<AIDoubtHero> createState() => _AIDoubtHeroState();
}

class _AIDoubtHeroState extends State<AIDoubtHero> {
  late PageController _pageController;
  Timer? _timer;

  final List<String> _subtitles = [
    "Simplify your concepts",
    "Understand with real life examples",
    "Clear your doubts instantly",
    "Prepare like a pro",
    "AI-driven study insights",
  ];

  final List<String> _suggestions = [
    "Explain Quantum Physics like I'm 5",
    "How to solve quadratic equations?",
    "Tips for JEE Chemistry",
    "Summarize my last lesson",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.3, initialPage: 100);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _getCreativeGreeting() {
    final hour = DateTime.now().hour;
    String timeGreeting;
    if (hour < 12) {
      timeGreeting = "Good morning";
    } else if (hour < 17) {
      timeGreeting = "Good afternoon";
    } else {
      timeGreeting = "Good evening";
    }

    final Greetings = [
      "$timeGreeting, ${widget.userName}.\nHow can I help you today?",
      "What would you like to \nlearn today, ${widget.userName}?",
      "Where should we focus \nour study, ${widget.userName}?",
      "Hey ${widget.userName}, I'm ready \nfor your questions.",
    ];

    return Greetings[DateTime.now().minute % Greetings.length];
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            design.colors.accent2.withValues(alpha: 0.1),
            design.colors.surface,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: design.spacing.xl),
      child: Column(
        children: [
          SizedBox(height: design.spacing.xl),
          // Professional Greeting
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.xl),
            child: AppText.headline(_getCreativeGreeting()),
          ),
          SizedBox(height: design.spacing.lg),

          // Moving Focus Subtitles
          SizedBox(
            height: 80,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final realIndex = index % _subtitles.length;
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.hasClients &&
                        _pageController.position.haveDimensions) {
                      value = (_pageController.page! - index).abs();
                      value = (1 - (value * 0.5)).clamp(0.0, 1.0);
                    }
                    return Center(
                      child: Opacity(
                        opacity: value,
                        child: Transform.scale(
                          scale: 0.8 + (value * 0.2),
                          child: AppText.sm(
                            _subtitles[realIndex],
                            textAlign: TextAlign.center,
                            color: design.colors.textSecondary,
                            style: TextStyle(
                              fontWeight: value > 0.8
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          SizedBox(height: design.spacing.md),

          // Search Bar style Action
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.lg),
            child: GestureDetector(
              onTap: widget.onAskDoubtTap,
              child: Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                decoration: BoxDecoration(
                  color: design.colors.card,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: design.shadows.surfaceSoft,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: design.colors.accent2.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.camera,
                        size: 20,
                        color: design.colors.accent2,
                      ),
                    ),
                    SizedBox(width: design.spacing.md),
                    Expanded(
                      child: AppText.body(
                        "Type your doubt here...",
                        color: design.colors.textTertiary,
                      ),
                    ),
                    Icon(
                      LucideIcons.mic,
                      size: 22,
                      color: design.colors.accent2,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: design.spacing.md),

          // Suggestion Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: design.spacing.lg),
            child: Row(
              children: _suggestions.map((s) => _buildPill(design, s)).toList(),
            ),
          ),

          SizedBox(height: design.spacing.lg),
          AppText.xs("OR", color: design.colors.textTertiary),
          SizedBox(height: design.spacing.md),

          // Solution search button
          GestureDetector(
            onTap: widget.onSearchSolutionTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.lg,
                vertical: design.spacing.md,
              ),
              decoration: BoxDecoration(
                color: design.colors.accent2.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(design.radius.full),
                border: Border.all(
                  color: design.colors.accent2.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.search,
                    size: 18,
                    color: design.colors.accent2,
                  ),
                  SizedBox(width: design.spacing.sm),
                  AppText.labelBold(
                    "Search Module Solutions",
                    color: design.colors.accent2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(DesignConfig design, String text) {
    return Container(
      margin: EdgeInsets.only(right: design.spacing.sm),
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText.caption(text),
    );
  }
}
