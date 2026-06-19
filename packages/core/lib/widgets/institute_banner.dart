import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import '../../core.dart';

/// A branding banner displayed at the top of the app, typically showing
/// the institute logo and user identification details.
class InstituteBanner extends StatelessWidget {
  final String logoUrl;
  final String userName;
  final String enrollmentId;
  final VoidCallback? onMenuPressed;

  const InstituteBanner({
    super.key,
    required this.logoUrl,
    required this.userName,
    required this.enrollmentId,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isLocal = logoUrl.startsWith('assets/');

    return Container(
      color: design.isDark ? design.colors.surface : const Color(0xFFFFFFFF),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: design.colors.divider, width: 1),
            ),
          ),
          child: Row(
            children: [
              if (onMenuPressed != null) ...[
                GestureDetector(
                  onTap: onMenuPressed,
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    Icons.menu_rounded,
                    size: 28,
                    color: design.colors.textPrimary,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Institute Logo
                    if (isLocal)
                      Image.asset(
                        logoUrl,
                        height: 40,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      )
                    else
                      Image.network(
                        logoUrl,
                        height: 40,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),

                    // User Info
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppText.subtitle(
                          userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: design.colors.textPrimary,
                          ),
                        ),
                        AppText.caption(
                          enrollmentId,
                          style: TextStyle(color: design.colors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
