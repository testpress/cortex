import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:open_filex/open_filex.dart';
import 'package:dio/dio.dart';

enum AttachmentDownloadState { idle, downloading, completed, error }

class AttachmentViewer extends ConsumerStatefulWidget {
  final String title;
  final String url;
  final String? fileSize;

  const AttachmentViewer({
    super.key,
    required this.title,
    required this.url,
    this.fileSize,
  });

  @override
  ConsumerState<AttachmentViewer> createState() => _AttachmentViewerState();
}

class _AttachmentViewerState extends ConsumerState<AttachmentViewer> with WidgetsBindingObserver {
  AttachmentDownloadState _state = AttachmentDownloadState.idle;
  double _downloadProgress = 0;
  String? _localPath;
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkIfFileExists();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancelToken?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkIfFileExists();
    }
  }

  Future<void> _checkIfFileExists() async {
    try {
      final downloader = ref.read(fileDownloaderProvider);
      final path = await downloader.getLocalPath(widget.url, StorageType.publicDownload);
      final file = File(path);
      
      final exists = await file.exists();
      if (mounted) {
        setState(() {
          if (exists) {
            _localPath = file.path;
            _state = AttachmentDownloadState.completed;
          } else if (_state == AttachmentDownloadState.completed) {
            _localPath = null;
            _state = AttachmentDownloadState.idle;
          }
        });
      }
    } catch (_) {}
  }



  Future<void> _startDownload() async {
    setState(() {
      _state = AttachmentDownloadState.downloading;
      _downloadProgress = 0;
    });

    try {
      _cancelToken = CancelToken();
      final downloader = ref.read(fileDownloaderProvider);
      final savePath = await downloader.download(
        url: widget.url,
        type: StorageType.publicDownload,
        cancelToken: _cancelToken,
        onReceiveProgress: (count, total) {
          if (mounted) {
            setState(() {
              if (total != -1) {
                _downloadProgress = count / total;
              } else {
                _downloadProgress = -1.0;
              }
            });
          }
        },
        requireAuth: false, // Signed URLs often fail with Auth headers
      );

      if (mounted && savePath != null) {
        setState(() {
          _localPath = savePath;
          _state = AttachmentDownloadState.completed;
        });
        await MediaScanner.loadMedia(path: savePath);
      } else if (mounted && savePath == null) {
        setState(() => _state = AttachmentDownloadState.idle);
      }
    } catch (e) {
      final isCancel = e is DioException && CancelToken.isCancel(e);
      if (mounted && !isCancel) {
        setState(() => _state = AttachmentDownloadState.error);
      }
    }
  }

  Future<void> _openFile() async {
    if (_localPath == null) return;
    final result = await OpenFilex.open(_localPath!);
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
    final isDownloading = _state == AttachmentDownloadState.downloading;
    final isCompleted = _state == AttachmentDownloadState.completed;

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
                value: _downloadProgress >= 0 ? _downloadProgress : null,
                backgroundColor: design.colors.surfaceVariant,
                color: design.colors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _downloadProgress >= 0 ? '${(_downloadProgress * 100).toInt()}%' : 'Downloading...',
              style: design.typography.bodySmall,
            ),
          ] else
            AppButton(
              onPressed: isCompleted ? _openFile : _startDownload,
              label: isCompleted ? 'View Downloaded File' : 'Download Attachment',
              backgroundColor: isCompleted ? design.colors.success : null,
              foregroundColor: isCompleted ? design.colors.onSuccess : null,
            ),
          if (_state == AttachmentDownloadState.error) ...[
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
