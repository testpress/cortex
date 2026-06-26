import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

class ExploreActionTile extends StatelessWidget {
  const ExploreActionTile({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return AppSemantics.button(
      label: title,
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(design.radius.md),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(design.spacing.md),
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.circular(design.radius.md),
            border: Border.all(color: design.colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.body(
                title,
                color: design.colors.textPrimary,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: design.spacing.xs),
              AppText.caption(description, color: design.colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
