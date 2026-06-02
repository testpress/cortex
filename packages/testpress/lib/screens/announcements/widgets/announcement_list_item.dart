import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../announcement_detail_screen.dart';

class AnnouncementListItem extends StatelessWidget {
  const AnnouncementListItem({super.key, required this.post});

  final PostDto post;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    DateTime? date;
    try {
      date = DateTime.parse(post.publishedDate);
    } catch (_) {}

    final formattedDate = date != null ? DateFormatter.formatFullDate(date) : '';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          AppRoute(
            page: AnnouncementDetailScreen(post: post),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: design.spacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (formattedDate.isNotEmpty) ...[
                  AppText.cardSubtitle(
                    formattedDate,
                  ),
                  SizedBox(width: design.spacing.sm),
                ],
                AppBadge(
                  label: post.categoryName ?? '',
                  isPill: true,
                  backgroundColor: design.colors.surface,
                ),
              ],
            ),
            SizedBox(height: design.spacing.sm),
            AppText.cardTitle(
              post.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: design.spacing.xs),
            AppText.cardSubtitle(
              post.summary.replaceAll(RegExp(r'[\r\n]+'), ' ').trim(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
