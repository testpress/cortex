import 'dart:async';
import 'dart:convert';

/// A single server-sent event assembled from one or more `field: value` lines.
class SseEvent {
  /// Value of the `event:` field, or `message` when the server omitted it.
  final String event;

  /// Concatenated `data:` lines joined with `\n`, as defined by the SSE spec.
  final String data;

  /// Optional `id:` field.
  final String? id;

  const SseEvent({required this.event, required this.data, this.id});

  @override
  String toString() => 'SseEvent(event: $event, data: $data)';
}

/// Incremental parser turning a raw byte stream into [SseEvent]s.
///
/// Handles the realities of `text/event-stream` over a network socket:
/// - A chunk can hold part of an event, several events, or part of a
///   multi-byte UTF-8 character. Bytes are decoded incrementally and text is
///   buffered until a complete event is available.
/// - Line endings may be `\r\n`, `\n`, or `\r`.
/// - Comment lines starting with `:` (keep-alives) are ignored.
/// - Multiple `data:` lines are joined with `\n`.
/// - A leading UTF-8 byte order mark is ignored.
///
/// Events without any `data` line are dropped, matching the SSE spec.
class SseParser extends StreamTransformerBase<List<int>, SseEvent> {
  const SseParser();

  @override
  Stream<SseEvent> bind(Stream<List<int>> stream) {
    // `Converter.bind` is used instead of `stream.transform` because Dio
    // hands over a `Stream<Uint8List>`, and `transform` would fail its
    // runtime covariance check against a `StreamTransformer<List<int>, _>`.
    final text = const Utf8Decoder(allowMalformed: true).bind(stream);
    return const SseTextParser().bind(text);
  }
}

/// Text-level SSE parser. Prefer [SseParser] for byte streams; this layer is
/// exposed so the line assembly can be tested without UTF-8 concerns.
class SseTextParser extends StreamTransformerBase<String, SseEvent> {
  const SseTextParser();

  @override
  Stream<SseEvent> bind(Stream<String> stream) {
    final controller = StreamController<SseEvent>(sync: true);
    final state = _SseParseState();
    StreamSubscription<String>? subscription;

    controller.onListen = () {
      subscription = stream.listen(
        (chunk) {
          try {
            for (final event in state.feed(chunk)) {
              controller.add(event);
            }
          } catch (error, stackTrace) {
            controller.addError(error, stackTrace);
          }
        },
        onError: controller.addError,
        onDone: () {
          final trailing = state.flush();
          if (trailing != null) {
            controller.add(trailing);
          }
          controller.close();
        },
        cancelOnError: false,
      );
    };
    controller.onPause = () => subscription?.pause();
    controller.onResume = () => subscription?.resume();
    controller.onCancel = () => subscription?.cancel();

    return controller.stream;
  }
}

class _SseParseState {
  final StringBuffer _lineBuffer = StringBuffer();
  final List<String> _dataLines = [];
  String? _eventName;
  String? _id;
  bool _hasData = false;
  bool _sawCarriageReturn = false;
  bool _strippedBom = false;

  List<SseEvent> feed(String chunk) {
    final events = <SseEvent>[];
    var text = chunk;

    if (!_strippedBom) {
      _strippedBom = true;
      if (text.isNotEmpty && text.codeUnitAt(0) == 0xFEFF) {
        text = text.substring(1);
      }
    }

    for (var i = 0; i < text.length; i++) {
      final char = text[i];

      if (_sawCarriageReturn) {
        _sawCarriageReturn = false;
        if (char == '\n') {
          // `\r\n` already dispatched the line on `\r`.
          continue;
        }
      }

      if (char == '\r' || char == '\n') {
        _sawCarriageReturn = char == '\r';
        final event = _processLine(_lineBuffer.toString());
        _lineBuffer.clear();
        if (event != null) {
          events.add(event);
        }
        continue;
      }

      _lineBuffer.write(char);
    }

    return events;
  }

  /// Dispatches any pending event when the stream ends without a trailing
  /// blank line.
  SseEvent? flush() {
    if (_lineBuffer.isNotEmpty) {
      final event = _processLine(_lineBuffer.toString());
      _lineBuffer.clear();
      if (event != null) return event;
    }
    return _dispatch();
  }

  SseEvent? _processLine(String line) {
    if (line.isEmpty) {
      return _dispatch();
    }
    if (line.startsWith(':')) {
      // Comment / keep-alive.
      return null;
    }

    final colonIndex = line.indexOf(':');
    final String field;
    String value;
    if (colonIndex == -1) {
      field = line;
      value = '';
    } else {
      field = line.substring(0, colonIndex);
      value = line.substring(colonIndex + 1);
      if (value.startsWith(' ')) {
        value = value.substring(1);
      }
    }

    switch (field) {
      case 'event':
        _eventName = value;
        break;
      case 'data':
        _dataLines.add(value);
        _hasData = true;
        break;
      case 'id':
        _id = value;
        break;
      default:
        // `retry` and unknown fields are ignored.
        break;
    }
    return null;
  }

  SseEvent? _dispatch() {
    if (!_hasData) {
      _eventName = null;
      _id = null;
      return null;
    }

    final event = SseEvent(
      event: (_eventName == null || _eventName!.isEmpty)
          ? 'message'
          : _eventName!,
      data: _dataLines.join('\n'),
      id: _id,
    );

    _dataLines.clear();
    _eventName = null;
    _id = null;
    _hasData = false;
    return event;
  }
}
