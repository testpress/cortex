import 'package:flutter/material.dart';
import 'package:core/core.dart';

class SnapshotSection extends StatelessWidget {
  const SnapshotSection({
    super.key,
    required this.title,
    required this.items,
    required this.design,
  });

  final String title;
  final List<Widget> items;
  final DesignConfig design;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: AppText.labelSmall(
            title.toUpperCase(),
            color: design.colors.textPrimary.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 12),
        if (items.length > 1)
          AppCarousel(
            height: 92, // Much tighter fit for dash cards
            showDots: false,
            viewportFraction: 0.88,
            padEnds: false,
            itemCount: items.length,
            itemPadding: EdgeInsets.only(left: design.spacing.md),
            itemBuilder: (context, index) => items[index],
          )
        else
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
            child: items.first,
          ),
      ],
    );
  }
}
