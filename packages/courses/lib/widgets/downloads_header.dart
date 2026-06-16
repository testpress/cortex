import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class DownloadsHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final List<Widget>? actions;

  const DownloadsHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(
          bottom: BorderSide(color: design.colors.divider, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            design.spacing.md,
            design.spacing.md,
            design.spacing.screenPadding,
            design.spacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onBack,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2), // Optical alignment
                  child: Icon(
                    LucideIcons.arrowLeft,
                    color: design.colors.textPrimary,
                    size: 22,
                  ),
                ),
              ),
              SizedBox(width: design.spacing.sm),
              Expanded(
                child: AppText.title(
                  title,
                  color: design.colors.textPrimary,
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}
