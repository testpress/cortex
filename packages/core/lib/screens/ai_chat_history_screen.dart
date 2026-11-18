import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../core.dart';
import '../data/models/ai_chat_history_section.dart';

/// Conversation history, presented as a start-side drawer over a dimmed chat.
///
/// Expects to be shown on a non-opaque route so the chat stays visible behind
/// the scrim; the drawer animates itself from the route animation.
class AiChatHistoryScreen extends ConsumerStatefulWidget {
  const AiChatHistoryScreen({super.key});

  @override
  ConsumerState<AiChatHistoryScreen> createState() =>
      _AiChatHistoryScreenState();
}

class _AiChatHistoryScreenState extends ConsumerState<AiChatHistoryScreen> {
  /// Share of the screen the drawer may cover on narrow phones.
  static const double _maxWidthFactor = 0.85;

  /// Distance in pixels from the bottom of the list at which the next page is fetched.
  static const double _paginationScrollThreshold = 200.0;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(genericAiChatProvider.notifier).loadConversations(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0 || position.pixels <= 0) return;

    if (position.pixels >=
        position.maxScrollExtent - _paginationScrollThreshold) {
      final state = ref.read(genericAiChatProvider);
      if (!state.isLoadingHistory && state.hasMoreHistory) {
        ref.read(genericAiChatProvider.notifier).loadConversations();
      }
    }
  }

  void _dismiss() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/ai');
    }
  }

  void _startNewChat() {
    ref.read(genericAiChatProvider.notifier).startNewChat();
    _dismiss();
  }

  void _openConversation(String chatId) {
    ref.read(genericAiChatProvider.notifier).selectConversation(chatId);
    _dismiss();
  }

  Future<void> _showConversationOptions(
    String chatId,
    String title,
    LayerLink layerLink,
  ) async {
    final action = await _showConversationOptionsMenu(
      context,
      layerLink: layerLink,
    );
    if (!mounted || action == null) return;

    switch (action) {
      case _ConversationAction.delete:
        await _deleteConversation(chatId, title: title);
    }
  }

  Future<void> _deleteConversation(String chatId, {String? title}) async {
    final isCurrentActive =
        ref.read(genericAiChatProvider).currentChatId == chatId;
    final success = await confirmAndDeleteConversation(
      context: context,
      ref: ref,
      chatId: chatId,
      title: title,
    );

    if (!mounted) return;
    if (success && isCurrentActive) {
      _dismiss();
    }
  }

  String _resolveSectionTitle(
    BuildContext context,
    AiChatHistorySection section,
    DateTime now,
  ) {
    final l10n = L10n.of(context);
    switch (section.type) {
      case HistorySectionType.today:
        return l10n.aiHistoryToday;
      case HistorySectionType.yesterday:
        return l10n.aiHistoryYesterday;
      case HistorySectionType.previous7Days:
        return l10n.aiHistoryPrevious7Days;
      case HistorySectionType.monthYear:
        final date = DateTime(section.year ?? now.year, section.month ?? 1);
        final locale = Localizations.localeOf(context).toString();
        if (section.year == now.year) {
          return DateFormat.MMMM(locale).format(date);
        } else {
          return DateFormat.yMMMM(locale).format(date);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isNewChatActive = ref.watch(
      genericAiChatProvider.select((s) => s.currentChatId == null),
    );

    final routeAnimation = ModalRoute.of(context)?.animation;
    final animation =
        routeAnimation != null && MotionPreferences.shouldAnimate(context)
        ? routeAnimation
        : kAlwaysCompleteAnimation;
    final slide = animation.drive(
      Tween<Offset>(
        begin: Offset(isRtl ? 1.0 : -1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: design.motion.easeOut)),
    );

    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxDrawerWidth = screenWidth * _maxWidthFactor;
    final drawerWidth = design.layout.drawerWidth > maxDrawerWidth
        ? maxDrawerWidth
        : design.layout.drawerWidth;

    return Stack(
      children: [
        Positioned.fill(
          child: AppSemantics.button(
            label: l10n.labelClose,
            onTap: _dismiss,
            child: GestureDetector(
              onTap: _dismiss,
              behavior: HitTestBehavior.opaque,
              child: FadeTransition(
                opacity: animation,
                child: ColoredBox(color: design.colors.overlay),
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SlideTransition(
            position: slide,
            child: Container(
              key: const ValueKey('ai_chat_history_drawer'),
              width: drawerWidth,
              height: double.infinity,
              color: design.colors.card,
              child: SafeArea(
                left: !isRtl,
                right: isRtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: design.spacing.md,
                        end: design.spacing.sm,
                        top: design.spacing.sm,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppSemantics.header(
                              label: l10n.aiChatHistoryTitle,
                              child: ExcludeSemantics(
                                child: AppText.title(
                                  l10n.aiChatHistoryTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          AppIconButton(
                            icon: LucideIcons.x,
                            size: design.iconSize.md,
                            color: design.colors.onSurfaceVariant,
                            accessibilityLabel: l10n.labelClose,
                            onTap: _dismiss,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.sm,
                        vertical: design.spacing.xs,
                      ),
                      child: _NewChatButton(
                        onTap: _startNewChat,
                        isActive: isNewChatActive,
                      ),
                    ),
                    Container(height: 1.0, color: design.colors.border),
                    Expanded(child: _buildBody(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final chatState = ref.watch(genericAiChatProvider);
    final history = chatState.conversationHistory;

    if (chatState.hasHistoryError && history.isEmpty) {
      return Center(
        child: AppErrorView(
          error: chatState.historyError,
          backgroundColor: design.colors.card,
          padding: EdgeInsets.all(design.spacing.md),
          onRetry: () => ref
              .read(genericAiChatProvider.notifier)
              .loadConversations(refresh: true),
        ),
      );
    }

    if (chatState.isLoadingHistory && history.isEmpty) {
      return const Center(child: AppLoadingIndicator());
    }

    if (history.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(design.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.history,
                size: 40.0,
                color: design.colors.textTertiary,
              ),
              SizedBox(height: design.spacing.md),
              AppText.bodySmall(
                l10n.aiNoChatHistory,
                color: design.colors.textSecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final now = DateTime.now();
    final sections = buildHistorySections(conversations: history, now: now);

    return AppSemantics.scrollableList(
      itemCount: history.length,
      label: l10n.aiChatHistoryTitle,
      child: AppScroll(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.xs,
          vertical: design.spacing.xs,
        ),
        children: [
          for (final section in sections) ...[
            _SectionHeader(title: _resolveSectionTitle(context, section, now)),
            for (final session in section.items)
              _HistoryItem(
                title: session.title.trim().isNotEmpty
                    ? session.title
                    : l10n.aiNewChatHeader,
                isActive: chatState.currentChatId == session.chatId,
                onTap: () => _openConversation(session.chatId),
                onOptions: chatState.isDeletingConversation
                    ? null
                    : (layerLink) => _showConversationOptions(
                        session.chatId,
                        session.title.trim().isNotEmpty
                            ? session.title
                            : l10n.aiNewChatHeader,
                        layerLink,
                      ),
                isDeleting: chatState.isDeletingConversation,
              ),
          ],
          if (chatState.isLoadingHistory)
            Padding(
              padding: EdgeInsets.all(design.spacing.md),
              child: const Center(child: AppLoadingIndicator()),
            ),
          if (chatState.hasHistoryError)
            Padding(
              padding: EdgeInsets.all(design.spacing.md),
              child: Center(
                child: AppButton.secondary(
                  label: l10n.labelRetry,
                  onPressed: () => ref
                      .read(genericAiChatProvider.notifier)
                      .loadConversations(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        design.spacing.md - design.spacing.xs,
        design.spacing.md * 1.25,
        design.spacing.sm,
        design.spacing.xs,
      ),
      child: AppSemantics.header(
        label: title,
        child: ExcludeSemantics(
          child: AppText.subtitle(title, color: design.colors.textSecondary),
        ),
      ),
    );
  }
}

class _NewChatButton extends StatelessWidget {
  const _NewChatButton({required this.onTap, this.isActive = false});

  final VoidCallback onTap;
  final bool isActive;

  static const double _indicatorWidth = 3.5;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final contentColor = design.colors.textPrimary;

    return AppSemantics.button(
      label: l10n.aiStartNewChat,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48.0),
          child: Center(
            heightFactor: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(design.radius.sm),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 48.0),
                decoration: BoxDecoration(
                  color: isActive
                      ? design.colors.surfaceVariant
                      : design.colors.transparent,
                  borderRadius: BorderRadius.circular(design.radius.sm),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.sm,
                        vertical: design.spacing.sm * 1.5,
                      ),
                      child: ExcludeSemantics(
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.squarePen,
                              size: design.iconSize.md,
                              color: contentColor,
                            ),
                            SizedBox(width: design.spacing.sm * 1.5),
                            Flexible(
                              child: AppText.body(
                                l10n.aiNewChatHeader,
                                color: contentColor,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isActive)
                      PositionedDirectional(
                        start: 0,
                        top: 0,
                        bottom: 0,
                        width: _indicatorWidth,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: design.colors.textPrimary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(design.radius.sm),
                              bottomLeft: Radius.circular(design.radius.sm),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _ConversationAction { delete }

class _ConversationOptionsPopup extends StatelessWidget {
  const _ConversationOptionsPopup({required this.onDelete});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.circular(design.radius.md),
          border: Border.all(
            color: design.colors.border.withValues(
              alpha: design.isDark ? 0.6 : 0.8,
            ),
          ),
          boxShadow: design.shadows.floating,
        ),
        padding: EdgeInsets.all(design.spacing.xs * 0.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSemantics.button(
              label: l10n.aiDeleteConversationAction,
              onTap: onDelete,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onDelete,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 48.0,
                    minHeight: 48.0,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.sm,
                    vertical: design.spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(design.radius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.trash2,
                        size: design.iconSize.sm,
                        color: design.colors.error,
                      ),
                      SizedBox(width: design.spacing.sm),
                      AppText.bodySmall(
                        l10n.aiDeleteConversationAction,
                        color: design.colors.error,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<_ConversationAction?> _showConversationOptionsMenu(
  BuildContext context, {
  required LayerLink layerLink,
}) {
  final design = Design.of(context);
  final l10n = L10n.of(context);

  return showGeneralDialog<_ConversationAction>(
    context: context,
    barrierDismissible: true,
    barrierLabel: l10n.labelClose,
    barrierColor: design.colors.transparent,
    transitionDuration: Duration.zero,
    pageBuilder: (dialogContext, anim1, anim2) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(dialogContext).pop(),
            ),
          ),
          CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topRight,
            offset: Offset(0, design.spacing.xs),
            child: _ConversationOptionsPopup(
              onDelete: () =>
                  Navigator.of(dialogContext).pop(_ConversationAction.delete),
            ),
          ),
        ],
      );
    },
  );
}

typedef _OptionsCallback = void Function(LayerLink layerLink);

class _HistoryItem extends StatefulWidget {
  const _HistoryItem({
    required this.title,
    required this.onTap,
    this.onOptions,
    this.isActive = false,
    this.isDeleting = false,
  });

  final String title;
  final VoidCallback onTap;
  final _OptionsCallback? onOptions;
  final bool isActive;
  final bool isDeleting;

  @override
  State<_HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<_HistoryItem> {
  final LayerLink _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: design.spacing.xs),
      decoration: BoxDecoration(
        color: widget.isActive
            ? design.colors.surfaceVariant
            : design.colors.transparent,
        borderRadius: BorderRadius.circular(design.radius.sm),
      ),
      constraints: const BoxConstraints(minHeight: 48.0),
      padding: EdgeInsetsDirectional.only(
        start: design.spacing.sm,
        end: design.spacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppSemantics.button(
              label: l10n.openChatSession(widget.title),
              onTap: widget.onTap,
              child: GestureDetector(
                onTap: widget.onTap,
                behavior: HitTestBehavior.opaque,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: design.spacing.xs * 1.5,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: AppText.bodySmall(
                        widget.title,
                        color: design.colors.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.onOptions != null || widget.isDeleting)
            AppSemantics.button(
              label: l10n.aiMoreActionsSemantic(widget.title),
              onTap: widget.isDeleting
                  ? null
                  : () => widget.onOptions?.call(_layerLink),
              child: GestureDetector(
                onTap: widget.isDeleting
                    ? null
                    : () => widget.onOptions?.call(_layerLink),
                behavior: HitTestBehavior.opaque,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 48.0,
                    minHeight: 48.0,
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: widget.isDeleting ? 0.35 : 1.0,
                      child: CompositedTransformTarget(
                        link: _layerLink,
                        child: Icon(
                          LucideIcons.moreVertical,
                          size: design.iconSize.sm,
                          color: design.colors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
