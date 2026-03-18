import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class AIDoubtHero extends StatelessWidget {
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
          _HeroGreeting(userName: userName),
          const SizedBox(height: 80, child: _SubtitleTicker()),
          SizedBox(height: design.spacing.md),
          _HeroSearchBar(onTap: onAskDoubtTap),
          SizedBox(height: design.spacing.md),
          const _SuggestionPills(),
          SizedBox(height: design.spacing.lg),
          _Separator(design: design),
          SizedBox(height: design.spacing.md),
          _ModuleSolutionsButton(onTap: onSearchSolutionTap),
        ],
      ),
    );
  }
}

class _HeroGreeting extends StatelessWidget {
  final String userName;

  const _HeroGreeting({required this.userName});

  String _getCreativeGreeting() {
    final hour = DateTime.now().hour;
    final timeGreeting = hour < 12
        ? "Good morning"
        : hour < 17
        ? "Good afternoon"
        : "Good evening";

    final greetings = [
      "$timeGreeting, $userName.\nHow can I help you today?",
      "What would you like to \nlearn today, $userName?",
      "Where should we focus \nour study, $userName?",
      "Hey $userName, I'm ready \nfor your questions.",
    ];

    return greetings[DateTime.now().minute % greetings.length];
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.xl),
      child: AppText.headline(_getCreativeGreeting()),
    );
  }
}

class _SubtitleTicker extends StatefulWidget {
  const _SubtitleTicker();

  @override
  State<_SubtitleTicker> createState() => _SubtitleTickerState();
}

class _SubtitleTickerState extends State<_SubtitleTicker> {
  late PageController _pageController;
  Timer? _timer;

  final List<String> _subtitles = [
    "Simplify your concepts",
    "Understand with real life examples",
    "Clear your doubts instantly",
    "Prepare like a pro",
    "AI-driven study insights",
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

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return PageView.builder(
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
    );
  }
}

class _HeroSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const _HeroSearchBar({this.onTap});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.lg),
      child: GestureDetector(
        onTap: onTap,
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
              Icon(LucideIcons.mic, size: 22, color: design.colors.accent2),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionPills extends StatelessWidget {
  const _SuggestionPills();

  static const List<String> _suggestions = [
    "Explain Quantum Physics like I'm 5",
    "How to solve quadratic equations?",
    "Tips for JEE Chemistry",
    "Summarize my last lesson",
  ];

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: design.spacing.lg),
      child: Row(children: _suggestions.map((s) => _Pill(text: s)).toList()),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;

  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
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

class _Separator extends StatelessWidget {
  final DesignConfig design;

  const _Separator({required this.design});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: design.spacing.lg),
        AppText.xs("OR", color: design.colors.textTertiary),
      ],
    );
  }
}

class _ModuleSolutionsButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _ModuleSolutionsButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return GestureDetector(
      onTap: onTap,
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
            Icon(LucideIcons.search, size: 18, color: design.colors.accent2),
            SizedBox(width: design.spacing.sm),
            AppText.labelBold(
              "Search Module Solutions",
              color: design.colors.accent2,
            ),
          ],
        ),
      ),
    );
  }
}
