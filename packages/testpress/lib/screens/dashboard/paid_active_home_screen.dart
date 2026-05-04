import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart' as dto;
import 'package:profile/profile.dart';
import 'package:courses/courses.dart';
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
    final user = userAsync.valueOrNull;

    final isBannerPresent = config.instituteLogoUrl != null;

    final whatsNewLessons = whatsNewAsync.valueOrNull ?? [];
    final resumeLessons = resumeLearningAsync.valueOrNull ?? [];

    final dummyCompletedLessons = [
      const dto.DashboardContentDto(
        id: '6',
        title: 'Cell Biology',
        chapterTitle: 'Biology Class 11',
        progress: 100,
        duration: '1h',
        coverImage: 'https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=500&q=80',
        contentType: dto.DashboardContentType.video,
        sectionType: dto.DashboardSectionType.recentlyCompleted,
      ),
      const dto.DashboardContentDto(
        id: '7',
        title: 'Genetics',
        chapterTitle: 'Biology Class 12',
        progress: 100,
        duration: '2h 15m',
        coverImage: 'https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=500&q=80',
        contentType: dto.DashboardContentType.video,
        sectionType: dto.DashboardSectionType.recentlyCompleted,
      ),
      const dto.DashboardContentDto(
        id: '8',
        title: 'Plant Physiology',
        chapterTitle: 'Biology Class 11',
        progress: 100,
        duration: '1h 20m',
        coverImage: 'https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=500&q=80',
        contentType: dto.DashboardContentType.video,
        sectionType: dto.DashboardSectionType.recentlyCompleted,
      ),
    ];

    final topCarousel = heroBanners.when(
      data: (data) => HeroBannerCarousel(
        banners: data.map(_mapHeroBanner).toList(),
      ),
      loading: () => const SizedBox(height: 180),
      error: (error, stack) => const SizedBox.shrink(),
    );

    final studyMomentum = momentum.when(
      data: (data) => StudyMomentumGrid(momentum: data),
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (err, stack) => const SizedBox.shrink(),
    );

    final topLearnersSection = learnersState.when(
      data: (learners) {
        if (learners.isEmpty) return const SizedBox.shrink();
        
        // Manual partitioning for podium (top 3) and list (rest)
        final podiumCount = learners.length > 3 ? 3 : learners.length;
        final top = learners.sublist(0, podiumCount);
        final others = learners.sublist(podiumCount);

        return TopLearnersSection(
          topLearners: top,
          otherLearners: others,
        );
      },
      loading: () => const SizedBox(height: 200),
      error: (error, stack) => const SizedBox.shrink(),
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
      recentlyCompletedLessons: dummyCompletedLessons,
      config: config,
    );

    return Scaffold(
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
            onMenuPressed: () {
              ref.read(isHomeDrawerOpenProvider.notifier).state = true;
            },
          );

          return Column(
            children: [
              if (isBannerPresent)
                InstituteBanner(
                  logoUrl: config.instituteLogoUrl!,
                  isLocal: config.isLocalLogo,
                  userName: user?.name ?? 'Student',
                  enrollmentId: user?.id ?? '-',
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
