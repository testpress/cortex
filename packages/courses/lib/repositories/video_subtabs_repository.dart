import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/vtt_parser.dart';

/// Repository responsible for remote data-fetching and parsing operations
/// specifically related to video subtabs (Transcripts and AI Notes).
class VideoSubtabsRepository {
  final Dio _dio;

  VideoSubtabsRepository(this._dio);

  /// Fetches the raw markdown notes content from the provided [url].
  Future<String> fetchNotesMarkdown(String url) async {
    final response = await _dio.get<String>(url);
    return response.data ?? '';
  }

  /// Fetches the WebVTT subtitle file from the provided [url] and parses it
  /// into a list of [VttCue]s inside a background Dart isolate.
  Future<List<VttCue>> fetchTranscriptCues(String url) async {
    final response = await _dio.get<String>(url);
    if (response.data != null) {
      // Offload heavy WebVTT string parsing to a background isolate to keep main UI thread jank-free
      return compute(VttParser.parse, response.data!);
    }
    return const [];
  }
}
