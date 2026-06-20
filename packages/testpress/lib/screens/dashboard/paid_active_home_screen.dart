import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart' as dto;
import 'package:skeletonizer/skeletonizer.dart';
import 'widgets/dashboard_header_widget.dart';
import 'widgets/greeting_section_widget.dart';
import 'widgets/top_carousel_section_widget.dart';
import 'widgets/contextual_hero_section_widget.dart';
import 'widgets/today_schedule_section_widget.dart';
import 'widgets/lesson_cards_section_wrapper.dart';
import 'widgets/announcements_section_widget.dart';
import 'widgets/top_learners_section_widget.dart';
import 'widgets/quick_access_section_widget.dart';
// import 'widgets/study_momentum_section_widget.dart';

class PaidActiveHomeScreen extends ConsumerWidget {
  const PaidActiveHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);

    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: design.colors.skeleton,
          highlightColor: design.colors.onSkeleton,
          duration: MotionPreferences.duration(
            context,
            const Duration(milliseconds: 800),
          ),
        ),
        ignoreContainers: false,
      ),
      child: Scaffold(
        backgroundColor: design.colors.canvas,
        body: const _HomeLayout(),
      ),
    );
  }
}

class _HomeLayout extends ConsumerWidget {
  const _HomeLayout();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;

        return Column(
          children: [
            DashboardHeaderWidget(isLandscape: isLandscape),
            Expanded(
              child: AppScroll(
                padding: EdgeInsets.symmetric(vertical: design.spacing.md),
                children: [
                  const GreetingSectionWidget(),
                  const TopCarouselSectionWidget(),
                  const SizedBox(height: 16),
                  if (dto.AppConfig.showContextualHero)
                    const ContextualHeroSectionWidget(),
                  const SizedBox(height: 16),
                  if (dto.AppConfig.showTodaySchedule)
                    const TodayScheduleSectionWidget(),
                  const SizedBox(height: 24),
                  const LessonCardsSectionWrapper(),
                  const AnnouncementsSectionWidget(),
                  //  Backend doesn't have the support for this and can be enabled once the backend provides the support
                  // const StudyMomentumSectionWidget(),
                  const TopLearnersSectionWidget(),
                  if (dto.AppConfig.showQuickAccess)
                    const QuickAccessSectionWidget(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
