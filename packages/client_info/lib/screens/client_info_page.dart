import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';

import '../models/client_info_models.dart';
import '../providers/client_info_providers.dart';

class ClientInfoPage extends ConsumerWidget {
  const ClientInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final courses = ref.watch(clientInfoCoursesProvider);

    return ColoredBox(
      color: design.colors.canvas,
      child: Column(
        children: [
          const DashboardHeader(
            title: 'Learning Resources',
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              height: 1.15,
            ),
          ),
          Expanded(
            child: AppScroll(
              padding: EdgeInsets.fromLTRB(
                design.spacing.md,
                design.spacing.md,
                design.spacing.md,
                design.spacing.xxl,
              ),
              children: [
                for (final course in courses) ...[
                  _CourseCard(course: course),
                  SizedBox(height: design.spacing.sm),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});

  final ClientInfoCourse course;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final colors = subjectPaletteForClientInfo(context, course.subject);

    // Note: The route should ideally be independent of the profile slot
    return AppSemantics.button(
      label: 'Open ${course.title}',
      onTap: () => context.push('/info/course/${course.id}'),
      child: AppFocusable(
        onTap: () => context.push('/info/course/${course.id}'),
        borderRadius: BorderRadius.circular(design.radius.lg),
        child: Container(
          key: ValueKey('info-course-${course.id}'),
          padding: EdgeInsets.all(design.spacing.md),
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.circular(design.radius.lg),
            boxShadow: design.shadows.surfaceSoft,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoThumbnail(
                label: course.subject,
                imageUrl: course.thumbnailUrl,
                foregroundColor: colors.foreground,
              ),
              SizedBox(width: design.spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.body(
                      course.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: design.spacing.sm),
                    AppText.cardCaption(
                      course.instructor,
                      color: design.colors.textSecondary,
                    ),
                    SizedBox(height: design.spacing.sm),
                    Row(
                      children: [
                        _MetaText(
                          icon: LucideIcons.playCircle,
                          text: '${course.videoCount}',
                        ),
                        SizedBox(width: design.spacing.md),
                        _MetaText(
                          icon: LucideIcons.clock3,
                          text: course.totalDuration,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoThumbnail extends StatelessWidget {
  const InfoThumbnail({
    super.key,
    required this.label,
    required this.imageUrl,
    required this.foregroundColor,
  });

  final String label;
  final String imageUrl;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        color: design.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(design.radius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return ColoredBox(color: design.colors.surfaceVariant);
              },
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.all(design.spacing.xs),
              constraints: const BoxConstraints(minWidth: 44, maxWidth: 68),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: foregroundColor,
                borderRadius: BorderRadius.circular(design.radius.md),
              ),
              child: Text(
                label,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: design.colors.textInverse,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: design.colors.textSecondary),
        const SizedBox(width: 4),
        AppText.cardCaption(text, color: design.colors.textSecondary),
      ],
    );
  }
}

({Color background, Color foreground}) subjectPaletteForClientInfo(
  BuildContext context,
  String subject,
) {
  final design = Design.of(context);
  final index = subject.toLowerCase().hashCode.abs();
  final colors = design.subjectPalette.atIndex(index);

  return (
    background: colors.background,
    foreground: colors.foreground,
  );
}
