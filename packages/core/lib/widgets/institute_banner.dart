import 'package:flutter/widgets.dart';
import '../../core.dart';

/// A branding banner displayed at the top of the app, typically showing
/// the institute logo and user identification details.
class InstituteBanner extends StatelessWidget {
  final String logoUrl;
  final bool isLocal;
  final String userName;
  final String enrollmentId;

  const InstituteBanner({
    super.key,
    required this.logoUrl,
    required this.userName,
    required this.enrollmentId,
    this.isLocal = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: design.isDark ? design.colors.surface : const Color(0xFFFFFFFF),
        border: Border(
          bottom: BorderSide(
            color: design.colors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Institute Logo
          if (isLocal)
            Image.asset(
              logoUrl,
              package: 'core',
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
                style: TextStyle(
                  color: design.colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
