import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/course_content.dart';
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

  final Lesson lesson;
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);

    final isCompleted = lesson.isStreamCompleted;
    final isRunning = lesson.isStreamRunning;
    final hasRecording = lesson.showRecordedVideo;

    // Determine what action button to show
    final _LobbyAction action;
    if (isCompleted && hasRecording) {
      action = _LobbyAction.watchRecording;
    } else if (isRunning) {
      action = _LobbyAction.joinNow;
    } else {
      action = _LobbyAction.ended;
    }

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
                    action,
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
    _LobbyAction action,
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
    final semanticLabel = 'Session details: ${semanticParts.join(", ")}';

    return AppSemantics.container(
      label: semanticLabel,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: EdgeInsets.all(design.spacing.lg),
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.circular(design.radius.md),
          border: Border.all(
            color: design.colors.border,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (formattedDuration != null)
              _buildDurationRow(context, design, formattedDuration),
            if (formattedDuration != null && formattedStart != null)
              _buildDivider(design),
            if (formattedStart != null)
              _buildStartTimeRow(context, design, formattedStart),
            if (action != _LobbyAction.ended) ...[
              SizedBox(height: design.spacing.lg),
              _buildActionButton(context, ref, design, action),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDurationRow(
      BuildContext context, DesignConfig design, String duration) {
    return Row(
      children: [
        Center(
          child: Icon(
            LucideIcons.clock,
            color: design.colors.success,
            size: design.iconSize.lg,
          ),
        ),
        SizedBox(width: design.spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.cardSubtitle(L10n.of(context).liveStreamDuration),
              SizedBox(height: design.spacing.sm),
              AppText.cardTitle(duration),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStartTimeRow(
      BuildContext context, DesignConfig design, String startTime) {
    return Row(
      children: [
        Center(
          child: Icon(
            LucideIcons.calendar,
            color: design.colors.accent1,
            size: design.iconSize.lg,
          ),
        ),
        SizedBox(width: design.spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.cardSubtitle(L10n.of(context).liveStreamStartTime),
              SizedBox(height: design.spacing.sm),
              AppText.cardTitle(startTime),
            ],
          ),
        ),
      ],
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
    _LobbyAction action,
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
}

enum _LobbyAction { joinNow, watchRecording, ended }
