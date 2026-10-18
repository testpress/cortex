import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'custom_video_player.dart';
import 'fermion_lobby_view.dart';
import 'comments_tab.dart';
import '../../providers/course_list_provider.dart';

/// Viewer for live stream content.
///
/// Branches on [LessonDto.liveStreamProvider]:
/// - **Scheduled**: renders [ScheduledMessageView] with a 5-second polling timer.
/// - **Fermion**: renders a lobby screen ([FermionLobbyView]).
/// - **TpStreams / null**: renders the existing inline [CustomVideoPlayer].
class LiveStreamViewer extends ConsumerStatefulWidget {
  const LiveStreamViewer({
    super.key,
    required this.lesson,
    this.onComplete,
    this.footerBuilder,
  });

  final LessonDto lesson;
  final VoidCallback? onComplete;
  final WidgetBuilder? footerBuilder;

  @override
  ConsumerState<LiveStreamViewer> createState() => _LiveStreamViewerState();
}

class _LiveStreamViewerState extends ConsumerState<LiveStreamViewer> {
  Timer? _refreshTimer;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkAndScheduleRefresh();
  }

  @override
  void didUpdateWidget(covariant LiveStreamViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson.isScheduled != widget.lesson.isScheduled ||
        oldWidget.lesson.id != widget.lesson.id) {
      _checkAndScheduleRefresh();
    }
  }

  void _checkAndScheduleRefresh() {
    _refreshTimer?.cancel();
    if (widget.lesson.isScheduled) {
      _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        _triggerRefresh();
      });
    }
  }

  Future<void> _triggerRefresh() async {
    try {
      final repository = await ref.read(courseRepositoryProvider.future);
      await repository.refreshLesson(widget.lesson.id);
    } catch (_) {
      // Ignore network errors during background status polling
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  bool get _isFermion => widget.lesson.isFermion;

  Widget _buildTab(BuildContext context, String label, int index) {
    final design = Design.of(context);
    final isSelected = _selectedTabIndex == index;
    return AppSemantics.button(
      label: label,
      onTap: () => setState(() => _selectedTabIndex = index),
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: design.spacing.sm),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? design.colors.primary
                    : design.colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: AppText.body(
              label,
              color: isSelected
                  ? design.colors.primary
                  : design.colors.textSecondary,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final design = Design.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(
          bottom: BorderSide(
            color: design.colors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTab(context, 'Live Chat', 0)),
          Expanded(child: _buildTab(context, 'Comments', 1)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final footerBuilder = widget.footerBuilder;

    if (lesson.isScheduled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ScheduledMessageView(message: lesson.scheduledMessage),
          ),
          if (footerBuilder != null) footerBuilder(context),
        ],
      );
    }

    if (_isFermion) {
      return FermionLobbyView(
        lesson: lesson,
        footerBuilder: footerBuilder,
      );
    }

    // TpStreams / null provider — inline video player
    final chatEmbedUrl = lesson.chatEmbedUrl?.trim();
    final hasChat = chatEmbedUrl != null && chatEmbedUrl.isNotEmpty;
    final hasComments =
        lesson.commentsUrl != null && lesson.commentsUrl!.trim().isNotEmpty;

    String? themedChatUrl;
    if (hasChat) {
      final isDarkMode = Design.of(context).isDark;
      final uri = Uri.tryParse(chatEmbedUrl);
      if (uri != null) {
        final queryParams = Map<String, String>.from(uri.queryParameters);
        queryParams['theme'] = isDarkMode ? 'dark' : 'light';
        if (isDarkMode &&
            (uri.host.contains('youtube.com') ||
                uri.host.contains('youtu.be'))) {
          queryParams['dark_theme'] = '1';
        }
        themedChatUrl = uri.replace(queryParameters: queryParams).toString();
      } else {
        // Fall back to raw URL if parsing fails (handled safely by AppWebView)
        themedChatUrl = chatEmbedUrl;
      }
    }

    final Widget playerWidget = AspectRatio(
      aspectRatio: 16 / 9,
      child: CustomVideoPlayer(
        assetId: lesson.uuid,
      ),
    );

    final Widget chatWidget = hasChat
        ? AppWebView(
            key: ValueKey('live_chat_webview_${lesson.id}'),
            url: themedChatUrl!,
            showHeader: false,
            useSafeArea: false,
          )
        : const ColoredBox(color: Color(0xFF000000));

    final Widget commentsWidget = hasComments
        ? CommentsTab(
            commentsUrl: lesson.commentsUrl!,
            lesson: lesson,
          )
        : const SizedBox.shrink();

    if (hasChat && hasComments) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          playerWidget,
          _buildTabBar(context),
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: [
                chatWidget,
                commentsWidget,
              ],
            ),
          ),
          if (footerBuilder != null) footerBuilder(context),
        ],
      );
    }

    if (hasComments && !hasChat) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          playerWidget,
          Expanded(child: commentsWidget),
          if (footerBuilder != null) footerBuilder(context),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        playerWidget,
        Expanded(child: chatWidget),
        if (footerBuilder != null) footerBuilder(context),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared scheduled-state view (used by both providers)
// ---------------------------------------------------------------------------

class ScheduledMessageView extends StatelessWidget {
  const ScheduledMessageView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF000000),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.calendarClock,
              color: Design.of(context).colors.primary,
              size: 48,
            ),
            if (message != null) ...[
              const SizedBox(height: 24),
              AppText.body(
                message!,
                color: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
