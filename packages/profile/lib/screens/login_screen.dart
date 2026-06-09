import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core/legacy_icons.dart' as legacy;
import 'package:core/core.dart';
import 'package:core/data/data.dart';
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
  bool _hasAutoRedirected = false;

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

    final settings = ref.watch(instituteSettingsProvider);
    final allowedMethods =
        settings?.allowedLoginMethods ?? const [LoginMethod.formLogin];
    final googleLoginEnabled = settings?.googleLoginEnabled ?? false;

    final showOtp = allowedMethods.contains(LoginMethod.otpLogin);
    final showForm = allowedMethods.contains(LoginMethod.formLogin);
    final showSocial =
        allowedMethods.contains(LoginMethod.socialLogin) && googleLoginEnabled;

    final activeCount =
        (showOtp ? 1 : 0) + (showForm ? 1 : 0) + (showSocial ? 1 : 0);

    if (activeCount == 1 && (showForm || showOtp) && !_hasAutoRedirected) {
      _hasAutoRedirected = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (showForm) {
          context.pushReplacement('/password-login');
        } else if (showOtp) {
          context.pushReplacement('/mobile-login');
        }
      });
      // Return empty scaffold while redirecting to prevent flicker
      return Scaffold(backgroundColor: design.colors.surface);
    }

    // Scale down the carousel area slightly if keyboard is open to preserve space
    final flexTop = bottomInset > 0 ? 25 : 55;
    final flexBottom = bottomInset > 0 ? 75 : 45;

    return Scaffold(
      backgroundColor: design.colors.surface,
      body: Container(
        color: design.colors.primary.withValues(alpha: 0.05),
        child: Column(
          children: [
            Expanded(flex: flexTop, child: _buildBrandingSection()),
            Expanded(
              flex: flexBottom,
              child: Container(
                decoration: BoxDecoration(
                  color: design.colors.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  child: _buildOptions(key: const ValueKey('options')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingSection() {
    final design = Design.of(context);
    final settings = ref.watch(instituteSettingsProvider);
    final name = settings?.name;
    final instituteName = (name != null && name.isNotEmpty) ? name : 'CORTEX';

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
              _buildCarouselItem(
                LucideIcons.globe,
                'Learn Anywhere',
                'Access courses and materials on the go.',
              ),
              _buildCarouselItem(
                LucideIcons.barChart,
                'Track Progress',
                'Stay on top of your learning goals.',
              ),
              _buildCarouselItem(
                LucideIcons.award,
                'Achieve Success',
                'Get certified and advance your career.',
              ),
            ],
          ),
          Positioned(
            top: design.spacing.lg,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.graduationCap,
                  color: design.colors.primary,
                  size: 28,
                ),
                SizedBox(width: design.spacing.xs),
                AppText.headline(
                  instituteName,
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
                    color: _currentPage == index
                        ? design.colors.primary
                        : design.colors.border,
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
      child: FittedBox(
        fit: BoxFit.scaleDown,
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
      ),
    );
  }

  Widget _buildOptions({required Key key}) {
    final design = Design.of(context);
    final settings = ref.watch(instituteSettingsProvider);
    final allowedMethods =
        settings?.allowedLoginMethods ?? const [LoginMethod.formLogin];
    final allowSignup = settings?.allowSignup ?? false;
    final googleLoginEnabled = settings?.googleLoginEnabled ?? false;

    final showOtp = allowedMethods.contains(LoginMethod.otpLogin);
    final showForm = allowedMethods.contains(LoginMethod.formLogin);
    final showSocial =
        allowedMethods.contains(LoginMethod.socialLogin) && googleLoginEnabled;

    final loginIdLabel = settings?.loginIdLabel;
    final displayLoginIdLabel =
        (loginIdLabel != null && loginIdLabel.isNotEmpty)
        ? loginIdLabel
        : 'Student ID';

    final buttons = [
      if (showOtp)
        AppButton.primary(
          label: 'Continue with Mobile Number',
          fullWidth: true,
          leading: const Icon(LucideIcons.smartphone),
          onPressed: () => context.push('/mobile-login'),
        ),
      if (showForm)
        AppButton.secondary(
          label: 'Continue with $displayLoginIdLabel',
          fullWidth: true,
          leading: const Icon(LucideIcons.mail),
          onPressed: () => context.push('/password-login'),
        ),
      if (showSocial)
        AppButton.secondary(
          label: 'Continue with Google',
          fullWidth: true,
          leading: const Icon(legacy.LucideIcons.chrome),
          onPressed: () => context.go('/home'),
        ),
    ];

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
          for (int i = 0; i < buttons.length; i++) ...[
            buttons[i],
            if (i < buttons.length - 1) SizedBox(height: design.spacing.md),
          ],
          SizedBox(height: design.spacing.xxl),
          if (allowSignup)
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
