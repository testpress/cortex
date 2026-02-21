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

    return Column(
      children: [
        AppHeader(
          title: L10n.of(context).courseLibraryTitle,
          subtitle: L10n.of(context).courseLibrarySubtitle,
        ),
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
      ],
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
