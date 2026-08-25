import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return ColoredBox(
      color: design.colors.primary,
      child: AppConfig.splashScreenImage.isNotEmpty
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
