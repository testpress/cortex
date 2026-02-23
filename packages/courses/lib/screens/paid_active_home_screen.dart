import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:data/data.dart' as dto;
import '../providers/dashboard_providers.dart';
import '../widgets/greeting_section.dart';
import '../widgets/contextual_hero_card.dart';
import '../widgets/today_snapshot.dart';
import '../widgets/study_momentum_grid.dart';
import '../widgets/quick_access_grid.dart';
import '../widgets/hero_banner_carousel.dart';
import '../widgets/top_learners_section.dart';
import '../widgets/promotional_banners.dart';
import '../widgets/dashboard_header.dart';

class PaidActiveHomeScreen extends ConsumerWidget {
  const PaidActiveHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);

    final todayClasses = ref.watch(todayClassesProvider);
    final pendingAssignments = ref.watch(pendingAssignmentsProvider);
    final upcomingTests = ref.watch(upcomingTestsProvider);
    final momentum = ref.watch(studyMomentumProvider);
    final user = ref.watch(currentUserProvider);
    final heroBanners = ref.watch(heroBannersProvider);
    final promotionBanners = ref.watch(promotionBannersProvider);
    final topLearners = ref.watch(topLearnersProvider);
    final otherLearners = ref.watch(otherLearnersProvider);
    final shortcuts = ref.watch(quickShortcutsProvider);

    return Scaffold(
      backgroundColor: design.colors.canvas,
      body: Column(
        children: [
          DashboardHeader(title: L10n.of(context).homeHeaderTitle),
          Expanded(
            child: AppScroll(
              padding: EdgeInsets.symmetric(vertical: design.spacing.md),
              children: [
                user.when(
                  data: (data) => HomeGreetingSection(userName: data.name),
                  loading: () => const SizedBox(height: 50),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                heroBanners.when(
                  data: (data) => HeroBannerCarousel(
                    banners: data.map(_mapHeroBanner).toList(),
                  ),
                  loading: () => const SizedBox(height: 180),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 16),

                todayClasses.when(
                  data: (classes) {
                    final liveOrUpcoming = classes.firstWhere(
                      (c) =>
                          c.status == dto.LiveClassStatus.live ||
                          c.status == dto.LiveClassStatus.upcoming,
                      orElse: () => classes.first,
                    );
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.md,
                      ),
                      child: ContextualHeroCard(
                        action: HeroAction(
                          type:
                              liveOrUpcoming.status == dto.LiveClassStatus.live
                              ? HeroActionType.joinClass
                              : HeroActionType.prepareTest,
                          title: liveOrUpcoming.topic,
                          subject: liveOrUpcoming.subject,
                          metadata: liveOrUpcoming.faculty,
                          timeInfo: liveOrUpcoming.time,
                        ),
                        onActionClick: () {},
                      ),
                    );
                  },
                  loading: () => const SizedBox(height: 120),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 24),

                Builder(
                  builder: (context) {
                    if (todayClasses.isLoading ||
                        pendingAssignments.isLoading ||
                        upcomingTests.isLoading) {
                      return const Center(child: AppLoadingIndicator());
                    }

                    return TodaySnapshot(
                      classes: (todayClasses.value ?? [])
                          .map(_mapClass)
                          .toList(),
                      assignments: (pendingAssignments.value ?? [])
                          .map(_mapAssignment)
                          .toList(),
                      tests: (upcomingTests.value ?? []).map(_mapTest).toList(),
                    );
                  },
                ),

                momentum.when(
                  data: (data) => StudyMomentumGrid(momentum: data),
                  loading: () => const Center(child: AppLoadingIndicator()),
                  error: (err, stack) => const SizedBox.shrink(),
                ),

                topLearners.when(
                  data: (top) => otherLearners.when(
                    data: (others) => TopLearnersSection(
                      topLearners: top.map(_mapLearner).toList(),
                      otherLearners: others.map(_mapLearner).toList(),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  loading: () => const SizedBox(height: 200),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                promotionBanners.when(
                  data: (data) => UpdatesAnnouncementsSection(
                    banners: data.map(_mapPromotionBanner).toList(),
                    onViewAll: () {
                      // Handle view all navigation
                    },
                  ),
                  loading: () => const SizedBox(height: 100),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                shortcuts.when(
                  data: (data) => QuickAccessGrid(
                    shortcuts: data.map(_mapShortcut).toList(),
                  ),
                  loading: () => const SizedBox(height: 150),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  HeroBanner _mapHeroBanner(dto.DashboardBannerDto d) {
    return HeroBanner(
      id: d.id,
      imageUrl: d.imageUrl,
      title: d.title,
      link: d.link ?? '#',
    );
  }

  AnnouncementBanner _mapPromotionBanner(dto.DashboardBannerDto d) {
    return AnnouncementBanner(
      id: d.id,
      title: d.title,
      description: d.description ?? '',
      bgColor: Color(d.bgColor ?? 0xFFFFFFFF),
      textColor: Color(d.textColor ?? 0xFF000000),
    );
  }

  Learner _mapLearner(dto.LearnerDto d) {
    return Learner(
      id: d.id,
      rank: d.rank,
      name: d.name,
      avatar: d.avatar,
      points: d.points,
      coursesCompleted: d.coursesCompleted,
      streakDays: d.streakDays,
      badges: d.badges
          .map(
            (b) => LearnerBadge(
              icon: b.icon,
              label: b.label,
              color: Color(b.color),
            ),
          )
          .toList(),
    );
  }

  Shortcut _mapShortcut(dto.QuickShortcutDto d) {
    return Shortcut(
      id: d.id,
      label: d.label,
      icon: switch (d.iconType) {
        dto.ShortcutIconType.video => ShortcutIcon.video,
        dto.ShortcutIconType.practice => ShortcutIcon.practice,
        dto.ShortcutIconType.tests => ShortcutIcon.tests,
        dto.ShortcutIconType.notes => ShortcutIcon.notes,
        dto.ShortcutIconType.doubts => ShortcutIcon.doubts,
        dto.ShortcutIconType.schedule => ShortcutIcon.schedule,
      },
    );
  }

  ClassItem _mapClass(dto.LiveClassDto d) {
    return ClassItem(
      id: d.id,
      subject: d.subject,
      time: d.time,
      faculty: d.faculty,
      status: switch (d.status) {
        dto.LiveClassStatus.live => ClassStatus.live,
        dto.LiveClassStatus.upcoming => ClassStatus.upcoming,
        dto.LiveClassStatus.completed => ClassStatus.completed,
      },
      topic: d.topic,
    );
  }

  Assignment _mapAssignment(dto.AssignmentDto d) {
    return Assignment(
      id: d.id,
      title: d.title,
      subject: d.subject,
      dueTime: d.dueTime,
      status: switch (d.status) {
        dto.AssignmentStatus.pending => AssignmentStatus.pending,
        dto.AssignmentStatus.submitted => AssignmentStatus.submitted,
        dto.AssignmentStatus.overdue => AssignmentStatus.overdue,
      },
      progress: d.progress / 100.0,
      description: d.description,
    );
  }

  Test _mapTest(dto.TestDto d) {
    return Test(
      id: d.id,
      title: d.title,
      time: d.time,
      duration: d.duration,
      isImportant: d.isImportant,
      type: switch (d.type) {
        dto.TestType.mock => TestType.mock,
        dto.TestType.chapter => TestType.chapter,
        dto.TestType.practice => TestType.practice,
      },
    );
  }
}
