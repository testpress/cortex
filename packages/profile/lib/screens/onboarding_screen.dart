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
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Scaffold(
      backgroundColor: design.colors.primary,
      body: AppConfig.splashScreenImage.isNotEmpty
          ? SizedBox.expand(
              child: Image.asset(
                AppConfig.splashScreenImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: Icon(
                        LucideIcons.graduationCap,
                        size: 80,
                        color: design.colors.primary,
                      ),
                    ),
                  );
                },
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
