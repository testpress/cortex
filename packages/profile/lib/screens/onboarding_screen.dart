import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _hasNavigated = false;

  void _navigateToLogin() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final currentSettings = ref.watch(instituteSettingsProvider);
    ref.listen(instituteSettingsProvider, (_, settings) {
      if (settings != null) {
        _navigateToLogin();
      }
    });

    if (currentSettings != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToLogin();
      });
    }

    return Scaffold(
      backgroundColor: design.colors.primary,
      body: AppConfig.splashScreenImage.isNotEmpty
          ? SizedBox.expand(
              child: Image.asset(
                AppConfig.splashScreenImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(design.spacing.xl),
                          decoration: BoxDecoration(
                            color: design.colors.onPrimary.withValues(
                              alpha: 0.2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.graduationCap,
                            size: 96,
                            color: design.colors.onPrimary,
                          ),
                        ),
                        SizedBox(height: design.spacing.md),
                        AppText.headline(
                          'Cortex Platform',
                          color: design.colors.onPrimary,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
