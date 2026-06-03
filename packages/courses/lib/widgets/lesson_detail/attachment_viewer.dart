import 'dart:io';
import 'package:flutter/material.dart';
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
    try {
      final repo = await ref.read(courseRepositoryProvider.future);
      final details = await repo.getLessonDetails(widget.id);
      final resolvedCourseName = details?.courseTitle ?? widget.courseName ?? 'Unknown Course';
      final resolvedChapterName = details?.chapterTitle ?? widget.chapterName ?? 'Unknown Chapter';

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
        fileType: widget.url.split('/').last.split('?').first.split('.').last.toUpperCase(),
        contentUrl: widget.url,
      );

      await ref.read(downloadsProvider.notifier).startAttachmentDownload(item, widget.url);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not start download. Please try again.')),
        );
      }
    }
  }

  Future<void> _openFile(DownloadItem item) async {
    final downloader = ref.read(fileDownloaderProvider);
    final path = await downloader.getLocalPath(widget.url, StorageType.publicDownload);
    
    // Check if the user manually deleted the file via File Explorer
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
            Icons.file_present,
            size: 64,
            color: design.colors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            widget.title,
            style: design.typography.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            _getMetadataString(),
            style: design.typography.caption,
          ),
          const SizedBox(height: 24),
          if (isDownloading) ...[
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: progress > 0 ? progress / 100.0 : null,
                backgroundColor: design.colors.surfaceVariant,
                color: design.colors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              progress > 0 ? '$progress%' : 'Downloading...',
              style: design.typography.bodySmall,
            ),
          ] else
            AppButton(
              onPressed: isCompleted && item != null ? () => _openFile(item) : _startDownload,
              label: isCompleted ? 'View Downloaded File' : 'Download Attachment',
              backgroundColor: isCompleted ? design.colors.success : null,
              foregroundColor: isCompleted ? design.colors.onSuccess : null,
            ),
          if (isError) ...[
            const SizedBox(height: 16),
            Text(
              'Download failed. Please try again.',
              style: design.typography.bodySmall.copyWith(color: design.colors.error),
            ),
          ],
        ],
      ),
    );
  }
}
