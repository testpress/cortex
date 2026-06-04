import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:open_filex/open_filex.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:core/core.dart';
import 'package:core/data/data.dart';

import '../providers/downloads_provider.dart';
import '../widgets/downloads_header.dart';
import 'offline_video_player_screen.dart';

const _dummyDownload = DownloadItem(
  id: 'skeleton',
  title: 'Loading title placeholder text',
  course: 'Course name placeholder',
  chapter: 'Chapter name placeholder',
  sizeInBytes: 134217728, // 128 MB
  downloadedDate: '2 days ago',
  type: DownloadType.video,
  status: DownloadStatus.completed,
  progress: 100,
  duration: '45:20',
);

class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({super.key});

  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
  DownloadType _activeTab = DownloadType.video;

  @override
  void initState() {
    super.initState();
    // Trigger background sync to verify files and fetch latest SDK state.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(downloadsProvider.notifier).synchronize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final downloadsAsync = ref.watch(downloadsProvider);

    final downloads = downloadsAsync.valueOrNull ?? [];

    final videos = downloads.byType(DownloadType.video);
    final attachments = downloads.byType(DownloadType.attachment);

    final activeItems =
        _activeTab == DownloadType.video ? videos : attachments;

    final isInitialLoading = downloadsAsync.isLoading;

    return Container(
      color: design.colors.canvas,
      child: Column(
        children: [
          DownloadsHeader(
            title: l10n.downloadsTitle,
            onBack: () => context.pop(),
          ),

          _DownloadsTabBar(
            activeTab: _activeTab,
            isLoading: isInitialLoading,
            videoCount: videos.length,
            attachmentCount: attachments.length,
            onChanged: (tab) {
              setState(() {
                _activeTab = tab;
              });
            },
          ),

          Expanded(
            child: SkeletonizerConfig(
              data: SkeletonizerConfigData(
                effect: ShimmerEffect(
                  baseColor: design.colors.surfaceVariant,
                  highlightColor: const Color(0xFFFFFFFF),
                ),
              ),
              child: Skeletonizer(
                enabled: isInitialLoading,
                child: Builder(
                  builder: (_) {
                    if (downloadsAsync.hasError) {
                      return Center(
                        child: AppText.body(
                          'Error: ${downloadsAsync.error}',
                        ),
                      );
                    }

                    return _DownloadsList(
                      items: isInitialLoading
                          ? List.filled(4, _dummyDownload)
                          : activeItems,
                      type: _activeTab,
                      isLoading: isInitialLoading,
                      onAction: _handleAction,
                    );
                  },
                ),
              ),
            ),
          ),

          if (activeItems.isNotEmpty)
            _DownloadsFooter(
              activeTab: _activeTab,
              items: activeItems,
            ),
        ],
      ),
    );
  }

  Future<void> _handleAction(DownloadItem item) async {
    switch (item.status) {
      case DownloadStatus.downloading:
        if (item.type == DownloadType.video) {
          ref.read(downloadsProvider.notifier).pause(item.id);
        }
        break;

      case DownloadStatus.paused:
        if (item.type == DownloadType.video) {
          ref.read(downloadsProvider.notifier).resume(item.id);
        }
        break;

      case DownloadStatus.error:
        break;

      case DownloadStatus.completed:
        if (item.type == DownloadType.attachment && item.contentUrl != null) {
          await _openAttachment(item);
        } else {
          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OfflineVideoPlayerScreen(item: item),
              ),
            );
          }
        }
        break;
    }
  }

  Future<void> _openAttachment(DownloadItem item) async {
    try {
      final downloader = ref.read(fileDownloaderProvider);
      final path = await downloader.getLocalPath(item.contentUrl!, StorageType.publicDownload);
      
      final fileExists = await File(path).exists();
      if (!fileExists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File not found. It may have been deleted.')),
          );
        }
        await ref.read(downloadsProvider.notifier).delete(item);
        return;
      }

      final result = await OpenFilex.open(path);
      if (result.type != ResultType.done && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open file: ${result.message}')),
        );
      }
    } catch (_) {}
  }
}

class _DownloadsTabBar extends StatelessWidget {
  final DownloadType activeTab;
  final bool isLoading;
  final int videoCount;
  final int attachmentCount;
  final ValueChanged<DownloadType> onChanged;

