import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart' as dto;
import 'package:profile/profile.dart';
import 'package:courses/courses.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'widgets/lesson_cards_section.dart';

class PaidActiveHomeScreen extends ConsumerWidget {
  const PaidActiveHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);

    final config = ref.watch(dto.clientConfigProvider);
    final todayClasses = ref.watch(todayClassesProvider);
    final pendingAssignments = ref.watch(pendingAssignmentsProvider);
    final upcomingTests = ref.watch(upcomingTestsProvider);
    final momentum = ref.watch(dto.studyMomentumProvider);
    
    final userAsync = ref.watch(userProvider);
    
    final heroBanners = ref.watch(heroBannersProvider);
    final promotionBanners = ref.watch(promotionBannersProvider);
    final learnersState = ref.watch(learnersProvider);
    final shortcuts = ref.watch(quickShortcutsProvider);

    final whatsNewAsync = ref.watch(whatsNewFeedProvider);
    final resumeLearningAsync = ref.watch(resumeLearningFeedProvider);
    final recentlyCompletedAsync = ref.watch(recentlyCompletedFeedProvider);
    final user = userAsync.valueOrNull;

    final isBannerPresent = config.instituteLogoUrl != null;

    final whatsNewLessons = whatsNewAsync.valueOrNull ?? [];
    final resumeLessons = resumeLearningAsync.valueOrNull ?? [];
    final recentlyCompletedLessons = recentlyCompletedAsync.valueOrNull ?? [];

    final bootstrapState = ref.watch(dashboardBootstrapProvider);
    final hasDashboardCache = (heroBanners.valueOrNull?.isNotEmpty ?? false) ||
        (learnersState.valueOrNull?.isNotEmpty ?? false) ||
        whatsNewLessons.isNotEmpty ||
        resumeLessons.isNotEmpty ||
        recentlyCompletedLessons.isNotEmpty;
    final isBootstrapping = bootstrapState.isLoading && !hasDashboardCache;

    final showHeroSkeleton = isBootstrapping && (heroBanners.valueOrNull?.isEmpty ?? true);

    final topCarousel = HeroBannerCarousel(
      banners: showHeroSkeleton
          ? []
          : (heroBanners.valueOrNull ?? []).map(_mapHeroBanner).toList(),
      isLoading: showHeroSkeleton,
    );

    final studyMomentum = momentum.when(
      data: (data) => StudyMomentumGrid(momentum: data),
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (err, stack) => const SizedBox.shrink(),
    );

    final learners = learnersState.valueOrNull ?? const <dto.LearnerDto>[];
    final topLearnersSection = TopLearnersSection(
      topLearners: learners.take(3).toList(),
      otherLearners: learners.skip(3).toList(),
      isLoading: isBootstrapping,
    );

    final updatesAnnouncements = promotionBanners.when(
      data: (data) => UpdatesAnnouncementsSection(
        banners: data.map(_mapPromotionBanner).toList(),
        onViewAll: () {
          // Handle view all navigation
        },
      ),
      loading: () => const SizedBox(height: 100),
      error: (error, stack) => const SizedBox.shrink(),
    );

    final lessonCardsSection = LessonCardsSectionWidget(
      resumeLessons: resumeLessons,
      whatsNewLessons: whatsNewLessons,
      recentlyCompletedLessons: recentlyCompletedLessons,
      config: config,
      isLoading: isBootstrapping,
    );

    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: design.colors.skeleton,
          highlightColor: design.colors.onSkeleton,
          duration: MotionPreferences.duration(context, const Duration(milliseconds: 800)),
        ),
        ignoreContainers: false,
      ),
      child: Scaffold(
      backgroundColor: design.colors.canvas,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;

          final header = DashboardHeader(
            title: L10n.of(context).homeHeaderTitle,
            isLandscape: isLandscape,
            showTitle: !isBannerPresent,
            greeting: isBannerPresent ? L10n.of(context).getGreeting() : null,
            greetingSubtitle: isBannerPresent ? L10n.of(context).getTodayDate() : null,
            backgroundColor: isBannerPresent ? design.colors.canvas : null,
            showBottomBorder: !isBannerPresent,
            useSafeArea: !isBannerPresent,
            customTopPadding: isBannerPresent ? 8 : null,
          );

          return Column(
            children: [
              if (isBannerPresent)
                InstituteBanner(
                  logoUrl: config.instituteLogoUrl!,
                  isLocal: config.isLocalLogo,
                  userName: user?.name ?? 'Student',
                  enrollmentId: user?.id ?? '-',
                  onMenuPressed: () {
                    ref.read(isHomeDrawerOpenProvider.notifier).state = true;
                  },
                ),
              if (!isBannerPresent) header,
              Expanded(
                child: AppScroll(
                  padding: EdgeInsets.symmetric(vertical: design.spacing.md),
                  children: [
                    if (isBannerPresent) header,
                    if (!isBannerPresent)
                      HomeGreetingSection(
                        userName: user?.name ?? '',
                      ),
                    topCarousel,
                    const SizedBox(height: 16),
                    if (isBannerPresent) ...[
                      // Brilliant specific order
                      lessonCardsSection,
                      updatesAnnouncements,
                      const SizedBox(height: 24),
                      studyMomentum,
                      const SizedBox(height: 24),
                      topLearnersSection,
                    ] else ...[
                      // Standard order
                      if (config.showContextualHero)
                        todayClasses.when(
                          data: (classes) {
                            if (classes.isEmpty) return const SizedBox.shrink();
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
                                  type: liveOrUpcoming.status ==
                                          dto.LiveClassStatus.live
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
                          error: (error, stack) => const SizedBox.shrink(),
                        ),
                      const SizedBox(height: 16),
                      if (config.showTodaySchedule)
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
                              tests: (upcomingTests.value ?? []).toList(),
                            );
                          },
                        ),
                      const SizedBox(height: 24),
                      lessonCardsSection,
                      studyMomentum,
                      topLearnersSection,
                      updatesAnnouncements,
                      if (config.showQuickAccess)
                        shortcuts.when(
                          data: (data) => QuickAccessGrid(
                            shortcuts: data.map(_mapShortcut).toList(),
                          ),
                          loading: () => const SizedBox(height: 150),
                          error: (error, stack) => const SizedBox.shrink(),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ),
   );
  }

  HeroBanner _mapHeroBanner(dto.DashboardBannerDto d) {
    return HeroBanner(
      id: d.id,
      imageUrl: d.imageUrl,
      title: d.title ?? '',
      link: d.link ?? '#',
    );
  }

  AnnouncementBanner _mapPromotionBanner(dto.DashboardBannerDto d) {
    return AnnouncementBanner(
      id: d.id,
      title: d.title ?? '',
      description: d.description ?? '',
      tag: d.tag,
      bgColor: Color(d.bgColor ?? 0xFFFFFFFF),
      textColor: Color(d.textColor ?? 0xFF000000),
    );
  }

  Shortcut _mapShortcut(QuickShortcutDto d) {
    return Shortcut(
      id: d.id,
      label: d.label,
      icon: switch (d.iconType) {
        ShortcutIconType.video => ShortcutIcon.video,
        ShortcutIconType.practice => ShortcutIcon.practice,
        ShortcutIconType.tests => ShortcutIcon.tests,
        ShortcutIconType.notes => ShortcutIcon.notes,
        ShortcutIconType.doubts => ShortcutIcon.doubts,
        ShortcutIconType.schedule => ShortcutIcon.schedule,
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

  Assignment _mapAssignment(AssignmentDto d) {
    return Assignment(
      id: d.id,
      title: d.title,
      subject: d.subject,
      dueTime: d.dueTime,
      status: d.status,
      progress: d.progress / 100,
      description: d.description,
    );
  }

}
