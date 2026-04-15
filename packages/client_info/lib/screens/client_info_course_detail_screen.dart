import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';

import '../models/client_info_models.dart';
import '../providers/client_info_providers.dart';

class ClientInfoCourseDetailScreen extends ConsumerStatefulWidget {
  const ClientInfoCourseDetailScreen({
    super.key,
    required this.courseId,
    required this.onBack,
  });

  final String courseId;
  final VoidCallback onBack;

  @override
  ConsumerState<ClientInfoCourseDetailScreen> createState() =>
      _ClientInfoCourseDetailScreenState();
}

class _ClientInfoCourseDetailScreenState
    extends ConsumerState<ClientInfoCourseDetailScreen> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final course = ref.watch(clientInfoCourseByIdProvider(widget.courseId));

    if (course == null) {
      return AppErrorView(
        title: 'Course unavailable',
        message: 'The requested learning resource could not be found.',
        onRetry: widget.onBack,
      );
    }

    return ColoredBox(
      color: design.colors.canvas,
      child: Column(
        children: [
          _DetailHeader(
            onBack: widget.onBack,
            title: course.title,
            instructor: course.instructor,
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
                if (errorMessage != null) ...[
                  SizedBox(height: design.spacing.sm),
                  Container(
                    padding: EdgeInsets.all(design.spacing.md),
                    decoration: BoxDecoration(
                      color: design.colors.error.withValues(alpha: 0.08),
                      borderRadius: design.radius.card,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          LucideIcons.alertCircle,
                          size: design.iconSize.md,
                          color: design.colors.error,
                        ),
                        SizedBox(width: design.spacing.sm),
                        Expanded(
                          child: AppText.body(
                            errorMessage!,
                            color: design.colors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                for (final video in course.videos) ...[
                  _VideoRow(
                    course: course,
                    video: video,
                    onTap: () => _openVideo(video),
                  ),
                  SizedBox(height: design.spacing.sm),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openVideo(ClientInfoVideo video) async {
    final launcher = ref.read(clientInfoLauncherProvider);
    final uri = Uri.tryParse(video.url);

    if (uri == null) {
      setState(() {
        errorMessage = 'This video link is invalid. Please try again later.';
      });
      return;
    }

    final didLaunch = await launcher(uri);
    if (!mounted) return;

    setState(() {
      errorMessage = didLaunch
          ? null
          : 'Unable to open this video right now. Please try again later.';
    });
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
    required this.onBack,
    required this.title,
    required this.instructor,
  });

  final VoidCallback onBack;
  final String title;
  final String instructor;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final padding = MediaQuery.of(context).padding;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, padding.top + 12, 16, 12),
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(
          bottom: BorderSide(color: design.colors.border, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSemantics.button(
            label: 'Back',
            onTap: onBack,
            child: AppFocusable(
              onTap: onBack,
              borderRadius: design.radius.button,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.chevronLeft,
                    size: 18,
                    color: design.colors.textPrimary,
                  ),
                  const SizedBox(width: 8),
                  AppText.label('Back', style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ),
          SizedBox(height: design.spacing.md),
          AppText.body(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          AppText.body(instructor, color: design.colors.textSecondary),
        ],
      ),
    );
  }
}

class _VideoRow extends StatelessWidget {
  const _VideoRow({
    required this.course,
    required this.video,
    required this.onTap,
  });

  final ClientInfoCourse course;
  final ClientInfoVideo video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppSemantics.button(
      label: 'Open ${video.title} externally',
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(design.radius.lg),
        child: Container(
          key: ValueKey('info-video-${video.id}'),
          padding: EdgeInsets.all(design.spacing.md),
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.circular(design.radius.lg),
            boxShadow: design.shadows.surfaceSoft,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _VideoThumbnail(
                imageUrl: course.thumbnailUrl,
                duration: video.duration,
              ),
              SizedBox(width: design.spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.body(
                      video.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.externalLink,
                          size: 12,
                          color: design.colors.primary,
                        ),
                        const SizedBox(width: 4),
                        AppText.cardCaption(
                          video.duration,
                          color: design.colors.primary,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
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

class _VideoThumbnail extends StatelessWidget {
  const _VideoThumbnail({required this.imageUrl, required this.duration});

  final String imageUrl;
  final String duration;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      width: 102,
      height: 74,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: design.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return ColoredBox(color: design.colors.surfaceVariant);
            },
          ),
          Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: design.colors.card,
                shape: BoxShape.circle,
                border: Border.all(color: design.colors.border, width: 1),
              ),
              child: Center(
                child: Icon(
                  LucideIcons.play,
                  size: 16,
                  color: design.colors.textPrimary,
                ),
              ),
            ),
          ),
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: design.colors.overlay,
                borderRadius: BorderRadius.circular(6),
              ),
              child: AppText.labelSmall(
                duration,
                color: design.colors.textInverse,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
