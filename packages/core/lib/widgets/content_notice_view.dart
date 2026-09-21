import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';
import '../accessibility/app_semantics.dart';
import 'app_text.dart';

/// A reusable notice view displayed inside lesson detail screens
/// when content is expired, locked, or unavailable.
class ContentNoticeView extends StatelessWidget {
  const ContentNoticeView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: design.spacing.xl),
        child: AppSemantics.container(
          label: '$title. $message',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: design.colors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: design.iconSize.xl,
                  color: design.colors.textSecondary,
                ),
              ),
              SizedBox(height: design.spacing.md),
              AppSemantics.header(
                label: title,
                child: AppText.title(title, textAlign: TextAlign.center),
              ),
              SizedBox(height: design.spacing.xs),
              AppText.subtitle(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
