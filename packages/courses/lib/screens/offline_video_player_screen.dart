import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/lesson_detail/custom_video_player.dart';
import '../providers/downloads_provider.dart';

class OfflineVideoPlayerScreen extends ConsumerStatefulWidget {
  final DownloadItem item;

  const OfflineVideoPlayerScreen({
    super.key,
    required this.item,
  });

  @override
  ConsumerState<OfflineVideoPlayerScreen> createState() => _OfflineVideoPlayerScreenState();
}

class _OfflineVideoPlayerScreenState extends ConsumerState<OfflineVideoPlayerScreen> {
  bool _isSheetOpen = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Stack(
      children: [
        Container(
          color: design.colors.card,
          child: SafeArea(
            child: Column(
              children: [
                AppHeader(
                  title: l10n.downloadsTitle,
                  leading: AppFocusable(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      LucideIcons.arrowLeft,
                      color: design.colors.textPrimary,
                    ),
                  ),
                  actions: [
                    AppFocusable(
                      onTap: () => setState(() => _isSheetOpen = true),
                      child: Icon(LucideIcons.moreVertical, color: design.colors.textPrimary, size: design.iconSize.md),
                    ),
                  ],
                ),
                CustomVideoPlayer(
                  assetId: item.id,
                  // We do NOT pass lessonId here, so the player won't attempt to fetch metadata
                  // and will rely solely on the provided assetId for offline playback.
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.headline(
                          item.title,
                          color: design.colors.textPrimary,
                        ),
                        const SizedBox(height: 8),
                        if (item.course.isNotEmpty || item.chapter.isNotEmpty)
                          Text.rich(
                            TextSpan(
                              children: [
                                if (item.course.isNotEmpty)
                                  TextSpan(
                                    text: item.course,
                                    style: const TextStyle(fontWeight: FontWeight.w400),
                                  ),
                                if (item.course.isNotEmpty && item.chapter.isNotEmpty)
                                  const TextSpan(text: '  >  '),
                                if (item.chapter.isNotEmpty)
                                  TextSpan(
                                    text: item.chapter,
                                    style: const TextStyle(fontWeight: FontWeight.w400),
                                  ),
                              ],
                            ),
                            style: design.typography.body.copyWith(
                              color: design.colors.primary,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            if (item.duration != null && item.duration!.isNotEmpty) ...[
                              Icon(LucideIcons.clock, size: 16, color: design.colors.textSecondary),
                              const SizedBox(width: 4),
                              AppText.caption(item.duration!, color: design.colors.textSecondary),
                            ],
                            if (item.duration != null && item.duration!.isNotEmpty && item.sizeInBytes > 0)
                              const SizedBox(width: 16),
                            if (item.sizeInBytes > 0) ...[
                              Icon(LucideIcons.hardDrive, size: 16, color: design.colors.textSecondary),
                              const SizedBox(width: 4),
                              AppText.caption(_formatBytes(item.sizeInBytes), color: design.colors.textSecondary),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AppBottomSheet(
          isOpen: _isSheetOpen,
          onClose: () => setState(() => _isSheetOpen = false),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              design.spacing.sm,
              0,
              design.spacing.sm,
              design.spacing.md,
            ),
            child: SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  design.spacing.lg,
                  design.spacing.md,
                  design.spacing.lg,
                  design.spacing.lg,
                ),
                decoration: BoxDecoration(
                  color: design.colors.card,
                  borderRadius: BorderRadius.all(Radius.circular(design.radius.xxl)),
                  boxShadow: design.shadows.floating,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Handle Bar
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: design.spacing.xl * 1.5,
                        height: 4,
                        decoration: BoxDecoration(
                          color: design.colors.border,
                          borderRadius: BorderRadius.circular(design.radius.full),
                        ),
                      ),
                    ),
                    SizedBox(height: design.spacing.lg),
                    
                    AppFocusable(
                      onTap: () async {
                        setState(() => _isSheetOpen = false);
                        await ref.read(downloadsProvider.notifier).delete(item);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: design.spacing.md),
                        child: Row(
                          children: [
                            Icon(LucideIcons.trash2, size: design.iconSize.md, color: design.colors.error),
                            SizedBox(width: design.spacing.md),
                            AppText.body('Delete Download', color: design.colors.error),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  final kb = bytes / 1024;
  if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
  final mb = kb / 1024;
  if (mb < 1024) return '${mb.toStringAsFixed(1)} MB';
  final gb = mb / 1024;
  return '${gb.toStringAsFixed(1)} GB';
}
