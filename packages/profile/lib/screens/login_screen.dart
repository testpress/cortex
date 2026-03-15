import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  Timer? _carouselTimer;

  @override
  void initState() {
    super.initState();
    _startCarousel();
  }

  void _startCarousel() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    
    // Scale down the carousel area slightly if keyboard is open to preserve space
    final flexTop = bottomInset > 0 ? 25 : 55;
    final flexBottom = bottomInset > 0 ? 75 : 45;

    return Scaffold(
      backgroundColor: design.colors.primary.withValues(alpha: 0.05),
      body: Column(
        children: [
          Expanded(
            flex: flexTop,
            child: _buildBrandingSection(),
          ),
          Expanded(
            flex: flexBottom,
            child: Container(
              decoration: BoxDecoration(
                color: design.colors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                child: _buildOptions(key: const ValueKey('options')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandingSection() {
    final design = Design.of(context);
    
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: [
              _buildCarouselItem(LucideIcons.globe, 'Learn Anywhere', 'Access courses and materials on the go.'),
              _buildCarouselItem(LucideIcons.barChart, 'Track Progress', 'Stay on top of your learning goals.'),
              _buildCarouselItem(LucideIcons.award, 'Achieve Success', 'Get certified and advance your career.'),
            ],
          ),
          Positioned(
            top: design.spacing.lg,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.graduationCap, color: design.colors.primary, size: 28),
                SizedBox(width: design.spacing.xs),
                AppText.headline(
                  'CORTEX',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: design.spacing.lg,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: design.spacing.xs),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? design.colors.primary : design.colors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(IconData icon, String title, String subtitle) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(design.spacing.xl),
            decoration: BoxDecoration(
              color: design.colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 64, color: design.colors.primary),
          ),
          SizedBox(height: design.spacing.xl),
          AppText.headline(title, textAlign: TextAlign.center),
          SizedBox(height: design.spacing.sm),
          AppText.body(
            subtitle,
            color: design.colors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOptions({required Key key}) {
    final design = Design.of(context);
    return SingleChildScrollView(
      key: key,
      padding: EdgeInsets.all(design.spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: design.spacing.md),
          AppText.headline('Welcome to learning', textAlign: TextAlign.center),
          SizedBox(height: design.spacing.xs),
          AppText.body(
            'Log in or sign up for an account',
            color: design.colors.textSecondary,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: design.spacing.xxl),
          AppButton.primary(
            label: 'Continue with Mobile Number',
            fullWidth: true,
            leading: const Icon(LucideIcons.smartphone),
            onPressed: () => context.push('/mobile-login'),
          ),
          SizedBox(height: design.spacing.md),
          AppButton.secondary(
            label: 'Continue with Student ID',
            fullWidth: true,
            leading: const Icon(LucideIcons.mail),
            onPressed: () => context.push('/password-login'),
          ),
          SizedBox(height: design.spacing.md),
          AppButton.secondary(
            label: 'Continue with Google',
            fullWidth: true,
            leading: const Icon(LucideIcons.chrome),
            onPressed: () => context.go('/home'),
          ),
          SizedBox(height: design.spacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.body('Don\'t have an account? '),
              GestureDetector(
                child: AppText.body(
                  'Sign up',
                  color: design.colors.primary,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => context.push('/signup'),
              ),
            ],
          ),
          SizedBox(height: design.spacing.xl),
        ],
      ),
    );
  }
}

