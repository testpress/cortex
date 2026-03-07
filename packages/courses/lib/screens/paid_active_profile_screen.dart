import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/paid_active_profile_header.dart';
import '../widgets/paid_active_profile_snapshot.dart';
import '../widgets/paid_active_enrolled_courses_section.dart';
import '../widgets/paid_active_recent_activity_section.dart';
import '../widgets/paid_active_account_preferences_section.dart';
import '../widgets/dashboard_header.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key, this.onOpenNotifications});

  final VoidCallback? onOpenNotifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);

    final userAsync = ref.watch(currentUserProvider);
    final statsAsync = ref.watch(currentUserStatsProvider);
    final enrolledCoursesAsync = ref.watch(enrolledCoursesProvider);
    final recentActivityAsync = ref.watch(recentActivityProvider);

    final l10n = L10n.of(context);

    return Scaffold(
      backgroundColor: design.colors.canvas,
      body: Column(
        children: [
          DashboardHeader(title: l10n.profileTabTitle),
          Expanded(
            child: AppScroll(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: design.spacing.md),

                // Profile Header Area
                userAsync.when(
                  data: (user) => ProfileHeader(
                    name: user.name,
                    avatarUrl: user.avatar,
                    joinedDate: user.joinedDate,
                  ),
                  loading: () => const SizedBox(height: 200),
                  error: (err, __) => AppErrorView(
                    message: err.toString(),
                    onRetry: () => ref.refresh(currentUserProvider),
                  ),
                ),

                SizedBox(height: design.spacing.xl),

                // Stats Snapshot
                statsAsync.when(
                  data: (stats) => ProfileLearningSnapshot(
                    lessonsFinished: stats.lessonsFinished,
                    testsAttempted: stats.testsAttempted,
                    assessmentsDone: stats.assessmentsDone,
                    strongestIn: stats.strongestSubject,
                    focusNeededIn: stats.weakSubject,
                  ),
                  loading: () => const SizedBox(height: 200),
                  error: (err, __) => AppErrorView(
                    message: err.toString(),
                    onRetry: () => ref.refresh(currentUserStatsProvider),
                  ),
                ),

                SizedBox(height: design.spacing.xl),

                // Courses Carousel
                enrolledCoursesAsync.when(
                  data: (courses) => EnrolledCoursesSection(courses: courses),
                  loading: () => const SizedBox(height: 150),
                  error: (err, __) => AppErrorView(
                    message: err.toString(),
                    onRetry: () => ref.refresh(enrolledCoursesProvider),
                  ),
                ),

                SizedBox(height: design.spacing.xl),

                // Recent Activity
                recentActivityAsync.when(
                  data: (activities) =>
                      RecentActivitySection(activities: activities),
                  loading: () => const SizedBox(height: 160),
                  error: (err, __) => AppErrorView(
                    message: err.toString(),
                    onRetry: () => ref.refresh(recentActivityProvider),
                  ),
                ),

                SizedBox(height: design.spacing.xl),

                // Account & Preferences
                AccountPreferencesSection(
                  onNotificationsTap:
                      onOpenNotifications ??
                      () => context.pushNamed('profile-notifications'),
                ),

                SizedBox(height: design.spacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
