import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import '../providers/profile_providers.dart';
import '../widgets/paid_active_profile_header.dart';
import '../widgets/paid_active_profile_snapshot.dart';
import '../widgets/paid_active_enrolled_courses_section.dart';
import '../widgets/paid_active_recent_activity_section.dart';
import '../widgets/paid_active_account_preferences_section.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({
    super.key,
    this.onEditProfile,
    this.onOpenNotifications,
    this.onOpenCertificates,
    this.onOpenSettings,
  });

  final VoidCallback? onEditProfile;
  final VoidCallback? onOpenNotifications;
  final VoidCallback? onOpenCertificates;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);

    final user = ref.watch(authProvider);
    final statsAsync = ref.watch(studyMomentumProvider);
    final enrolledCoursesAsync = ref.watch(enrollmentProvider);
    final recentActivityAsync = ref.watch(profileRecentActivityProvider);

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
                ProfileHeader(
                  name: user.name,
                  avatarUrl: user.avatar,
                  joinedDate: user.joinedDate,
                  onEditProfileTap:
                      onEditProfile ?? () => context.pushNamed('profile-edit'),
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
                    onRetry: () => ref.refresh(studyMomentumProvider),
                  ),
                ),

                SizedBox(height: design.spacing.xl),

                // Courses Carousel
                enrolledCoursesAsync.when(
                  data: (courses) => EnrolledCoursesSection(courses: courses),
                  loading: () => const SizedBox(height: 150),
                  error: (err, __) => AppErrorView(
                    message: err.toString(),
                    onRetry: () => ref.refresh(enrollmentProvider),
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
                    onRetry: () => ref.refresh(profileRecentActivityProvider),
                  ),
                ),

                SizedBox(height: design.spacing.xl),

                // Account & Preferences
                AccountPreferencesSection(
                  onEditProfileTap:
                      onEditProfile ?? () => context.pushNamed('profile-edit'),
                  onNotificationsTap:
                      onOpenNotifications ??
                      () => context.pushNamed('profile-notifications'),
                  onCertificatesTap:
                      onOpenCertificates ??
                      () => context.pushNamed('profile-certificates'),
                  onSettingsTap:
                      onOpenSettings ??
                      () => context.pushNamed('profile-settings'),
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
