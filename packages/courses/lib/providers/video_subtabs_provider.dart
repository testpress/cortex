import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/core.dart';
import '../repositories/video_subtabs_repository.dart';
import '../utils/vtt_parser.dart';

part 'video_subtabs_provider.g.dart';

/// Provider for the singleton [VideoSubtabsRepository] instance.
@riverpod
VideoSubtabsRepository videoSubtabsRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return VideoSubtabsRepository(dio);
}

/// Provider that fetches markdown notes from the given [url].
@riverpod
Future<String> fetchNotesMarkdown(Ref ref, String url) async {
  final repository = ref.watch(videoSubtabsRepositoryProvider);
  return repository.fetchNotesMarkdown(url);
}

/// Provider that fetches and parses the transcript VTT cues from the given [url].
@riverpod
Future<List<VttCue>> fetchTranscript(Ref ref, String url) async {
  final repository = ref.watch(videoSubtabsRepositoryProvider);
  return repository.fetchTranscriptCues(url);
}
