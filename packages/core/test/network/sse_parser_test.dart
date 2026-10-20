import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:core/network/sse_parser.dart';

Future<List<SseEvent>> parseChunks(List<List<int>> chunks) {
  return const SseParser().bind(Stream.fromIterable(chunks)).toList();
}

Future<List<SseEvent>> parseText(List<String> chunks) {
  return const SseTextParser().bind(Stream.fromIterable(chunks)).toList();
}

void main() {
  group('SseParser', () {
    test('parses a complete multi-event stream in one chunk', () async {
      const raw =
          'event: accepted\n'
          'data: {"answer": null, "chat_id": "chat-1"}\n'
          '\n'
          'event: delta\n'
          'data: {"text": "Hello "}\n'
          '\n'
          'event: delta\n'
          'data: {"text": "world"}\n'
          '\n'
          'event: done\n'
          'data: {"answer": "Hello world", "chat_id": "chat-1"}\n'
          '\n';

      final events = await parseChunks([utf8.encode(raw)]);

      expect(events.map((e) => e.event), [
        'accepted',
        'delta',
        'delta',
        'done',
      ]);
      expect(jsonDecode(events[1].data)['text'], 'Hello ');
      expect(jsonDecode(events[3].data)['answer'], 'Hello world');
    });

    test('assembles events split across arbitrary chunk boundaries', () async {
      const raw =
          'event: delta\ndata: {"text": "piece one"}\n\n'
          'event: delta\ndata: {"text": "piece two"}\n\n';
      final bytes = utf8.encode(raw);

      // Split into 3-byte chunks so field names, colons, and newlines are
      // fragmented in every possible way.
      final chunks = <List<int>>[];
      for (var i = 0; i < bytes.length; i += 3) {
        chunks.add(
          bytes.sublist(i, i + 3 > bytes.length ? bytes.length : i + 3),
        );
      }

      final events = await parseChunks(chunks);

      expect(events.length, 2);
      expect(jsonDecode(events[0].data)['text'], 'piece one');
      expect(jsonDecode(events[1].data)['text'], 'piece two');
    });

    test('decodes a multi-byte UTF-8 character split across chunks', () async {
      // "F = ma → ∑" contains 3-byte UTF-8 sequences.
      const text = 'F = ma → ∑F';
      final raw = utf8.encode('event: delta\ndata: {"text": "$text"}\n\n');

      // Find the arrow's first byte (0xE2) and split in the middle of it.
      final arrowIndex = raw.indexOf(0xE2);
      final chunks = [
        raw.sublist(0, arrowIndex + 1),
        raw.sublist(arrowIndex + 1, arrowIndex + 2),
        raw.sublist(arrowIndex + 2),
      ];

      final events = await parseChunks(chunks);

      expect(events.length, 1);
      expect(jsonDecode(events.single.data)['text'], text);
    });

    test('ignores keep-alive comment lines', () async {
      const raw =
          ': keep-alive\n'
          '\n'
          ': keep-alive\n'
          'event: delta\n'
          'data: {"text": "x"}\n'
          '\n'
          ':another comment\n'
          '\n';

      final events = await parseChunks([utf8.encode(raw)]);

      expect(events.length, 1);
      expect(events.single.event, 'delta');
    });

    test('supports CRLF and bare CR line endings', () async {
      const raw =
          'event: delta\r\n'
          'data: {"text": "crlf"}\r\n'
          '\r\n'
          'event: delta\r'
          'data: {"text": "cr"}\r'
          '\r';

      final events = await parseChunks([utf8.encode(raw)]);

      expect(events.length, 2);
      expect(jsonDecode(events[0].data)['text'], 'crlf');
      expect(jsonDecode(events[1].data)['text'], 'cr');
    });

    test('CRLF split across chunks does not produce an extra event', () async {
      final events = await parseText([
        'event: delta\r\ndata: {"text": "a"}\r',
        '\n\r',
        '\nevent: delta\r\ndata: {"text": "b"}\r\n\r\n',
      ]);

      expect(events.length, 2);
      expect(jsonDecode(events[0].data)['text'], 'a');
      expect(jsonDecode(events[1].data)['text'], 'b');
    });

    test('joins multiple data lines with a newline', () async {
      final events = await parseText([
        'event: note\ndata: line one\ndata: line two\n\n',
      ]);

      expect(events.single.data, 'line one\nline two');
    });

    test('defaults event name to message when omitted', () async {
      final events = await parseText(['data: {"text": "no name"}\n\n']);

      expect(events.single.event, 'message');
    });

    test('drops events without data and ignores unknown fields', () async {
      final events = await parseText([
        'event: ping\nretry: 3000\n\n',
        'id: 7\nevent: delta\ndata: {"text": "ok"}\n\n',
      ]);

      expect(events.length, 1);
      expect(events.single.event, 'delta');
      expect(events.single.id, '7');
    });

    test('strips an optional leading byte order mark', () async {
      final raw = <int>[0xEF, 0xBB, 0xBF, ...utf8.encode('data: bom\n\n')];

      final events = await parseChunks([raw]);

      expect(events.single.data, 'bom');
    });

    test(
      'flushes a trailing event when the stream ends without a blank line',
      () async {
        final events = await parseText(['event: done\ndata: {"answer": "x"}']);

        expect(events.length, 1);
        expect(events.single.event, 'done');
      },
    );

    test('emits events incrementally as chunks arrive', () async {
      final controller = StreamController<List<int>>();
      final received = <SseEvent>[];
      final subscription = const SseParser()
          .bind(controller.stream)
          .listen(received.add);

      controller.add(utf8.encode('event: delta\ndata: {"text": "1"}\n\n'));
      await Future<void>.delayed(Duration.zero);
      expect(received.length, 1);

      controller.add(utf8.encode('event: delta\ndata: {"text": "2"}\n'));
      await Future<void>.delayed(Duration.zero);
      expect(received.length, 1, reason: 'event not yet terminated');

      controller.add(utf8.encode('\n'));
      await Future<void>.delayed(Duration.zero);
      expect(received.length, 2);

      await controller.close();
      await subscription.cancel();
    });

    test('forwards upstream errors to the listener', () async {
      final controller = StreamController<List<int>>();
      final errors = <Object>[];
      final events = <SseEvent>[];
      final done = Completer<void>();

      const SseParser()
          .bind(controller.stream)
          .listen(events.add, onError: errors.add, onDone: done.complete);

      controller.add(utf8.encode('event: delta\ndata: {"text": "1"}\n\n'));
      controller.addError(StateError('socket closed'));
      await controller.close();
      await done.future;

      expect(events.length, 1);
      expect(errors.single, isA<StateError>());
    });
  });
}
