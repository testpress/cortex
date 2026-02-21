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
          AppText(
            '${_getGreeting()}, $userName',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
            color: design.colors.textPrimary,
          ),
          const SizedBox(height: 4),
          AppText.bodySmall(
            _getTodayDate(),
            color: design.colors.textSecondary,
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getTodayDate() {
    final now = DateTime.now();
    final weekday = DateFormat('EEEE').format(now);
    final date = DateFormat('MMM d').format(now);
    return '$weekday · $date';
  }
}
