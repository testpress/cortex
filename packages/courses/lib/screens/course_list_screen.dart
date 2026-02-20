import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import '../widgets/course_card.dart';

/// Course library screen displaying available courses.
///
/// Reads from [courseListProvider] via Riverpod. Data flows:
///   MockDataSource → Drift DB → courseListProvider stream → UI
class CourseListScreen extends ConsumerWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final coursesAsync = ref.watch(courseListProvider);

    return AppShell(
      child: Column(
        children: [
          AppHeader(
            title: L10n.of(context).courseLibraryTitle,
            subtitle: L10n.of(context).courseLibrarySubtitle,
          ),

          // --- PRIMITIVES PLAYGROUND ---
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSearchBar(hintText: 'Search courses...'),
                SizedBox(height: design.spacing.md),
                Row(
                  children: [
                    AppBadge(
                      label: "Live",
                      semanticStatus: design.statusColors.live,
                    ),
                    SizedBox(width: design.spacing.sm),
                    const AppBadge(
                      label: "New",
                      backgroundColor: Color(0xFF10B981), // Emerald
                      foregroundColor: Color(0xFFFFFFFF),
                      isPill: true,
                    ),
                    SizedBox(width: design.spacing.sm),
                    const AppBadge(
                      label: "Monthly Champ",
                      icon: LucideIcons.star,
                      backgroundColor: Color(0xFFFEF3C7), // Amber 50
                      foregroundColor: Color(0xFFB45309), // Amber 700
                      isPill: true,
                    ),
                  ],
                ),
                SizedBox(height: design.spacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AppSubjectChip(
                        label: 'Mathematics',
                        subjectPaletteIndex: 0,
                        isActive: true,
                        onTap: () {},
                      ),
                      SizedBox(width: design.spacing.sm),
                      AppSubjectChip(
                        label: 'Physics',
                        subjectPaletteIndex: 1,
                        isActive: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: design.spacing.md),
              ],
            ),
          ),

          // -----------------------------
          Expanded(
            child: coursesAsync.when(
              loading: () => const Center(child: _LoadingState()),
              error: (err, _) => _ErrorState(
                message: err.toString(),
                onRetry: () => ref.refresh(courseListProvider),
              ),
              data: (courses) => courses.isEmpty
                  ? const _EmptyState()
                  : AppScroll(
                      children: [
                        for (final course in courses)
                          Padding(
                            padding: EdgeInsets.only(bottom: design.spacing.md),
                            child: CourseCard(course: course),
                          ),
                      ],
                    ),
            ),
          ),

          // --- TAB BAR ---
          AppTabBar(
            activeItemId: 'study',
            items: const [
              AppTabItem(id: 'home', label: 'Home', icon: LucideIcons.home),
              AppTabItem(
                id: 'study',
                label: 'Study',
                icon: LucideIcons.bookOpen,
              ),
              AppTabItem(
                id: 'explore',
                label: 'Explore',
                icon: LucideIcons.compass,
              ),
              AppTabItem(
                id: 'profile',
                label: 'Profile',
                icon: LucideIcons.user,
              ),
            ],
            onTabChange: (id) {},
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// State widgets
// ───────────────────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.all(design.spacing.xl),
      child: AppText.body(
        'Loading courses…',
        color: design.colors.textSecondary,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.all(design.spacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.body(
            'Failed to load courses.',
            color: design.colors.textPrimary,
          ),
          SizedBox(height: design.spacing.sm),
          AppText.bodySmall(message, color: design.colors.textSecondary),
          SizedBox(height: design.spacing.md),
          AppButton.secondary(label: 'Retry', onPressed: onRetry),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Center(
      child: AppText.body(
        'No courses available.',
        color: design.colors.textSecondary,
      ),
    );
  }
}
