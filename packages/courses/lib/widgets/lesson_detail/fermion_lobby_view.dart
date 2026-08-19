import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../providers/lesson_detail_provider.dart';

/// Lobby screen for Fermion live sessions.
///
/// Displays session metadata (Duration and Start Time) in a clean card layout,
/// along with an action button to join the session or watch the recording.
class FermionLobbyView extends ConsumerWidget {
  const FermionLobbyView({
    super.key,
    required this.lesson,
    this.footerBuilder,
  });

  final LessonDto lesson;
  final WidgetBuilder? footerBuilder;

  void _openWebView(BuildContext context, WidgetRef ref) async {
    final url = lesson.contentUrl;
    if (url == null || url.isEmpty) return;
    await Navigator.of(context).push(
      AppRoute(
        page: AppWebView(
          url: url,
          permissions: const [Permission.camera, Permission.microphone],
          mediaMode: true,
        ),
      ),
    );
    if (context.mounted) {
      ref.invalidate(lessonDetailProvider(lesson.id));
    }
  }

  _LobbyViewState get _viewState {
    if (lesson.isStreamRunning) {
      return _LobbyViewState.running;
    }
    if (lesson.isStreamCompleted && lesson.showRecordedVideo) {
      return _LobbyViewState.completedWithRecording;
    }
    return _LobbyViewState.completedNoRecording;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final state = _viewState;

    final formattedDuration =
        TimeFormatter.formatDurationToMinutes(lesson.duration);
    final formattedStart = DateFormatter.formatStartDateTime(lesson.start);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ColoredBox(
            color: design.colors.canvas,
            child: Padding(
              padding: EdgeInsets.all(design.spacing.screenPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildMetadataCard(
                    context,
                    ref,
                    design,
                    state,
                    formattedDuration,
                    formattedStart,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (footerBuilder != null) footerBuilder!(context),
      ],
    );
  }

  Widget _buildMetadataCard(
    BuildContext context,
    WidgetRef ref,
    DesignConfig design,
    _LobbyViewState state,
    String? formattedDuration,
    String? formattedStart,
  ) {
    if (formattedDuration == null && formattedStart == null) {
      return const SizedBox.shrink();
    }

    final semanticParts = <String>[];
    if (formattedDuration != null) {
      semanticParts.add('Duration: $formattedDuration');
    }
    if (formattedStart != null) {
      semanticParts.add('Start Time: $formattedStart');
    }
    if (state == _LobbyViewState.completedNoRecording) {
      semanticParts.add(
        '${L10n.of(context).liveStreamNoRecordingTitle}: ${L10n.of(context).liveStreamNoRecordingMessage}',
      );
    }
    final semanticLabel = 'Session details: ${semanticParts.join(", ")}';

    return AppSemantics.container(
      label: semanticLabel,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: EdgeInsets.all(design.spacing.lg),
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: design.radius.card,
          border: Border.all(
            color: design.colors.border,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (formattedDuration != null)
              _buildInfoRow(
                design: design,
                icon: LucideIcons.clock,
                iconColor: design.colors.success,
                title: L10n.of(context).liveStreamDuration,
                subtitle: formattedDuration,
              ),
            if (formattedDuration != null && formattedStart != null)
              _buildDivider(design),
            if (formattedStart != null)
              _buildInfoRow(
                design: design,
                icon: LucideIcons.calendar,
                iconColor: design.colors.accent1,
                title: L10n.of(context).liveStreamStartTime,
                subtitle: formattedStart,
              ),
            if (state == _LobbyViewState.completedNoRecording) ...[
              _buildDivider(design),
              _buildInfoRow(
                design: design,
                icon: LucideIcons.alertCircle,
                iconColor: design.colors.warning,
                title: L10n.of(context).liveStreamNoRecordingTitle,
                subtitle: L10n.of(context).liveStreamNoRecordingMessage,
              ),
            ],
            if (state == _LobbyViewState.running ||
                state == _LobbyViewState.completedWithRecording) ...[
              SizedBox(height: design.spacing.lg),
              _buildActionButton(context, ref, design, state),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(DesignConfig design) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: design.spacing.md),
        Container(
          height: 1,
          color: design.colors.border,
        ),
        SizedBox(height: design.spacing.md),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    DesignConfig design,
    _LobbyViewState state,
  ) {
    final label = L10n.of(context).liveStreamAttendClass;
    return AppSemantics.button(
      label: label,
      onTap: () => _openWebView(context, ref),
      child: AppButton.primary(
        label: label,
        fullWidth: true,
        leading: Icon(
          LucideIcons.video,
          size: design.iconSize.action,
        ),
        onPressed: () => _openWebView(context, ref),
      ),
    );
  }

  Widget _buildInfoRow({
    required DesignConfig design,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    double? iconSize,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: iconSize ?? design.iconSize.lg,
        ),
        SizedBox(width: design.spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.cardSubtitle(title),
              SizedBox(height: design.spacing.sm),
              AppText.cardTitle(subtitle),
            ],
          ),
        ),
      ],
    );
  }
}

enum _LobbyViewState { running, completedWithRecording, completedNoRecording }
