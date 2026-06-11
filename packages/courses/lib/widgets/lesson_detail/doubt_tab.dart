import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../models/course_content.dart';
import 'ask_doubt_fab.dart';

class DoubtTab extends ConsumerWidget {
  final Lesson lesson;
  final WidgetBuilder? footerBuilder;

  const DoubtTab({super.key, required this.lesson, this.footerBuilder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonId = int.tryParse(lesson.id) ?? 0;
    final doubtsAsync = ref.watch(lessonDoubtsProvider(lessonId));
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Stack(
      children: [
        doubtsAsync.when(
          data: (doubts) {
            if (doubts.isEmpty) {
              return _buildScrollable(
                context: context,
                child: _buildEmptyState(context, design, l10n),
                design: design,
              );
            }
            return CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(design.spacing.md),
                  sliver: SliverList.separated(
                    itemCount: doubts.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: design.spacing.sm),
                    itemBuilder: (context, index) {
                      return _DoubtItemCard(doubt: doubts[index]);
                    },
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: false,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (footerBuilder != null) footerBuilder!(context),
                        SizedBox(height: design.spacing.sm),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(design.spacing.md),
                sliver: SliverList.separated(
                  itemCount: 2,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: design.spacing.sm),
                  itemBuilder: (context, index) {
                    return Skeletonizer(
                      enabled: true,
                      child: _DoubtItemCard(
                        doubt: DoubtDto(
                          id: 'dummy',
                          title: 'Loading your doubts',
                          content: 'Loading content',
                          studentName: 'Student Name',
                          status: DoubtStatus.pending,
                          createdAt: DateTime.now(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (footerBuilder != null) footerBuilder!(context),
                      SizedBox(height: design.spacing.sm),
                    ],
                  ),
                ),
              ),
            ],
          ),
          error: (err, stack) => _buildScrollable(
            context: context,
            child: Center(
              child: AppErrorView(
                message: l10n.errorGenericMessage,
                onRetry: () => ref.invalidate(lessonDoubtsProvider(lessonId)),
              ),
            ),
            design: design,
          ),
        ),
        Positioned(
          bottom: 96,
          right: design.spacing.md,
          child: AskDoubtFab(
            onTap: () {
              final uri = Uri(
                path: '/home/discussions/doubts/ask',
                queryParameters: {
                  'chapterContentId': lesson.id,
                  'lessonTitle': lesson.title,
                  'lessonType': lesson.type.name,
                },
              );
              context.push(uri.toString());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScrollable({
    required BuildContext context,
    required Widget child,
    required DesignConfig design,
  }) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          fillOverscroll: false,
          child: Column(
            children: [
              Expanded(child: child),
              if (footerBuilder != null) footerBuilder!(context),
              SizedBox(height: design.spacing.sm),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    DesignConfig design,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.messageSquare,
            size: 64,
            color: design.colors.textTertiary.withValues(alpha: 0.2),
          ),
          SizedBox(height: design.spacing.md),
          AppText.headline(
            l10n.doubtsEmptyTitle,
            color: design.colors.textSecondary,
          ),
          SizedBox(height: design.spacing.xs),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.xl),
            child: AppText.body(
              l10n.doubtsEmptySubtitle,
              color: design.colors.textTertiary,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoubtItemCard extends StatelessWidget {
  final DoubtDto doubt;

  const _DoubtItemCard({required this.doubt});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppCard(
      onTap: () {
        context.push('/home/discussions/doubts/${doubt.id}');
      },
      padding: EdgeInsets.all(design.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.cardTitle(
            doubt.title,
            color: design.colors.textPrimary,
            maxLines: 2,
          ),
          SizedBox(height: design.spacing.sm),
          Row(
            children: [
              if (doubt.topicName != null) ...[
                AppText.labelSmall(
                  doubt.topicName!,
                  color: design.colors.accent2,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
                  child:
                      AppText.caption('•', color: design.colors.textTertiary),
                ),
              ],
              AppText.caption(
                doubt.createdHumanized ??
                    DateFormatter.formatTimeAgo(doubt.createdAt),
                color: design.colors.textTertiary,
              ),
            ],
          ),
          SizedBox(height: design.spacing.sm),
          _buildStatusBadge(design, doubt.status),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(DesignConfig design, DoubtStatus status) {
    final Color color;
    switch (status) {
      case DoubtStatus.active:
        color = design.colors.accent2;
        break;
      case DoubtStatus.resolved:
        color = design.colors.success;
        break;
      case DoubtStatus.pending:
        color = design.colors.warning;
        break;
      case DoubtStatus.closed:
        color = design.colors.error;
        break;
    }
    final label = '${status.name[0].toUpperCase()}${status.name.substring(1)}';

    return Skeleton.leaf(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: AppText.labelSmall(
          label,
          color: color,
          style: const TextStyle(
            fontSize: 10,
            height: 1.1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
