import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Full-page screen displaying detailed instructor credentials, introduction video,
/// highlights, qualifications, and course switcher.
class FacultyProfileScreen extends StatefulWidget {
  const FacultyProfileScreen({
    super.key,
    required this.faculty,
  });

  final ProductFacultyDto faculty;

  @override
  State<FacultyProfileScreen> createState() => _FacultyProfileScreenState();
}

class _FacultyProfileScreenState extends State<FacultyProfileScreen> {
  late String? _activeVideoUrl;

  @override
  void initState() {
    super.initState();
    final firstTeachingWithVideo = widget.faculty.teaches
        .where((t) => t.videoUrl.trim().isNotEmpty)
        .firstOrNull;

    if (firstTeachingWithVideo != null) {
      _activeVideoUrl = firstTeachingWithVideo.videoUrl;
    } else {
      _activeVideoUrl = widget.faculty.videoUrl;
    }
  }

  void _switchVideo(FacultyTeachingDto item) {
    if (item.videoUrl.trim().isEmpty) return;
    setState(() {
      _activeVideoUrl = item.videoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final person = widget.faculty;

    return Container(
      color: design.colors.card,
      child: Column(
        children: [
          _FacultyHeaderBar(
            title: l10n.storeFacultyProfile,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_activeVideoUrl != null &&
                          _activeVideoUrl!.trim().isNotEmpty)
                        _FacultyVideoPlayer(videoUrl: _activeVideoUrl!),
                      Padding(
                        padding: EdgeInsets.all(design.spacing.screenPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FacultyCredentialsSection(faculty: person),
                            if (person.highlights.isNotEmpty) ...[
                              SizedBox(height: design.spacing.lg),
                              _FacultyHighlightsSection(
                                highlights: person.highlights,
                              ),
                            ],
                            if (person.qualifications.isNotEmpty) ...[
                              SizedBox(height: design.spacing.lg),
                              _FacultyQualificationsSection(
                                qualifications: person.qualifications,
                              ),
                            ],
                            if (person.bio.isNotEmpty) ...[
                              SizedBox(height: design.spacing.lg),
                              _FacultyBioSection(bio: person.bio),
                            ],
                            if (person.teaches.isNotEmpty) ...[
                              SizedBox(height: design.spacing.xl),
                              _FacultyCoursesSection(
                                teaches: person.teaches,
                                activeVideoUrl: _activeVideoUrl,
                                onSelectCourse: _switchVideo,
                              ),
                            ],
                            SizedBox(height: design.spacing.xl),
                          ],
                        ),
                      ),
                    ],
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

class _FacultyHeaderBar extends StatelessWidget {
  const _FacultyHeaderBar({
    required this.title,
    required this.onBack,
  });

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      title: title,
      leading: AppBackButton(onTap: onBack),
    );
  }
}

class _FacultyVideoPlayer extends StatefulWidget {
  const _FacultyVideoPlayer({required this.videoUrl});

  final String videoUrl;

  @override
  State<_FacultyVideoPlayer> createState() => _FacultyVideoPlayerState();
}

class _FacultyVideoPlayerState extends State<_FacultyVideoPlayer> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    super.dispose();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'VideoChannel',
        onMessageReceived: (message) {
          if (mounted && message.message == 'ready' && _isLoading) {
            _fallbackTimer?.cancel();
            setState(() => _isLoading = false);
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted && !_isLoading) {
              setState(() => _isLoading = true);
            }
          },
          onPageFinished: (_) {
            if (!_isDirectVideo(widget.videoUrl) && mounted && _isLoading) {
              setState(() => _isLoading = false);
            } else if (mounted) {
              _fallbackTimer?.cancel();
              _fallbackTimer = Timer(const Duration(seconds: 4), () {
                if (mounted && _isLoading) {
                  setState(() => _isLoading = false);
                }
              });
            }
          },
          onWebResourceError: (error) {
            if (mounted && error.isForMainFrame == true) {
              setState(() {
                _hasError = true;
                _isLoading = false;
              });
            }
          },
        ),
      );

