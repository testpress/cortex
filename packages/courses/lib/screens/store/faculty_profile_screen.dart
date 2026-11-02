import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
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
    // Default to the first course intro video or faculty top-level videoUrl
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
          // Header Bar
          Container(
            decoration: BoxDecoration(
              color: design.colors.card,
              border: Border(
                bottom: BorderSide(color: design.colors.divider),
              ),
            ),
            padding: EdgeInsetsDirectional.fromSTEB(
              design.spacing.screenPadding,
              MediaQuery.paddingOf(context).top + design.spacing.md,
              design.spacing.screenPadding,
              design.spacing.md,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppSemantics.button(
                  label: l10n.commonBackSemantic,
                  onTap: () => Navigator.pop(context),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          LucideIcons.arrowLeft,
                          size: design.iconSize.md,
                          color: design.colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: design.spacing.md),
                Expanded(
                  child: AppSemantics.header(
                    label: l10n.storeFacultyProfile,
                    child: AppText.title(
                      l10n.storeFacultyProfile,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Video Player Section
                      if (_activeVideoUrl != null &&
                          _activeVideoUrl!.trim().isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            design.spacing.screenPadding,
                            design.spacing.md,
                            design.spacing.screenPadding,
                            0,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(design.radius.md),
                            child: _buildVideoContainer(
                              context,
                              design,
                              _activeVideoUrl!,
                              person.photo,
                            ),
                          ),
                        ),
                      ],

                      Padding(
                        padding: EdgeInsets.all(design.spacing.screenPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar + Name + Subtitle
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildAvatar(context, design, person),
                                SizedBox(width: design.spacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.headline(
                                        person.name,
                                        color: design.colors.textPrimary,
                                      ),
                                      const SizedBox(height: 2),
                                      AppText.caption(
                                        [
                                          if (person.subjects.isNotEmpty)
                                            person.subjects.join(' · '),
                                          if (person.yearsOfExperience > 0)
                                            l10n.storeYearsTeaching(
                                                person.yearsOfExperience),
                                        ].join(' · '),
                                        color: design.colors.textSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Short Description
                            if (person.shortDescription.isNotEmpty) ...[
                              SizedBox(height: design.spacing.md),
                              AppText.body(
                                person.shortDescription,
                                color: design.colors.textPrimary,
                              ),
                            ],

                            // Highlights
                            if (person.highlights.isNotEmpty) ...[
                              SizedBox(height: design.spacing.lg),
                              AppSemantics.header(
                                label: l10n.storeHighlights,
                                child: AppText.body(
                                  l10n.storeHighlights,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  color: design.colors.textPrimary,
                                ),
                              ),
                              SizedBox(height: design.spacing.sm),
                              ...person.highlights.map(
                                (item) => Padding(
                                  padding: EdgeInsets.only(
                                      bottom: design.spacing.sm),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Icon(
                                          LucideIcons.award,
                                          size: 16,
                                          color: design.colors.warning,
                                        ),
                                      ),
                                      SizedBox(width: design.spacing.sm),
                                      Expanded(
                                        child: AppText.bodySmall(
                                          item,
                                          color: design.colors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            // Qualifications
                            if (person.qualifications.isNotEmpty) ...[
                              SizedBox(height: design.spacing.lg),
                              AppSemantics.header(
                                label: l10n.storeQualifications,
                                child: AppText.body(
                                  l10n.storeQualifications,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  color: design.colors.textPrimary,
                                ),
                              ),
                              SizedBox(height: design.spacing.sm),
                              ...person.qualifications.map(
                                (item) => Padding(
                                  padding: EdgeInsets.only(
                                      bottom: design.spacing.sm),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Icon(
                                          LucideIcons.graduationCap,
                                          size: 16,
                                          color: design.colors.textSecondary,
                                        ),
                                      ),
                                      SizedBox(width: design.spacing.sm),
                                      Expanded(
                                        child: AppText.bodySmall(
                                          item,
                                          color: design.colors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            // Full Bio / About
                            if (person.bio.isNotEmpty) ...[
                              SizedBox(height: design.spacing.lg),
                              AppSemantics.header(
                                label: l10n.storeAbout,
                                child: AppText.body(
                                  l10n.storeAbout,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  color: design.colors.textPrimary,
                                ),
                              ),
                              SizedBox(height: design.spacing.sm),
                              AppText.bodySmall(
                                person.bio,
                                color: design.colors.textSecondary,
                              ),
                            ],

                            // Teaches In This Product
                            if (person.teaches.isNotEmpty) ...[
                              SizedBox(height: design.spacing.lg),
                              AppSemantics.header(
                                label: l10n.storeTeachesInThisProduct,
                                child: AppText.body(
                                  l10n.storeTeachesInThisProduct,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  color: design.colors.textPrimary,
                                ),
                              ),
                              SizedBox(height: design.spacing.sm),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(design.radius.md),
                                  border:
                                      Border.all(color: design.colors.border),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(design.radius.md),
                                  child: Column(
                                    children: [
                                      for (int i = 0;
                                          i < person.teaches.length;
                                          i++) ...[
                                        if (i > 0)
                                          Container(
                                              height: 1,
                                              color: design.colors.border),
                                        _buildCourseItem(
                                          context,
                                          design,
                                          l10n,
                                          person.teaches[i],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
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

  Widget _buildVideoContainer(
    BuildContext context,
    DesignConfig design,
    String videoUrl,
    String? posterUrl,
  ) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: AppWebView(
        key: ValueKey(videoUrl),
        url: videoUrl,
        mediaMode: true,
        showHeader: false,
        useSafeArea: false,
      ),
    );
  }

  Widget _buildAvatar(
    BuildContext context,
    DesignConfig design,
    ProductFacultyDto person,
  ) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: design.colors.surfaceVariant,
      ),
      child: ClipOval(
        child: person.photo != null && person.photo!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: person.photo!,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    _buildInitials(person, design),
                placeholder: (context, url) =>
                    Container(color: design.colors.surfaceVariant),
              )
            : _buildInitials(person, design),
      ),
    );
  }

  Widget _buildInitials(ProductFacultyDto person, DesignConfig design) {
    final initials = person.initials.isNotEmpty
        ? person.initials
        : (person.name.isNotEmpty ? person.name[0].toUpperCase() : 'F');
    return Center(
      child: AppText.labelBold(
        initials,
        color: design.colors.textSecondary,
      ),
    );
  }

  Widget _buildCourseItem(
    BuildContext context,
    DesignConfig design,
    AppLocalizations l10n,
    FacultyTeachingDto item,
  ) {
    final isShowing =
        item.videoUrl.trim().isNotEmpty && item.videoUrl == _activeVideoUrl;
    final hasVideo = item.videoUrl.trim().isNotEmpty;

    return AppSemantics.button(
      label: '${item.course}. ${item.subject}',
      enabled: hasVideo,
      onTap: hasVideo ? () => _switchVideo(item) : null,
      child: GestureDetector(
        onTap: hasVideo ? () => _switchVideo(item) : null,
        behavior: HitTestBehavior.opaque,
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          color: isShowing
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
                      color: isShowing
                          ? design.colors.success
                          : design.colors.textSecondary,
                    ),
                    SizedBox(width: design.spacing.xs),
                    AppText.caption(
                      isShowing ? l10n.storeNowShowing : l10n.storeWatchIntro,
                      color: isShowing
                          ? design.colors.success
                          : design.colors.textSecondary,
                      style: TextStyle(
                        fontWeight:
                            isShowing ? FontWeight.bold : FontWeight.normal,
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
