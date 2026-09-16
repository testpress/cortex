import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class LoginBranding extends StatelessWidget {
  const LoginBranding({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final instituteName = AppConfig.instituteName;
    final logoPath = AppConfig.instituteLogoPath;
    final hasLogo = logoPath.isNotEmpty;

    return SizedBox(
      height: 38,
      width: double.infinity,
      child: Center(
        child: hasLogo
            ? Image.asset(
                logoPath,
                height: 38,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) =>
                    _buildDefaultLogo(design, instituteName),
              )
            : _buildDefaultLogo(design, instituteName),
      ),
    );
  }

  Widget _buildDefaultLogo(DesignConfig design, String instituteName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(LucideIcons.graduationCap, color: design.colors.primary, size: 28),
        SizedBox(width: design.spacing.sm),
        AppText.headline(
          instituteName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