    _loadVideo();
  }

  void _loadVideo() {
    _fallbackTimer?.cancel();
    final uri = Uri.tryParse(widget.videoUrl);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      return;
    }

    final html = _buildVideoHtml(widget.videoUrl);
    _controller.loadHtmlString(html, baseUrl: widget.videoUrl);
  }

  static bool _isDirectVideo(String url) {
    return RegExp(
      r'\.(mp4|webm|m3u8|mov)($|\?)',
      caseSensitive: false,
    ).hasMatch(url);
  }

  static String _buildVideoHtml(String url) {
    final escaped = url
        .replaceAll('&', '&amp;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');

    final isDirectVideo = _isDirectVideo(url);

    const blackPoster =
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=';

    final mediaTag = isDirectVideo
        ? '<video id="player" src="$escaped" poster="$blackPoster" preload="auto" controls playsinline style="width:100%;height:100%;object-fit:contain;background:#000;"></video>'
        : '<iframe src="$escaped" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen style="width:100%;height:100%;border:0;"></iframe>';

    return '''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <style>
      * { box-sizing: border-box; margin: 0; padding: 0; }
      html, body {
        width: 100%;
        height: 100%;
        background-color: #000;
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      video, iframe {
        width: 100% !important;
        height: 100% !important;
        border: 0;
        display: block;
      }
    </style>
  </head>
  <body>
    $mediaTag
    <script>
      function notifyReady() {
        if (window.VideoChannel) {
          window.VideoChannel.postMessage('ready');
        }
      }
      var v = document.getElementById('player');
      if (v) {
        v.addEventListener('loadedmetadata', function() {
          if (v.currentTime === 0) {
            v.currentTime = 0.01;
          }
        });
        v.addEventListener('loadeddata', notifyReady);
        v.addEventListener('seeked', notifyReady);
        v.addEventListener('playing', notifyReady);
        v.addEventListener('canplay', notifyReady);
      }
    </script>
  </body>
</html>
''';
  }

  @override
  void didUpdateWidget(covariant _FacultyVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      _loadVideo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        design.spacing.screenPadding,
        design.spacing.md,
        design.spacing.screenPadding,
        0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(design.radius.md),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              Container(
                color: const Color(0xFF000000),
                child: WebViewWidget(controller: _controller),
              ),
              if (_isLoading && !_hasError)
                Positioned.fill(
                  child: Container(
                    color: design.colors.surfaceVariant,
                    child: const Center(
                      child: AppLoadingIndicator(),
                    ),
                  ),
                ),
              if (_hasError)
                Positioned.fill(
                  child: AppErrorView(
                    onRetry: () {
                      setState(() {
                        _hasError = false;
                        _isLoading = true;
                      });
                      _loadVideo();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FacultyAvatar extends StatelessWidget {
  const _FacultyAvatar({
    this.photo,
    required this.initials,
    required this.name,
  });

  final String? photo;
  final String initials;
  final String name;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: design.colors.surfaceVariant,
      ),
      child: ClipOval(
        child: photo != null && photo!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: photo!,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => _buildInitials(design),
                placeholder: (context, url) =>
                    Container(color: design.colors.surfaceVariant),
              )
            : _buildInitials(design),
      ),
    );
  }

  Widget _buildInitials(DesignConfig design) {
    final text = initials.isNotEmpty
        ? initials
        : (name.isNotEmpty ? name[0].toUpperCase() : 'F');
    return Center(
      child: AppText.labelBold(
        text,
        color: design.colors.textSecondary,
      ),
    );
  }
}

class _FacultyCredentialsSection extends StatelessWidget {
  const _FacultyCredentialsSection({required this.faculty});

  final ProductFacultyDto faculty;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _FacultyAvatar(
              photo: faculty.photo,
              initials: faculty.initials,
              name: faculty.name,
            ),
            SizedBox(width: design.spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.headline(
                    faculty.name,
                    color: design.colors.textPrimary,
                  ),
                  const SizedBox(height: 2),
                  AppText.caption(
                    [
                      if (faculty.subjects.isNotEmpty)
                        faculty.subjects.join(' · '),
                      if (faculty.yearsOfExperience > 0)
                        l10n.storeYearsTeaching(faculty.yearsOfExperience),
                    ].join(' · '),
                    color: design.colors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (faculty.shortDescription.isNotEmpty) ...[
          SizedBox(height: design.spacing.md),
          AppText.body(
            faculty.shortDescription,
            color: design.colors.textPrimary,
          ),
        ],
      ],
    );
  }
}

