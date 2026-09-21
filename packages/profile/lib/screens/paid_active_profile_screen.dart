import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../providers/profile_providers.dart';

import '../widgets/paid_active_profile_header.dart';
// import '../widgets/paid_active_profile_snapshot.dart';
// import '../widgets/paid_active_enrolled_courses_section.dart';

import '../widgets/paid_active_account_preferences_section.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({
    super.key,
    this.onEditProfile,
    this.onOpenNotifications,
    this.onOpenCertificates,
  });

  final VoidCallback? onEditProfile;
  final VoidCallback? onOpenNotifications;
  final VoidCallback? onOpenCertificates;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(userRepositoryProvider.future).then((repo) {
          repo.refreshProfile().ignore();
        }).ignore();
      }
    });
  }

  void _handleEditProfile() async {
    if (widget.onEditProfile != null) {
      widget.onEditProfile!();
    } else {
      final result = await context.pushNamed('profile-edit');
      if (result == true && mounted) {
        ref.read(userRepositoryProvider.future).then((repo) {
          repo.refreshProfile().ignore();
        }).ignore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final isLoggedIn = ref.watch(authProvider).asData?.value ?? false;
    if (!isLoggedIn) return const SizedBox.shrink();

    final userAsync = ref.watch(userProvider);
    // final statsAsync = ref.watch(studyMomentumProvider);
    // final enrolledCoursesAsync = ref.watch(profileEnrollmentProvider);

    final l10n = L10n.of(context);

    return Container(
      color: design.colors.canvas,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              SectionHeader(title: l10n.profileTabTitle),
              Expanded(
                child: AppScroll(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.paddingOf(context).bottom,
                  ),
                  children: [
                    SizedBox(height: design.spacing.md),

                    // Profile Header Area
                    userAsync.when(
                      data: (user) => ProfileHeader(
                        name: user?.name ?? '',
                        avatarUrl: user?.avatar ?? '',
                        joinedDate: user?.joinedDate,
                        onEditProfileTap: _handleEditProfile,
                      ),
                      loading: () => const SizedBox(height: 100),
                      error: (err, _) => const SizedBox(height: 100),
                    ),

                    SizedBox(height: design.spacing.xl),

                    // Account & Preferences
                    AccountPreferencesSection(
                      onEditProfileTap: _handleEditProfile,
                      onNotificationsTap:
                          widget.onOpenNotifications ??
                          () => context.pushNamed('profile-notifications'),
                      onCertificatesTap:
                          widget.onOpenCertificates ??
                          () => context.pushNamed('profile-certificates'),
                      onLogoutTap: () {
                        ref.read(isLogoutSheetOpenProvider.notifier).state =
                            true;
                      },
                    ),

                    SizedBox(height: design.spacing.xxl),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
