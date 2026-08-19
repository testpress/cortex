import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'teams_web_view.dart';

final _meetingJoiningProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Entry widget for Video Conference (e.g. Zoom) lesson contents.
/// Decides whether to show the scheduled lock screen or the lobby page.
class VideoConferenceViewer extends ConsumerWidget {
  const VideoConferenceViewer({
    super.key,
    required this.lesson,
    this.onComplete,
  });

  final LessonDto lesson;
  final VoidCallback? onComplete;

  void _joinMeeting(BuildContext context, WidgetRef ref) async {
    final state = lesson.streamStatus?.toLowerCase();

    if (state == 'completed' || state == 'ended') {
      AppToast.show(context,
          message: L10n.of(context).liveStreamEndedMessage, isError: true);
      return;
    }

    if (state != 'running' && state != 'live' && state != 'started') {
      AppToast.show(
        context,
        message: L10n.of(context).liveStreamWaitingForHost,
        isError: true,
      );
      return;
    }

    if (lesson.isTeams && lesson.contentUrl != null) {
      Navigator.of(context).push(
        AppRoute(
          page: TeamsVideoConferenceScreen(
            joinUrl: lesson.contentUrl!,
            title: lesson.title,
          ),
        ),
      );
      return;
    }

    final meetingService = ref.read(meetingServiceProvider);
    if (meetingService != null) {
      final user = ref.read(userProvider).valueOrNull;
      final displayName = user?.name ?? user?.username ?? 'Participant';

      ref.read(_meetingJoiningProvider.notifier).state = true;
      try {
        await meetingService.joinMeeting(
          jwtToken: lesson.accessToken ?? '',
          meetingNumber: lesson.conferenceId ?? '',
          password: lesson.password ?? '',
          displayName: displayName,
        );
      } catch (e, stack) {
        ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
        if (context.mounted) {
          AppToast.show(
            context,
            message: L10n.of(context).liveStreamJoinFailed,
            isError: true,
          );
        }
      } finally {
        ref.read(_meetingJoiningProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final isJoining = ref.watch(_meetingJoiningProvider);

    // Watch meetingServiceProvider to keep the service alive if it is provided
    ref.watch(meetingServiceProvider);

    if (lesson.isScheduled) {
      return VideoConferenceScheduledView(
        message: lesson.scheduledMessage,
      );
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
                  VideoConferenceLobbyView(
                    lesson: lesson,
                    formattedDuration: formattedDuration,
                    formattedStart: formattedStart,
                    onAttendTap: () => _joinMeeting(context, ref),
                    isJoining: isJoining,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Renders the lock screen for scheduled conferences.
class VideoConferenceScheduledView extends StatelessWidget {
  const VideoConferenceScheduledView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return ColoredBox(
      color: design.colors.canvas,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(design.spacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.calendarClock,
                color: design.colors.primary,
                size: design.iconSize.xl * 2,
              ),
              SizedBox(height: design.spacing.xl),
              AppSemantics.container(
                label: message ?? L10n.of(context).liveStreamScheduledDefault,
                child: AppText.body(
                  message ?? L10n.of(context).liveStreamScheduledDefault,
                  color: design.colors.textSecondary,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Renders the metadata info card (Duration, Start time) and action buttons.
class VideoConferenceLobbyView extends StatelessWidget {
  const VideoConferenceLobbyView({
    super.key,
    required this.lesson,
    this.formattedDuration,
    this.formattedStart,
    required this.onAttendTap,
    this.isJoining = false,
  });

  final LessonDto lesson;
  final String? formattedDuration;
  final String? formattedStart;
  final VoidCallback onAttendTap;
  final bool isJoining;

  bool get _isLive {
    final state = lesson.streamStatus?.toLowerCase();
    return state == 'live' || state == 'running' || state == 'started';
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    if (formattedDuration == null && formattedStart == null) {
      return const SizedBox.shrink();
    }

    final l10n = L10n.of(context);
    final semanticParts = <String>[];
    if (formattedDuration != null) {
      semanticParts.add('${l10n.liveStreamDuration}: $formattedDuration');
    }
    if (formattedStart != null) {
      semanticParts.add('${l10n.liveStreamStartTime}: $formattedStart');
    }
    final statusText = _isLive
        ? l10n.liveStreamStatusLive
        : (lesson.streamStatus?.toLowerCase() == 'completed' ||
                lesson.streamStatus?.toLowerCase() == 'ended')
            ? l10n.liveStreamEndedTitle
            : l10n.liveStreamNotStartedTitle;
    semanticParts.add('${l10n.liveStreamStatus}: $statusText');

    final semanticLabel =
        '${l10n.liveStreamSessionDetails}: ${semanticParts.join(", ")}';

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
              ConferenceInfoRow(
                icon: LucideIcons.clock,
                iconColor: design.colors.success,
                title: L10n.of(context).liveStreamDuration,
                subtitle: formattedDuration!,
              ),
            if (formattedDuration != null && formattedStart != null)
              const ConferenceDivider(),
            if (formattedStart != null)
              ConferenceInfoRow(
                icon: LucideIcons.calendar,
                iconColor: design.colors.accent1,
                title: L10n.of(context).liveStreamStartTime,
                subtitle: formattedStart!,
              ),
            if (_isLive && lesson.isTeams && lesson.contentUrl == null) ...[
              const ConferenceDivider(),
              ConferenceInfoRow(
                icon: LucideIcons.alertCircle,
                iconColor: design.colors.warning,
                title: L10n.of(context).liveStreamJoinFailed,
                subtitle: L10n.of(context).teamsMissingJoinLink,
              ),
            ] else if (_isLive) ...[
              SizedBox(height: design.spacing.lg),
              AppSemantics.button(
                label: L10n.of(context).liveStreamAttendClass,
                onTap: isJoining ? null : onAttendTap,
                child: AppButton.primary(
                  label: L10n.of(context).liveStreamAttendClass,
                  fullWidth: true,
                  loading: isJoining,
                  leading: Icon(
                    LucideIcons.video,
                    size: design.iconSize.action,
                  ),
                  onPressed: isJoining ? null : onAttendTap,
                ),
              ),
            ] else if (lesson.streamStatus?.toLowerCase() == 'completed' ||
                lesson.streamStatus?.toLowerCase() == 'ended') ...[
              const ConferenceDivider(),
              ConferenceInfoRow(
                icon: LucideIcons.alertCircle,
                iconColor: design.colors.warning,
                title: L10n.of(context).liveStreamEndedTitle,
                subtitle: L10n.of(context).liveStreamEndedMessage,
              ),
            ] else ...[
              const ConferenceDivider(),
              ConferenceInfoRow(
                icon: LucideIcons.alertCircle,
                iconColor: design.colors.warning,
                title: L10n.of(context).liveStreamNotStartedTitle,
                subtitle: L10n.of(context).liveStreamWaitingForHost,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Generic info row with icon and details.
class ConferenceInfoRow extends StatelessWidget {
  const ConferenceInfoRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: design.iconSize.lg,
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

/// Generic card divider.
class ConferenceDivider extends StatelessWidget {
  const ConferenceDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
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
}
