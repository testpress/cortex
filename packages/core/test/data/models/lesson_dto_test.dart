import 'package:core/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LessonDto.fromJson — progressStatus derivation', () {
    /// Minimal valid JSON for a lesson with no attempts.
    /// [contentType] must be a string that matches the parser's contains() checks:
    /// 'exam', 'video', 'live', 'notes', etc.
    Map<String, dynamic> lessonJson({
      int attemptsCount = 0,
      int pausedAttemptsCount = 0,
      String? state,
      String contentType = 'exam',
    }) => {
      'id': '1',
      'title': 'Sample Lesson',
      'content_type': contentType,
      'active': true,
      'attempts_count': attemptsCount,
      'paused_attempts_count': pausedAttemptsCount,
      // ignore: use_null_aware_elements
      if (state != null) 'state': state,
    };

    test(
      'exam with attempts_count > 0 and no explicit state is marked completed',
      () {
        final dto = LessonDto.fromJson(lessonJson(attemptsCount: 1));

        expect(dto.progressStatus, LessonProgressStatus.completed);
        expect(dto.hasAttempts, true);
      },
    );

    test('exam with attempts_count == 0 keeps notStarted status', () {
      final dto = LessonDto.fromJson(lessonJson(attemptsCount: 0));

      expect(dto.progressStatus, LessonProgressStatus.notStarted);
      expect(dto.hasAttempts, false);
    });

    test('parses expiry fields correctly (start, end, has_ended)', () {
      final json = lessonJson();
      json['start'] = '2023-01-01T00:00:00Z';
      json['end'] = '2023-12-31T23:59:59Z';
      json['has_ended'] = true;

      final dto = LessonDto.fromJson(json);

      expect(dto.start, '2023-01-01T00:00:00Z');
      expect(dto.end, '2023-12-31T23:59:59Z');
      expect(dto.hasEnded, true);
    });

    test('defaults expiry fields when missing', () {
      final dto = LessonDto.fromJson(lessonJson());

      expect(dto.start, isNull);
      expect(dto.end, isNull);
      expect(dto.hasEnded, false);
    });

    test(
      'exam with attempts_count > 0 and explicit state=completed remains completed',
      () {
        final dto = LessonDto.fromJson(
          lessonJson(attemptsCount: 2, state: 'completed'),
        );

        expect(dto.progressStatus, LessonProgressStatus.completed);
      },
    );

    test('video with attempts_count > 0 is NOT promoted to completed '
        '— only non-video types use the attempts_count override', () {
      final dto = LessonDto.fromJson(
        lessonJson(attemptsCount: 5, contentType: 'video'),
      );

      // Video lessons must not be promoted by attempts_count.
      expect(dto.progressStatus, isNot(LessonProgressStatus.completed));
    });

    test('video parser captures root uuid and leaves contentUrl null', () {
      final dto = LessonDto.fromJson({
        ...lessonJson(contentType: 'video'),
        'uuid': 'video-uuid-123',
      });

      expect(dto.uuid, 'video-uuid-123');
      expect(dto.contentUrl, isNull);
    });

    test(
      'live-stream with attempts_count > 0 is NOT promoted to completed',
      () {
        final dto = LessonDto.fromJson(
          lessonJson(attemptsCount: 2, contentType: 'live'),
        );

        expect(dto.progressStatus, isNot(LessonProgressStatus.completed));
      },
    );

    test(
      'exam with only paused attempts is NOT marked completed and hasAttempts is false',
      () {
        final dto = LessonDto.fromJson(
          lessonJson(attemptsCount: 1, pausedAttemptsCount: 1),
        );

        expect(dto.progressStatus, LessonProgressStatus.notStarted);
        expect(dto.hasAttempts, false);
      },
    );

    test(
      'exam with mixed paused and completed attempts is marked completed and hasAttempts is true',
      () {
        final dto = LessonDto.fromJson(
          lessonJson(attemptsCount: 2, pausedAttemptsCount: 1),
        );

        expect(dto.progressStatus, LessonProgressStatus.completed);
        expect(dto.hasAttempts, true);
      },
    );

    test(
      'mergeWith does not re-promote a paused-only exam after fromJson re-parse',
      () {
        // fromJson sees attempts_count=1, paused_attempts_count=1 (paused-only)
        final fresh = LessonDto.fromJson({
          'id': '1',
          'content_type': 'exam',
          'active': true,
          'attempts_count': 1,
          'paused_attempts_count': 1,
        });
        // Sync sets authoritative notStarted
        final synced = fresh.copyWith(
          hasAttempts: false,
          progressStatus: LessonProgressStatus.notStarted,
        );
        // Next refreshLessons re-parses and merges
        final merged = fresh.mergeWith(synced);
        expect(merged.hasAttempts, false);
        expect(merged.progressStatus, LessonProgressStatus.notStarted);
      },
    );

    test(
      'mergeWith clears isScheduled when fresh detail has isDetailFetched: true and isScheduled: false',
      () {
        final cachedScheduled = LessonDto.fromJson({
          'error_code': 'scheduled',
          'message': 'Scheduled for 10 AM',
        }).copyWith(id: '1', isDetailFetched: true);

        expect(cachedScheduled.isScheduled, true);

        final freshActive = LessonDto.fromJson({
          'id': '1',
          'title': 'Active Stream',
          'content_type': 'Live Stream',
          'uuid': 'stream-uuid',
          'live_stream': {'status': 'running'},
        }).copyWith(isDetailFetched: true);

        expect(freshActive.isScheduled, false);

        final merged = freshActive.mergeWith(cachedScheduled);
        expect(merged.isScheduled, false);
        expect(merged.scheduledMessage, isNull);
      },
    );

    test(
      'mergeWith preserves fresh exam over cached exam (end-date freshness)',
      () {
        // Simulates refreshLesson: updated.mergeWith(existing)
        // updated = fresh network detail with a real end_date
        final freshExam = ExamDto(
          id: 'exam-1',
          title: 'Final Exam',
          duration: '01:00:00',
          questionCount: 50,
          attemptsUrl: 'https://example.com/attempts',
          startDate: '2026-09-10T10:00:00Z',
          endDate: '2026-09-12T10:00:00Z',
        );
        final fresh = LessonDto.fromJson({
          'id': '1',
          'content_type': 'exam',
          'active': true,
        }).copyWith(exam: freshExam, isDetailFetched: true);

        // existing = stale DB cache — exam stored before end_date was set
        final staleExam = ExamDto(
          id: 'exam-1',
          title: 'Final Exam',
          duration: '01:00:00',
          questionCount: 50,
          attemptsUrl: 'https://example.com/attempts',
          startDate: '2026-09-10T10:00:00Z',
          endDate: null,
        );
        final existing = LessonDto.fromJson({
          'id': '1',
          'content_type': 'exam',
          'active': true,
        }).copyWith(exam: staleExam);

        final merged = fresh.mergeWith(existing);

        expect(merged.exam?.endDate, '2026-09-12T10:00:00Z');
        expect(merged.exam?.id, 'exam-1');
      },
    );

    test('mergeWith falls back to cached exam when fresh exam is null', () {
      // List-endpoint lesson has no exam object; cached detail does.
      // Fresh null must not clobber a valid cached exam.
      final cachedExam = ExamDto(
        id: 'exam-2',
        title: 'Mock Test',
        duration: '00:30:00',
        questionCount: 25,
        attemptsUrl: 'https://example.com/attempts2',
        endDate: '2026-09-15T18:00:00Z',
      );
      final fresh = LessonDto.fromJson({
        'id': '2',
        'content_type': 'exam',
        'active': true,
      });

      final existing = LessonDto.fromJson({
        'id': '2',
        'content_type': 'exam',
        'active': true,
      }).copyWith(exam: cachedExam, isDetailFetched: true);

      final merged = fresh.mergeWith(existing);

      expect(merged.exam?.endDate, '2026-09-15T18:00:00Z');
      expect(merged.exam?.id, 'exam-2');
    });

    // ExamPrescreen call site: fetchedLesson.mergeWith(widget.lesson)
    // `this` = fresh v2.4 detail, `other` = stale v2.5 list snapshot.

    test('mergeWith at ExamPrescreen call site: fresh fetchedLesson exam wins '
        'over stale widget.lesson exam', () {
      // Simulates fetchedLesson.mergeWith(widget.lesson)
      // fetchedLesson (this) = fresh v2.4 detail with a real end_date
      final freshExam = ExamDto(
        id: 'exam-3',
        title: 'Physics Mock',
        duration: '02:00:00',
        questionCount: 100,
        attemptsUrl: 'https://example.com/attempts3',
        startDate: '2026-09-11T09:00:00Z',
        endDate: '2026-09-14T18:00:00Z', // correct fresh end date
      );
      final fetchedLesson = LessonDto.fromJson({
        'id': '3',
        'content_type': 'exam',
        'active': true,
      }).copyWith(exam: freshExam, isDetailFetched: true);

      // widget.lesson (other) = stale v2.5 list snapshot — end_date not yet
      // set on the server when the list was fetched
      final staleExam = ExamDto(
        id: 'exam-3',
        title: 'Physics Mock',
        duration: '02:00:00',
        questionCount: 100,
        attemptsUrl: 'https://example.com/attempts3',
        startDate: '2026-09-11T09:00:00Z',
        endDate: null, // stale — no end date in the list snapshot
      );
      final widgetLesson = LessonDto.fromJson({
        'id': '3',
        'content_type': 'exam',
        'active': true,
      }).copyWith(exam: staleExam);

      final merged = fetchedLesson.mergeWith(widgetLesson);

      // Fresh exam must win: the correct end_date is preserved.
      expect(merged.exam?.endDate, '2026-09-14T18:00:00Z');
      expect(merged.exam?.id, 'exam-3');
    });

    test(
      'mergeWith at ExamPrescreen call site: falls back to widget.lesson exam '
      'when fetchedLesson has no exam object',
      () {
        // Simulates fetchedLesson.mergeWith(widget.lesson)
        // fetchedLesson (this) = v2.4 response with no exam field
        final fetchedLesson = LessonDto.fromJson({
          'id': '4',
          'content_type': 'exam',
          'active': true,
        }).copyWith(isDetailFetched: true); // exam is null

        // widget.lesson (other) = v2.5 list had the exam with its end_date
        final widgetExam = ExamDto(
          id: 'exam-4',
          title: 'Chemistry Test',
          duration: '01:30:00',
          questionCount: 60,
          attemptsUrl: 'https://example.com/attempts4',
          startDate: '2026-09-11T10:00:00Z',
          endDate: '2026-09-20T10:00:00Z',
        );
        final widgetLesson = LessonDto.fromJson({
          'id': '4',
          'content_type': 'exam',
          'active': true,
        }).copyWith(exam: widgetExam);

        final merged = fetchedLesson.mergeWith(widgetLesson);

        // Fallback to widget.lesson exam — must not lose the end_date.
        expect(merged.exam?.endDate, '2026-09-20T10:00:00Z');
        expect(merged.exam?.id, 'exam-4');
      },
    );
  });

  group('LessonDto.fromJson — liveStream parsing', () {
    test('should parse Jitsi/Fermion provider and stream URL correctly', () {
      final json = {
        'id': '10',
        'title': 'Fermion Live',
        'content_type': 'Live Stream',
        'uuid': '123-abc',
        'live_stream': {
          'provider': 'Fermion',
          'stream_url': 'https://fermion.embed/123',
          'chat_embed_url': 'https://fermion.chat/123',
          'status': 'running',
          'duration': '60.5',
          'show_recorded_video': true,
        },
      };

      final dto = LessonDto.fromJson(json);
      expect(dto.liveStreamProvider, 'Fermion');
      expect(dto.contentUrl, 'https://fermion.embed/123');
      expect(dto.chatEmbedUrl, 'https://fermion.chat/123');
      expect(dto.streamStatus, 'running');
      expect(dto.duration, '60 min');
      expect(dto.showRecordedVideo, true);
    });

    test(
      'should parse TpStreams provider and stream URL fallback correctly',
      () {
        final json = {
          'id': '11',
          'title': 'TpStreams Live',
          'content_type': 'Live Stream',
          'uuid': 'tpstreams-uuid',
          'live_stream': {
            'provider': 'TpStreams',
            'stream_url': 'https://tpstreams.video/fallback',
          },
        };

        final dto = LessonDto.fromJson(json);
        expect(dto.liveStreamProvider, 'TpStreams');
        expect(dto.uuid, 'tpstreams-uuid');
        expect(dto.contentUrl, isNull);
      },
    );

    test('should handle missing live_stream object by falling back', () {
      final json = {
        'id': '12',
        'title': 'Fallback Live',
        'content_type': 'Live Stream',
        'uuid': 'some-uuid',
      };

      final dto = LessonDto.fromJson(json);
      expect(dto.liveStreamProvider, isNull);
      expect(dto.uuid, 'some-uuid');
      expect(dto.contentUrl, isNull);
    });

    test(
      'should parse transcoding_status correctly and identify processing state',
      () {
        final jsonCompleted = {
          'id': '13',
          'title': 'Transcoded Video',
          'content_type': 'video',
          'video': {'transcoding_status': 'Completed'},
        };

        final dtoCompleted = LessonDto.fromJson(jsonCompleted);
        expect(dtoCompleted.transcodingStatus, 'Completed');
        expect(dtoCompleted.isTranscodingCompleted, true);
        expect(dtoCompleted.isTranscodingProcessing, false);

        final jsonProcessing = {
          'id': '14',
          'title': 'Processing Video',
          'content_type': 'video',
          'video': {'transcoding_status': 'Processing'},
        };

        final dtoProcessing = LessonDto.fromJson(jsonProcessing);
        expect(dtoProcessing.transcodingStatus, 'Processing');
        expect(dtoProcessing.isTranscodingCompleted, false);
        expect(dtoProcessing.isTranscodingProcessing, true);
      },
    );
  });
}
