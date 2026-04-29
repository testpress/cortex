import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

/// Personalized greeting and date section for the home dashboard.
class HomeGreetingSection extends StatelessWidget {
  const HomeGreetingSection({
    super.key,
    required this.userName,
    this.showName = true,
  });

  final String userName;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final l10n = L10n.of(context);
    final greeting = l10n.getGreeting();
    final displayGreeting = showName ? '$greeting, $userName' : greeting;

    return Container(
      padding: EdgeInsets.only(
        left: design.spacing.md,
        right: design.spacing.md,
        top: 0,
        bottom: design.spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.headline(
            displayGreeting,
            color: design.colors.textPrimary,
          ),
          AppText.bodySmall(
            l10n.getTodayDate(),
            color: design.colors.textSecondary,
          ),
        ],
      ),
    );
  }

}
