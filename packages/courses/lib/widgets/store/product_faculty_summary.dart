import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// A compact row displaying overlapping faculty avatars and a summary label
/// (e.g., "Taught by Dr. Ananya Rao and 5 more").
class ProductFacultySummary extends StatelessWidget {
  const ProductFacultySummary({
    super.key,
    required this.faculty,
    this.onTap,
  });

  final List<ProductFacultyDto> faculty;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (faculty.isEmpty) {
      return const SizedBox.shrink();
    }

    final design = Design.of(context);
    final l10n = L10n.of(context);
    final firstFaculty = faculty.first;
    final otherCount = faculty.length - 1;

    final summaryText = otherCount > 0
        ? l10n.storeTaughtByAndMore(firstFaculty.name, otherCount)
        : l10n.storeTaughtBy(firstFaculty.name);

    final displayedAvatars = faculty.take(4).toList();

    final rowContent = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 28,
            width: 28.0 + (displayedAvatars.length - 1) * 18.0,
            child: Stack(
              children: [
                for (int i = 0; i < displayedAvatars.length; i++)
                  Positioned(
                    left: i * 18.0,
                    child: _buildAvatar(context, design, displayedAvatars[i]),
                  ),
              ],
            ),
          ),
          SizedBox(width: design.spacing.sm),
          Flexible(
            child: AppText.caption(
              summaryText,
              color: design.colors.textSecondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return AppSemantics.button(
        label: summaryText,
        onTap: onTap,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: rowContent,
        ),
      );
    }

    return AppSemantics.container(
      label: summaryText,
      child: rowContent,
    );
  }

  Widget _buildAvatar(
    BuildContext context,
    DesignConfig design,
    ProductFacultyDto person,
  ) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: design.colors.card,
          width: 1.5,
        ),
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
      child: AppText.caption(
        initials,
        color: design.colors.textSecondary,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
