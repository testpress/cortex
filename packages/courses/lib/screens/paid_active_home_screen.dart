import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:data/models/live_class_dto.dart' as dto;
import 'package:data/models/assignment_dto.dart' as dto;
import 'package:data/models/test_dto.dart' as dto;
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

    return Scaffold(
      backgroundColor: design.isDark
          ? design.colors.surface
          : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          const DashboardHeader(title: 'BrightMinds Academy'),
          Expanded(
            child: AppScroll(
              padding: EdgeInsets.symmetric(vertical: design.spacing.md),
              children: [
                const HomeGreetingSection(userName: 'Arjun Sharma'),

                const HeroBannerCarousel(
                  banners: [
                    HeroBanner(
                      id: "1",
                      imageUrl:
                          "https://images.unsplash.com/photo-1762438135827-428acc0e8941?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdHVkZW50JTIwYWNoaWV2ZW1lbnQlMjBzdWNjZXNzJTIwY2VsZWJyYXRpb258ZW58MXx8fHwxNzY3OTU5MjY3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
                      title: "JEE 2025 Results: 95% Selection Rate",
                      link: "#",
                    ),
                    HeroBanner(
                      id: "2",
                      imageUrl:
                          "https://images.unsplash.com/photo-1584792264192-dd873d389386?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxlZHVjYXRpb24lMjBhbm5vdW5jZW1lbnQlMjBiYW5uZXJ8ZW58MXx8fHwxNzY3OTU5MjY3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
                      title: "New Batch Starting: JEE 2027 Foundation",
                      link: "#",
                    ),
                    HeroBanner(
                      id: "3",
                      imageUrl:
                          "https://images.unsplash.com/photo-1660795864432-6e63a88bfb40?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxleGFtJTIwcmVzdWx0cyUyMGNlbGVicmF0aW9uJTIwc3R1ZGVudHN8ZW58MXx8fHwxNzY3OTU5MjY3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
                      title: "Special Merit Scholarship Program",
                      link: "#",
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                  child: ContextualHeroCard(
                    action: const HeroAction(
                      type: HeroActionType.joinClass,
                      title: "Organic Chemistry - Reaction Mechanisms",
                      subject: "Chemistry",
                      metadata: "Dr. Rajesh Kumar",
                      timeInfo: "3:00 PM - 5:00 PM",
                    ),
                    onActionClick: () {},
                  ),
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

                const TopLearnersSection(
                  topLearners: [
                    Learner(
                      id: '1',
                      rank: 1,
                      name: 'AlexR_21',
                      avatar:
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
                      points: 1520,
                      coursesCompleted: 12,
                      streakDays: 15,
                      badges: [
                        LearnerBadge(
                          icon: 'crown',
                          label: 'Monthly Cham',
                          color: Color(0xFFFBBF24),
                        ),
                        LearnerBadge(
                          icon: 'brain',
                          label: 'Quiz Master',
                          color: Color(0xFFEC4899),
                        ),
                        LearnerBadge(
                          icon: 'rocket',
                          label: 'Fast Learner',
                          color: Color(0xFF3B82F6),
                        ),
                        LearnerBadge(
                          icon: 'fire',
                          label: 'Streak King',
                          color: Color(0xFFF97316),
                        ),
                      ],
                    ),
                    Learner(
                      id: '2',
                      rank: 2,
                      name: 'LearnWithMira',
                      avatar:
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
                      points: 1340,
                      coursesCompleted: 9,
                      streakDays: 18,
                      badges: [
                        LearnerBadge(
                          icon: 'rocket',
                          label: 'Top Designer',
                          color: Color(0xFFF97316),
                        ),
                        LearnerBadge(
                          icon: 'brain',
                          label: 'Quiz Master',
                          color: Color(0xFFEC4899),
                        ),
                        LearnerBadge(
                          icon: 'fire',
                          label: 'Streak Star',
                          color: Color(0xFFF97316),
                        ),
                      ],
                    ),
                    Learner(
                      id: '3',
                      rank: 3,
                      name: 'CodeNinja_47',
                      avatar:
                          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
                      points: 1180,
                      coursesCompleted: 8,
                      streakDays: 12,
                      badges: [
                        LearnerBadge(
                          icon: 'rocket',
                          label: 'Code Master',
                          color: Color(0xFF3B82F6),
                        ),
                        LearnerBadge(
                          icon: 'brain',
                          label: 'Quiz Pro',
                          color: Color(0xFFEC4899),
                        ),
                      ],
                    ),
                  ],
                  otherLearners: [
                    Learner(
                      id: '4',
                      rank: 4,
                      name: 'DesignGuru',
                      avatar:
                          'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200',
                      points: 980,
                      coursesCompleted: 8,
                      streakDays: 8,
                      badges: [],
                    ),
                    Learner(
                      id: '5',
                      rank: 5,
                      name: 'MathMaster',
                      avatar:
                          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200',
                      points: 890,
                      coursesCompleted: 7,
                      streakDays: 7,
                      badges: [],
                    ),
                    Learner(
                      id: '6',
                      rank: 6,
                      name: 'GrowthHacker',
                      avatar:
                          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
                      points: 832,
                      coursesCompleted: 6,
                      streakDays: 7,
                      badges: [],
                    ),
                    Learner(
                      id: '7',
                      rank: 7,
                      name: 'DevWizard',
                      avatar:
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
                      points: 791,
                      coursesCompleted: 5,
                      streakDays: 7,
                      badges: [],
                    ),
                    Learner(
                      id: '8',
                      rank: 8,
                      name: 'You',
                      avatar:
                          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
                      points: 790,
                      coursesCompleted: 4,
                      streakDays: 4,
                      badges: [],
                    ),
                    Learner(
                      id: '9',
                      rank: 9,
                      name: 'UIUXExplorer',
                      avatar:
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
                      points: 788,
                      coursesCompleted: 4,
                      streakDays: 6,
                      badges: [],
                    ),
                    Learner(
                      id: '10',
                      rank: 10,
                      name: 'DataDriven',
                      avatar:
                          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
                      points: 765,
                      coursesCompleted: 5,
                      streakDays: 5,
                      badges: [],
                    ),
                  ],
                ),

                const PromotionalBanners(
                  banners: [
                    AnnouncementBanner(
                      id: '1',
                      title: '📚 Study Smart, Not Hard',
                      description:
                          'Master complex topics with our structured learning paths - Physics, Chemistry & Math all in one place',
                      bgColor: Color(0xFFEFF6FF),
                      textColor: Color(0xFF1E40AF),
                    ),
                    AnnouncementBanner(
                      id: '2',
                      title: '🎯 Your Daily Study Companion',
                      description:
                          'Track progress across 45+ chapters with video lessons, practice sets, and chapter tests designed by experts',
                      bgColor: Color(0xFFECFDF5),
                      textColor: Color(0xFF065F46),
                    ),
                    AnnouncementBanner(
                      id: '3',
                      title: '⚡ Learn at Your Pace',
                      description:
                          '180+ hours of content available 24/7 - watch recordings, download notes, and practice anytime',
                      bgColor: Color(0xFFFAF5FF),
                      textColor: Color(0xFF6B21A8),
                    ),
                  ],
                ),

                QuickAccessGrid(
                  shortcuts: [
                    const Shortcut(
                      id: '1',
                      icon: ShortcutIcon.video,
                      label: 'Recordings',
                    ),
                    const Shortcut(
                      id: '2',
                      icon: ShortcutIcon.practice,
                      label: 'Practice',
                    ),
                    const Shortcut(
                      id: '3',
                      icon: ShortcutIcon.tests,
                      label: 'Tests',
                    ),
                    const Shortcut(
                      id: '4',
                      icon: ShortcutIcon.notes,
                      label: 'Notes',
                    ),
                    const Shortcut(
                      id: '5',
                      icon: ShortcutIcon.doubts,
                      label: 'Ask Doubt',
                    ),
                    const Shortcut(
                      id: '6',
                      icon: ShortcutIcon.schedule,
                      label: 'Schedule',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
