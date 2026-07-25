import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core.dart';
import '../data/data.dart';

class AiScreen extends ConsumerWidget {
  final VoidCallback onAskAiPressed;
  final VoidCallback onCreateCustomExamPressed;
  final VoidCallback onViewAllDoubtsPressed;
  final void Function(String doubtId) onDoubtTapped;

  const AiScreen({
    super.key,
    required this.onAskAiPressed,
    required this.onCreateCustomExamPressed,
    required this.onViewAllDoubtsPressed,
    required this.onDoubtTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final user = ref.watch(userProvider).valueOrNull;
    final userName = user?.name;

    return Container(
      color: design.colors.surface,
      child: Column(
        children: [
          AppHeader(
            title: l10n.aiSupportTitle,
            backgroundColor: design.colors.card,
          ),
          Expanded(
            child: AppScroll(
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.screenPadding,
                vertical: design.spacing.lg,
              ),
              children: [
                _buildGreeting(design, l10n, userName),
                SizedBox(height: design.spacing.xl),
                _buildQuickActions(context, design, l10n),
                SizedBox(height: design.spacing.xl),
                _buildRecentHelp(context, ref, design, l10n),
                SizedBox(height: design.spacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(
    DesignConfig design,
    AppLocalizations l10n,
    String? userName,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.sparkles,
              color: design.colors.accent1,
              size: design.iconSize.md,
            ),
            SizedBox(width: design.spacing.sm),
            AppText.headline(
              l10n.aiSupportGreeting(userName ?? ''),
              color: design.colors.textPrimary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    DesignConfig design,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.labelBold(
          l10n.aiSupportQuickActions,
          color: design.colors.textSecondary,
        ),
        SizedBox(height: design.spacing.md),

        _buildQuickActionCard(
          design: design,
          accentColor: design.colors.accent4,
          cardIcon: LucideIcons.messageCircle,
          title: l10n.aiSupportAskDoubtTitle,
          subtitle: l10n.aiSupportAskDoubtSubtitle,
          buttonLabel: l10n.aiSupportAskNowButton,
          buttonIcon: LucideIcons.send,
          onPressed: onAskAiPressed,
        ),
        SizedBox(height: design.spacing.md),

        _buildQuickActionCard(
          design: design,
          accentColor: design.colors.accent3,
          cardIcon: LucideIcons.fileText,
          title: l10n.aiSupportAiExamTitle,
          subtitle: l10n.aiSupportAiExamSubtitle,
          buttonLabel: l10n.aiSupportCreateAiExamButton,
          buttonIcon: LucideIcons.sparkles,
          onPressed: onCreateCustomExamPressed,
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required DesignConfig design,
    required Color accentColor,
    required IconData cardIcon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required IconData buttonIcon,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(design.spacing.lg),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(design.radius.xl),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(design.spacing.md),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(cardIcon, color: accentColor, size: design.iconSize.lg),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.cardTitle(title),
                SizedBox(height: design.spacing.xs),
                AppText.cardSubtitle(subtitle),
                SizedBox(height: design.spacing.md),
                AppButton(
                  label: buttonLabel,
                  backgroundColor: accentColor,
                  foregroundColor: design.colors.textInverse,
                  leading: Icon(buttonIcon, size: design.iconSize.sm),
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentHelp(
    BuildContext context,
    WidgetRef ref,
    DesignConfig design,
    AppLocalizations l10n,
  ) {
    final repoAsync = ref.watch(doubtRepositoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.labelBold(
              l10n.aiSupportRecentHelp,
              color: design.colors.textSecondary,
            ),
            AppSemantics.button(
              label: l10n.aiSupportViewAll,
              onTap: onViewAllDoubtsPressed,
              child: AppFocusable(
                onTap: onViewAllDoubtsPressed,
                child: AppText.labelSmall(
                  l10n.aiSupportViewAll,
                  color: design.colors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: design.spacing.md),
        repoAsync.when(
          data: (repo) => StreamBuilder<List<DoubtDto>>(
            stream: repo.watchDoubts(queryType: DoubtQueryType.ai),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: AppLoadingIndicator());
              }
              final doubts = snapshot.data!.take(3).toList();
              if (doubts.isEmpty) {
                return AppCard(
                  padding: EdgeInsets.all(design.spacing.lg),
                  child: Center(
                    child: AppText.body(l10n.aiSupportNoRecentDoubts),
                  ),
                );
              }

              return Column(
                children: doubts.map((doubt) {
                  IconData statusIcon;
                  Color statusColor;
                  Color statusBg;
                  String statusText;

                  switch (doubt.status) {
                    case DoubtStatus.resolved:
                    case DoubtStatus.closed:
                      statusIcon = LucideIcons.checkCircle2;
                      statusColor = design.statusColors.completed.foreground;
                      statusBg = design.statusColors.completed.background;
                      statusText = l10n.aiSupportStatusAnswered;
                      break;
                    case DoubtStatus.active:
                    case DoubtStatus.pending:
                      statusIcon = LucideIcons.loader;
                      statusColor = design.statusColors.upcoming.foreground;
                      statusBg = design.statusColors.upcoming.background;
                      statusText = l10n.aiSupportStatusProcessing;
                      break;
                  }

                  return Padding(
                    padding: EdgeInsets.only(bottom: design.spacing.md),
                    child: AppSemantics.button(
                      label: doubt.title,
                      onTap: () => onDoubtTapped(doubt.id),
                      child: AppFocusable(
                        onTap: () => onDoubtTapped(doubt.id),
                        child: _buildHelpCard(
                          design: design,
                          icon: LucideIcons.messageCircleQuestionMark,
                          iconColor: design.colors.accent2,
                          title: doubt.title,
                          timestamp: doubt.createdHumanized ?? '',
                          statusText: statusText,
                          statusColor: statusColor,
                          statusBg: statusBg,
                          statusIcon: statusIcon,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (_, _) => const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildHelpCard({
    required DesignConfig design,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String timestamp,
    required String statusText,
    required Color statusColor,
    required Color statusBg,
    required IconData statusIcon,
  }) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(design.spacing.sm),
            decoration: BoxDecoration(
              color: design.colors.surface,
              borderRadius: BorderRadius.circular(design.radius.md),
            ),
            child: Icon(icon, color: iconColor, size: design.iconSize.md),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppText.body(
                        title,
                        color: design.colors.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: design.spacing.sm),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.sm,
                        vertical: design.spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(design.radius.full),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            size: design.iconSize.xs,
                            color: statusColor,
                          ),
                          SizedBox(width: 4),
                          AppText.labelSmall(statusText, color: statusColor),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: design.spacing.sm),
                Row(
                  children: [
                    Icon(
                      LucideIcons.clock,
                      size: design.iconSize.xs,
                      color: design.colors.textTertiary,
                    ),
                    SizedBox(width: 4),
                    AppText.caption(
                      timestamp,
                      color: design.colors.textTertiary,
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
}