  const _DownloadsTabBar({
    required this.activeTab,
    required this.isLoading,
    required this.videoCount,
    required this.attachmentCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.screenPadding,
        vertical: design.spacing.md,
      ),
      color: design.colors.surface,
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: isLoading
                  ? l10n.downloadsVideosTab
                  : l10n.downloadsVideosTabCount(videoCount),
              icon: LucideIcons.video,
              isActive: activeTab == DownloadType.video,
              onTap: () => onChanged(DownloadType.video),
            ),
          ),
          SizedBox(width: design.spacing.sm),
          Expanded(
            child: _TabButton(
              label: isLoading
                  ? l10n.downloadsAttachmentsTab
                  : l10n.downloadsAttachmentsTabCount(attachmentCount),
              icon: LucideIcons.fileText,
              isActive: activeTab == DownloadType.attachment,
              onTap: () => onChanged(DownloadType.attachment),
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadsList extends ConsumerWidget {
  final List<DownloadItem> items;
  final DownloadType type;
  final bool isLoading;
  final ValueChanged<DownloadItem> onAction;

  const _DownloadsList({
    required this.items,
    required this.type,
    required this.isLoading,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);

    if (!isLoading && items.isEmpty) {
      return _DownloadsEmptyState(type: type);
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () => _onRefresh(ref),
        ),
        SliverPadding(
          padding: EdgeInsets.all(design.spacing.md),
          sliver: SliverList.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) {
              return SizedBox(height: design.spacing.md);
            },
            itemBuilder: (context, index) {
              final item = items[index];

              return _DownloadCard(
                item: item,
                onAction: () => onAction(item),
                onDelete: () async {
                  try {
                    await ref.read(downloadsProvider.notifier).delete(item);
                  } catch (e, st) {
                    debugPrint('Delete Error: $e\n$st');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete: $e')),
                      );
                    }
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _onRefresh(WidgetRef ref) async {
    await ref.read(downloadsProvider.notifier).synchronize();
  }
}

class _DownloadCard extends StatelessWidget {
  final DownloadItem item;
  final VoidCallback onAction;
  final VoidCallback onDelete;

  const _DownloadCard({
    required this.item,
    required this.onAction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppCard(
      onTap: onAction,
      child: Padding(
        padding: EdgeInsets.all(design.spacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DownloadThumbnail(item: item),
            SizedBox(width: design.spacing.md),
            Expanded(
              child: _DownloadInfo(item: item),
            ),
            _DownloadActions(
              item: item,
              onAction: onAction,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadThumbnail extends StatelessWidget {
  final DownloadItem item;

  const _DownloadThumbnail({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      width: 100,
      height: 68,
      decoration: BoxDecoration(
        color: design.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(design.radius.md),
      ),
      child: item.type == DownloadType.video
          ? _VideoThumbnail(item: item)
          : _AttachmentThumbnail(item: item),
    );
  }
}

class _VideoThumbnail extends StatelessWidget {
  final DownloadItem item;

  const _VideoThumbnail({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final placeholder = Center(
      child: Icon(
        LucideIcons.video,
        size: 24,
        color: design.colors.textTertiary,
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        if (item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(design.radius.md),
            child: CachedNetworkImage(
              imageUrl: item.thumbnailUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => placeholder,
              errorWidget: (context, url, error) => placeholder,
            ),
          )
        else
          placeholder,
        if (item.duration != null)
          Positioned(
            bottom: 4,
            right: 4,
            child: Skeleton.ignore(
              child: Opacity(
                opacity: Skeletonizer.of(context).enabled ? 0 : 1,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.xs,
                    vertical: design.spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xCC000000),
                    borderRadius: BorderRadius.circular(
                      design.radius.sm,
                    ),
                  ),
                  child: Text(
                    item.duration!,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AttachmentThumbnail extends StatelessWidget {
  final DownloadItem item;

  const _AttachmentThumbnail({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          LucideIcons.fileText,
          size: 24,
          color: design.colors.textSecondary,
        ),
        if (item.fileType != null) ...[
          SizedBox(height: 2),
          Text(
            item.fileType!,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: design.colors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _DownloadInfo extends StatelessWidget {
  final DownloadItem item;

  const _DownloadInfo({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.cardTitle(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (item.course.isNotEmpty) ...[
          SizedBox(height: design.spacing.xs),
          AppText.cardSubtitle(
            item.course,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (item.chapter.isNotEmpty) ...[
          SizedBox(height: design.spacing.xs),
          AppText.cardCaption(
            item.chapter,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        SizedBox(height: design.spacing.md),
        if (item.status != DownloadStatus.completed) ...[
          _DownloadProgressBar(
            progress: item.progress,
            status: item.status,
          ),
          SizedBox(height: design.spacing.xs),
        ],
        _DownloadMeta(item: item),
      ],
    );
  }
}

class _DownloadMeta extends StatelessWidget {
  final DownloadItem item;

  const _DownloadMeta({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Row(
      children: [
        AppText.cardCaption(item.progressText),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.xs,
          ),
          child: AppText.cardCaption('•'),
        ),
        AppText.cardCaption(
          item.metaText,
          color: item.status == DownloadStatus.error
              ? design.colors.error
              : null,
        ),
      ],
    );
  }
}

class _DownloadProgressBar extends StatelessWidget {
  final int progress;
  final DownloadStatus status;

  const _DownloadProgressBar({
    required this.progress,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Padding(
      padding: EdgeInsets.only(right: design.spacing.md),
      child: Container(
        height: 4,
        width: double.infinity,
        decoration: BoxDecoration(
          color: design.colors.surfaceVariant,
          borderRadius: design.radius.pill,
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress / 100,
          child: Container(
            decoration: BoxDecoration(
              color: status == DownloadStatus.paused
                  ? design.colors.textTertiary
                  : design.colors.primary,
              borderRadius: design.radius.pill,
            ),
          ),
        ),
      ),
    );
  }
}

class _DownloadActions extends StatelessWidget {
  final DownloadItem item;
  final VoidCallback onAction;
  final VoidCallback onDelete;

  const _DownloadActions({
    required this.item,
    required this.onAction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final actionIcon = item.status.actionIcon(
      item.type,
    );

    final actionColor = item.status.actionColor(
      design,
    );

    return Column(
      children: [
        if (actionIcon != null) ...[
          AppFocusable(
            onTap: onAction,
            child: Icon(
              actionIcon,
              size: 18,
              color: actionColor,
            ),
          ),
          SizedBox(height: design.spacing.md),
        ],
        AppFocusable(
          onTap: onDelete,
          child: Icon(
            LucideIcons.trash2,
            size: 18,
            color: design.colors.error,
          ),
        ),
      ],
    );
  }
}

class _DownloadsFooter extends StatelessWidget {
  final DownloadType activeTab;
  final List<DownloadItem> items;

  const _DownloadsFooter({
    required this.activeTab,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.screenPadding,
        vertical: design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.colors.surface,
        border: Border(
          top: BorderSide(
            color: design.colors.divider,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.bodySmall(
            activeTab == DownloadType.video
                ? l10n.downloadsTotalVideos(items.length)
                : l10n.downloadsTotalFiles(items.length),
            color: design.colors.textSecondary,
          ),
          AppText.label(
            l10n.downloadsStorageUsed(
              items.totalSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadsEmptyState extends StatelessWidget {
  final DownloadType type;

  const _DownloadsEmptyState({required this.type});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(design.spacing.xl),
            decoration: BoxDecoration(
              color: design.colors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              type == DownloadType.video
                  ? LucideIcons.video
                  : LucideIcons.fileText,
              size: 48,
              color: design.colors.textSecondary,
            ),
          ),
          SizedBox(height: design.spacing.lg),
          AppText.title(l10n.downloadsEmpty),
          SizedBox(height: design.spacing.xs),
          AppText.body(
            type == DownloadType.video
                ? l10n.downloadsEmptyVideosSubtitle
                : l10n.downloadsEmptyAttachmentsSubtitle,
            color: design.colors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppFocusable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        design.radius.md,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: design.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? design.colors.primary
              : design.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(
            design.radius.md,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? design.colors.surface
                  : design.colors.textSecondary,
            ),
            SizedBox(width: design.spacing.xs),
            AppText.label(
              label,
              color: isActive
                  ? design.colors.surface
                  : design.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

extension DownloadItemsX on List<DownloadItem> {
  List<DownloadItem> byType(DownloadType type) {
    return where((item) => item.type == type).toList();
  }

  String get totalSize {
    final bytes = fold<int>(0, (sum, item) => sum + item.sizeInBytes);
    return _formatBytes(bytes);
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

extension DownloadItemX on DownloadItem {
  String get progressText {
    final size = _formatBytes(sizeInBytes);
    if (status != DownloadStatus.completed) {
      if (type == DownloadType.video) {
        return '$progress%';
      }
      return '$progress% of $size';
    }

    if (type == DownloadType.video && sizeInBytes == 0) {
      return 'Video';
    }

    return size;
  }

  String get metaText {
    if (status == DownloadStatus.error) {
      return 'Error';
    }

    try {
      final date = DateTime.parse(downloadedDate);
      return DateFormatter.formatDateTime(date);
    } catch (_) {
      return downloadedDate; // fallback if parsing fails
    }
  }
}

extension DownloadStatusX on DownloadStatus {
  IconData? actionIcon(DownloadType type) {
    switch (this) {
      case DownloadStatus.downloading:
        return type == DownloadType.video ? LucideIcons.pause : null;

      case DownloadStatus.paused:
        return type == DownloadType.video ? LucideIcons.download : null;

      case DownloadStatus.error:
        return LucideIcons.refreshCw;

      case DownloadStatus.completed:
        return null;
    }
  }

  Color actionColor(DesignConfig design) {
    switch (this) {
      case DownloadStatus.downloading:
        return design.colors.textSecondary;

      case DownloadStatus.paused:
        return design.colors.primary;

      case DownloadStatus.error:
        return design.colors.error;

      case DownloadStatus.completed:
        return design.colors.primary;
    }
  }
}