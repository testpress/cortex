import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../providers/doubt_providers.dart';
import '../widgets/forum_header.dart';
import 'ask_doubt_form_screen.dart';
import 'doubt_detail_screen.dart';

class DoubtsListScreen extends ConsumerWidget {
  const DoubtsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doubtsAsync = ref.watch(doubtsListProvider);
    final syncAsync = ref.watch(doubtsSyncProvider);
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppShell(
      backgroundColor: design.colors.surface,
      child: doubtsAsync.when(
        data: (doubts) {
          // Show skeleton only if initial sync is still loading AND database is empty
          final isInitialLoading = syncAsync.isLoading && doubts.isEmpty;

          return Column(
            children: [
              Container(
                color: design.colors.card,
                child: Column(
                  children: [
                    if (doubts.isEmpty && !isInitialLoading)
                      AppHeader(
                        title: l10n.drawerDoubts,
                        subtitle: l10n.doubtsEmptySubtitle,
                      )
                    else
                      ForumHeader(
                        title: l10n.drawerDoubts,
                        showDivider: false,
                        actions: [
                          GestureDetector(
                            onTap: () {
                              context.push('/home/discussions/doubts/ask');
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: design.spacing.sm),
                              child: AppText.labelSmall(
                                l10n.doubtsHeaderAskDoubt,
                                color: design.colors.accent2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    // Search bar integrated into the white header area
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.md,
                        vertical: design.spacing.sm,
                      ),
                      child: AppSearchBar(
                        hintText: l10n.doubtsSearchHint,
                        onChanged: (_) {},
                        backgroundColor: design.colors.surfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: design.colors.divider),
              Expanded(
                child: Skeletonizer(
                  enabled: isInitialLoading,
                  child: doubts.isEmpty && !isInitialLoading
                      ? _buildEmptyState(context, design, ref)
                      : _DoubtsBody(
                          doubts: isInitialLoading ? _dummyDoubts : doubts,
                        ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (err, stack) => Center(
          child: AppErrorView(
            message: 'Failed to load doubts',
            onRetry: () {
              ref.invalidate(doubtsListProvider);
              ref.invalidate(doubtsSyncProvider);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, DesignConfig design, WidgetRef ref) {
    final l10n = L10n.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.messageSquare,
            size: 80,
            color: design.colors.textTertiary.withValues(alpha: 0.2),
          ),
          SizedBox(height: design.spacing.lg),
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
          SizedBox(height: design.spacing.xl),
          AppButton.primary(
            label: l10n.doubtsHeaderAskDoubt,
            leading: const Icon(LucideIcons.plus, size: 20, color: Color(0xFFFFFFFF)),
            onPressed: () {
              context.push('/home/discussions/doubts/ask');
            },
          ),
        ],
      ),
    );
  }
}

final List<DoubtDto> _dummyDoubts = List.generate(
  5,
  (index) => DoubtDto(
    id: 'dummy_$index',
    title: 'Loading your doubts and queries',
    content: 'Loading content description placeholder text',
    studentName: 'Student Name',
    replyCount: 0,
    status: DoubtStatus.pending,
    createdAt: DateTime.now(),
    courseName: 'Course Name Placeholder',
    courseId: 'course_$index',
  ),
);

class _DoubtsBody extends StatelessWidget {
  final List<DoubtDto> doubts;

  const _DoubtsBody({required this.doubts});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppScroll(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      children: doubts
          .map((doubt) => Padding(
                padding: EdgeInsets.only(bottom: design.spacing.xs),
                child: _DoubtItem(doubt: doubt),
              ))
          .toList(),
    );
  }
}

class _DoubtItem extends StatelessWidget {
  final DoubtDto doubt;

  const _DoubtItem({required this.doubt});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppCard(
      onTap: () {
        context.push('/home/discussions/doubts/${doubt.id}');
      },
      padding: EdgeInsets.all(design.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title (Bold cardTitle)
          AppText.cardTitle(
            doubt.title,
            color: design.colors.textPrimary,
            maxLines: 2,
          ),
          SizedBox(height: design.spacing.sm),
          // Metadata Row: Subject • Replies • Time
          Row(
            children: [
              if (doubt.courseId != null) ...[
                AppText.labelSmall(
                  doubt.courseName ?? '',
                  color: design.colors.accent2,
                ),
                _buildDot(design),
              ],
              Icon(LucideIcons.messageCircle, size: 14, color: design.colors.textTertiary),
              SizedBox(width: design.spacing.xs),
              AppText.caption(
                l10n.doubtsReplyCount(doubt.replyCount),
                color: design.colors.textTertiary,
              ),
              _buildDot(design),
              AppText.caption(
                DateFormatter.formatTimeAgo(doubt.createdAt),
                color: design.colors.textTertiary,
              ),
            ],
          ),
          // Status Badge (Below metadata)
          if (doubt.status == DoubtStatus.pending) ...[
            SizedBox(height: design.spacing.sm),
            _buildUnansweredBadge(design, context),
          ],
        ],
      ),
    );
  }

  Widget _buildDot(DesignConfig design) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
      child: AppText.caption('•', color: design.colors.textTertiary),
    );
  }

  Widget _buildUnansweredBadge(DesignConfig design, BuildContext context) {
    final l10n = L10n.of(context);
    // Orange palette (atIndex 1) is more vibrant
    final colors = design.subjectPalette.atIndex(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: AppText.labelSmall(
        l10n.doubtsLabelUnanswered,
        color: colors.accent,
        style: const TextStyle(fontSize: 10, height: 1.1, fontWeight: FontWeight.w600),
      ),
    );
  }
}
