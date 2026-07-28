import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:open_filex/open_filex.dart';
import '../../providers/course_list_provider.dart';
import '../../providers/downloads_provider.dart';

class AttachmentViewer extends ConsumerStatefulWidget {
  final String id;
  final String title;
  final String url;
  final String? fileSize;
  final String? courseName;
  final String? chapterName;

  const AttachmentViewer({
    super.key,
    required this.id,
    required this.title,
    required this.url,
    this.fileSize,
    this.courseName,
    this.chapterName,
  });

  @override
  ConsumerState<AttachmentViewer> createState() => _AttachmentViewerState();
}

class _AttachmentViewerState extends ConsumerState<AttachmentViewer> {
  Future<void> _startDownload() async {
    final sentry = ref.read(sentryServiceProvider);
    try {
      final repo = await ref.read(courseRepositoryProvider.future);
      final details = await repo.getLessonDetails(widget.id);
      final resolvedCourseName =
          details?.courseTitle ?? widget.courseName ?? 'Unknown Course';
      final resolvedChapterName =
          details?.chapterTitle ?? widget.chapterName ?? 'Unknown Chapter';

      final item = DownloadItem(
        id: widget.id,
        title: widget.title,
        course: resolvedCourseName,
        chapter: resolvedChapterName,
        sizeInBytes: 0,
        downloadedDate: DateTime.now().toIso8601String(),
        type: DownloadType.attachment,
        status: DownloadStatus.downloading,
        progress: 0,
        fileType: widget.url
            .split('/')
            .last
            .split('?')
            .first
            .split('.')
            .last
            .toUpperCase(),
        contentUrl: widget.url,
      );

      await ref
          .read(downloadsProvider.notifier)
          .startAttachmentDownload(item, widget.url);
    } catch (e, st) {
      sentry.captureException(e, stackTrace: st);
      if (mounted) {
        AppToast.show(
          context,
          message: 'Could not start download. Please try again.',
          isError: true,
        );
      }
    }
  }

  Future<void> _openFile(DownloadItem item) async {
    final downloader = ref.read(fileDownloaderProvider);
    final path = item.filePath ??
        await downloader.getLocalPath(widget.url, StorageType.publicDownload);

    // Check if the user manually deleted the file via File Explorer
    final fileExists = await File(path).exists();
    if (!fileExists) {
      if (mounted) {
        AppToast.show(
          context,
          message: 'File not found. It may have been deleted.',
          isError: true,
        );
      }
      await ref.read(downloadsProvider.notifier).delete(item);
      return;
    }

    final result = await OpenFilex.open(path);
    if (result.type != ResultType.done && mounted) {
      AppToast.show(
        context,
        message: 'Could not open file: ${result.message}',
        isError: true,
      );
    }
  }

  String _getMetadataString() {
    final fileName = widget.url.split('/').last.split('?').first;
    final extension = fileName.contains('.')
        ? fileName.split('.').last.toUpperCase()
        : 'Unknown';
    final size = widget.fileSize ?? 'N/A';
    return '$extension • $size';
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final downloadItemAsync = ref.watch(watchDownloadItemProvider(widget.id));

    final item = downloadItemAsync.valueOrNull;
    final isDownloading = item?.status == DownloadStatus.downloading;
    final isCompleted = item?.status == DownloadStatus.completed;
    final isError = item?.status == DownloadStatus.error;
    final progress = item?.progress ?? 0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.fileText,
            size: 64,
            color: design.colors.primary,
          ),
          const SizedBox(height: 16),
          AppText.title(
            widget.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          AppText.caption(
            _getMetadataString(),
          ),
          const SizedBox(height: 24),
          if (isDownloading) ...[
            Container(
              height: 4,
              width: 200,
              decoration: BoxDecoration(
                color: design.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(design.radius.sm),
              ),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress > 0 ? progress / 100.0 : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: design.colors.primary,
                    borderRadius: BorderRadius.circular(design.radius.sm),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppText.bodySmall(
              progress > 0 ? '$progress%' : 'Downloading...',
            ),
          ] else
            AppButton(
              onPressed: isCompleted && item != null
                  ? () => _openFile(item)
                  : _startDownload,
              label:
                  isCompleted ? 'View Downloaded File' : 'Download Attachment',
              backgroundColor: isCompleted ? design.colors.success : null,
              foregroundColor: isCompleted ? design.colors.onSuccess : null,
            ),
          if (isError) ...[
            const SizedBox(height: 16),
            AppText.bodySmall(
              'Download failed. Please try again.',
              color: design.colors.error,
            ),
          ],
        ],
      ),
    );
  }
}
