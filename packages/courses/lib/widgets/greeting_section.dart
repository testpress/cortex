import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';

/// Personalized greeting and date section for the home dashboard.
class HomeGreetingSection extends StatelessWidget {
  const HomeGreetingSection({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

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
            '${_getGreeting(context)}, $userName',
            color: design.colors.textPrimary,
          ),
          AppText.bodySmall(
            _getTodayDate(),
            color: design.colors.textSecondary,
          ),
        ],
      ),
    );
  }

  String _getGreeting(BuildContext context) {
    final l10n = L10n.of(context);
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.greetingMorning;
    if (hour < 17) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  String _getTodayDate() {
    final now = DateTime.now();
    final weekday = DateFormat('EEEE').format(now);
    final date = DateFormat('MMM d').format(now);
    return '$weekday · $date';
  }
}
