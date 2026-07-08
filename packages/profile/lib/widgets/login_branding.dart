import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class LoginBranding extends ConsumerWidget {
  const LoginBranding({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final settings = ref.watch(instituteSettingsProvider);
    final overrideLogoUrl = AppConfig.instituteLogoUrl;
    final apiLogoUrl = settings?.photo;
    final logoUrl = overrideLogoUrl.isNotEmpty
        ? overrideLogoUrl
        : (apiLogoUrl ?? '');

    final name = settings?.name;
    final instituteName = (name != null && name.isNotEmpty) ? name : 'CORTEX';
    final hasLogo = logoUrl.isNotEmpty;
    final isLocal = hasLogo && logoUrl.startsWith('assets/');

    return SizedBox(
      height: 38,
      width: double.infinity,
      child: Center(
        child: hasLogo
            ? (isLocal
                  ? Image.asset(
                      logoUrl,
                      height: 38,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          _buildDefaultLogo(design, instituteName),
                    )
                  : Image.network(
                      logoUrl,
                      height: 38,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          _buildDefaultLogo(design, instituteName),
                    ))
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
