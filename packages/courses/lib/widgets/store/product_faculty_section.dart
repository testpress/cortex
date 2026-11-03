import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Renders the "Meet your faculty" section containing vertical cards for each instructor.
class ProductFacultySection extends StatefulWidget {
  const ProductFacultySection({
    super.key,
    required this.faculty,
    required this.onSelectFaculty,
  });

  final List<ProductFacultyDto> faculty;
  final ValueChanged<ProductFacultyDto> onSelectFaculty;

  @override
  State<ProductFacultySection> createState() => _ProductFacultySectionState();
}

class _ProductFacultySectionState extends State<ProductFacultySection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    if (widget.faculty.isEmpty) {
      return const SizedBox.shrink();
    }

    final design = Design.of(context);
    final l10n = L10n.of(context);
    final displayed =
        _showAll ? widget.faculty : widget.faculty.take(4).toList();

    return Padding(
      padding: EdgeInsets.only(top: design.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSemantics.header(
            label: l10n.storeMeetYourFaculty,
            child: AppText.title(
              l10n.storeMeetYourFaculty,
              color: design.colors.textPrimary,
            ),
          ),
          SizedBox(height: design.spacing.md),
          ...displayed.map(
            (person) => Padding(
              padding: EdgeInsets.only(bottom: design.spacing.md),
              child: ProductFacultyCard(
                person: person,
                onTap: () => widget.onSelectFaculty(person),
              ),
            ),
          ),
          if (widget.faculty.length > 4)
            AppSemantics.button(
              label: _showAll
                  ? l10n.storeShowFewer
                  : l10n.storeShowAllFaculty(widget.faculty.length),
              onTap: () => setState(() => _showAll = !_showAll),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _showAll = !_showAll),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText.labelBold(
                        _showAll
                            ? l10n.storeShowFewer
                            : l10n.storeShowAllFaculty(widget.faculty.length),
                        color: design.colors.primary,
                      ),
                      SizedBox(width: design.spacing.xs),
                      Icon(
                        _showAll
                            ? LucideIcons.chevronUp
                            : LucideIcons.chevronDown,
                        size: design.iconSize.sm,
                        color: design.colors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// An individual instructor card within the "Meet your faculty" section.
class ProductFacultyCard extends StatelessWidget {
  const ProductFacultyCard({
    super.key,
    required this.person,
    required this.onTap,
  });

  final ProductFacultyDto person;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppSemantics.button(
      label: '${person.name}. ${person.subjects.join(", ")}',
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(design.spacing.md),
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.circular(design.radius.md),
            border: Border.all(color: design.colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Avatar with video badge + Name/Subject + Chevron
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAvatar(context, design),
                  SizedBox(width: design.spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.body(
                          person.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          color: design.colors.textPrimary,
                        ),
                        if (person.subjects.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          AppText.caption(
                            person.subjects.join(' · '),
                            color: design.colors.textSecondary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: design.spacing.xs),
                  Icon(
                    LucideIcons.chevronRight,
                    size: design.iconSize.sm,
                    color: design.colors.textSecondary,
                  ),
                ],
              ),

              // Short Description Snippet
              if (person.shortDescription.isNotEmpty) ...[
                SizedBox(height: design.spacing.sm),
                AppText.body(
                  person.shortDescription,
                  color: design.colors.textSecondary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Bottom Metadata Row: Years teaching + Intro video tag
              if (person.yearsOfExperience > 0 || person.hasIntroVideo) ...[
                SizedBox(height: design.spacing.sm),
                Row(
                  children: [
                    if (person.yearsOfExperience > 0) ...[
                      Icon(
                        LucideIcons.briefcase,
                        size: 14,
                        color: design.colors.textSecondary,
                      ),
                      SizedBox(width: design.spacing.xs),
                      AppText.caption(
                        l10n.storeYearsTeaching(person.yearsOfExperience),
                        color: design.colors.textSecondary,
                      ),
                    ],
                    if (person.hasIntroVideo) ...[
                      if (person.yearsOfExperience > 0)
                        SizedBox(width: design.spacing.md),
                      Icon(
                        LucideIcons.playCircle,
                        size: 14,
                        color: design.colors.textSecondary,
                      ),
                      SizedBox(width: design.spacing.xs),
                      AppText.caption(
                        l10n.storeIntroVideo,
                        color: design.colors.textSecondary,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, DesignConfig design) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 52,
            height: 52,
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
                          _buildInitials(design),
                      placeholder: (context, url) =>
                          Container(color: design.colors.surfaceVariant),
                    )
                  : _buildInitials(design),
            ),
          ),
          if (person.hasIntroVideo)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: design.colors.textPrimary,
                  border: Border.all(
                    color: design.colors.card,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.play,
                    size: 10,
                    color: design.colors.textInverse,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInitials(DesignConfig design) {
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
}