class _FacultyBulletItem extends StatelessWidget {
  const _FacultyBulletItem({
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  final IconData icon;
  final String text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            icon,
            size: 16,
            color: iconColor,
          ),
        ),
        SizedBox(width: design.spacing.sm),
        Expanded(
          child: AppText.bodySmall(
            text,
            color: design.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _FacultyHighlightsSection extends StatelessWidget {
  const _FacultyHighlightsSection({required this.highlights});

  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSemantics.header(
          label: l10n.storeHighlights,
          child: AppText.body(
            l10n.storeHighlights,
            style: const TextStyle(fontWeight: FontWeight.bold),
            color: design.colors.textPrimary,
          ),
        ),
        for (final item in highlights) ...[
          SizedBox(height: design.spacing.sm),
          _FacultyBulletItem(
            icon: LucideIcons.award,
            text: item,
            iconColor: design.colors.warning,
          ),
        ],
      ],
    );
  }
}

class _FacultyQualificationsSection extends StatelessWidget {
  const _FacultyQualificationsSection({required this.qualifications});

  final List<String> qualifications;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSemantics.header(
          label: l10n.storeQualifications,
          child: AppText.body(
            l10n.storeQualifications,
            style: const TextStyle(fontWeight: FontWeight.bold),
            color: design.colors.textPrimary,
          ),
        ),
        for (final item in qualifications) ...[
          SizedBox(height: design.spacing.sm),
          _FacultyBulletItem(
            icon: LucideIcons.graduationCap,
            text: item,
            iconColor: design.colors.textSecondary,
          ),
        ],
      ],
    );
  }
}

class _FacultyBioSection extends StatelessWidget {
  const _FacultyBioSection({required this.bio});

  final String bio;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSemantics.header(
          label: l10n.storeAbout,
          child: AppText.body(
            l10n.storeAbout,
            style: const TextStyle(fontWeight: FontWeight.bold),
            color: design.colors.textPrimary,
          ),
        ),
        SizedBox(height: design.spacing.sm),
        AppText.bodySmall(
          bio,
          color: design.colors.textPrimary,
        ),
      ],
    );
  }
}

class _FacultyCoursesSection extends StatelessWidget {
  const _FacultyCoursesSection({
    required this.teaches,
    required this.activeVideoUrl,
    required this.onSelectCourse,
  });

  final List<FacultyTeachingDto> teaches;
  final String? activeVideoUrl;
  final ValueChanged<FacultyTeachingDto> onSelectCourse;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSemantics.header(
          label: l10n.storeTeachesInThisProduct,
          child: AppText.body(
            l10n.storeTeachesInThisProduct,
            style: const TextStyle(fontWeight: FontWeight.bold),
            color: design.colors.textPrimary,
          ),
        ),
        SizedBox(height: design.spacing.sm + design.spacing.xs),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(design.radius.md),
            border: Border.all(color: design.colors.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(design.radius.md),
            child: Column(
              children: [
                for (int i = 0; i < teaches.length; i++) ...[
                  if (i > 0) Container(height: 1, color: design.colors.border),
                  _FacultyCourseItem(
                    item: teaches[i],
                    isActive: teaches[i].videoUrl.trim().isNotEmpty &&
                        teaches[i].videoUrl == activeVideoUrl,
                    onTap: () => onSelectCourse(teaches[i]),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FacultyCourseItem extends StatelessWidget {
  const _FacultyCourseItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final FacultyTeachingDto item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final hasVideo = item.videoUrl.trim().isNotEmpty;

    return AppSemantics.button(
      label: '${item.course}. ${item.subject}',
      enabled: hasVideo,
      onTap: hasVideo ? onTap : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: hasVideo ? onTap : null,
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          color: isActive
              ? design.colors.surfaceVariant.withValues(alpha: 0.4)
              : design.colors.card,
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.bodySmall(
                      item.course,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      color: design.colors.textPrimary,
                    ),
                    if (item.subject.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      AppText.caption(
                        item.subject,
                        color: design.colors.textSecondary,
                      ),
                    ],
                  ],
                ),
              ),
              if (hasVideo) ...[
                SizedBox(width: design.spacing.sm),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.playCircle,
                      size: 16,
                      color: isActive
                          ? design.colors.success
                          : design.colors.textSecondary,
                    ),
                    SizedBox(width: design.spacing.xs),
                    AppText.caption(
                      isActive ? l10n.storeNowShowing : l10n.storeWatchIntro,
                      color: isActive
                          ? design.colors.success
                          : design.colors.textSecondary,
                      style: TextStyle(
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
