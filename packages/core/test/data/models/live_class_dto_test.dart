import 'package:core/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LiveClassDto.fromJson', () {
    test(
      'parses properties and derives faculty string with provider and duration',
      () {
        final json = {
          'id': 1720,
          'title': 'Demo Class',
          'start': '2021-04-16T13:24:45.972388+05:30',
          'status': 'live',
          'provider': 'Zoom',
          'duration': 45,
        };

        final dto = LiveClassDto.fromJson(json, 'Physics');

        expect(dto.id, '1720');
        expect(dto.topic, 'Demo Class');
        expect(dto.subject, 'Physics');
        expect(dto.status, LiveClassStatus.live);
        expect(dto.durationMinutes, 45);
        expect(dto.faculty, 'Zoom • 45 mins');
      },
    );

    test('handles null/empty provider and maps duration correctly', () {
      final json = {
        'id': 1721,
        'title': 'Another Class',
        'start': '2021-04-16T13:24:45.972388+05:30',
        'status': 'upcoming',
        'provider': null,
        'duration': 60,
      };

      final dto = LiveClassDto.fromJson(json, 'Chemistry');

      expect(dto.status, LiveClassStatus.upcoming);
      expect(dto.durationMinutes, 60);
      expect(dto.faculty, '60 mins');
    });

    test('maps cancelled status correctly', () {
      final json = {'id': 1722, 'status': 'cancelled'};

      final dto = LiveClassDto.fromJson(json, 'Maths');

      expect(dto.status, LiveClassStatus.cancelled);
    });
  });

  group('LiveClassDto.fromListResponse', () {
    test('maps paginated list results using course names lookup', () {
      final responseJson = {
        'count': 2,
        'next': null,
        'previous': null,
        'results': {
          'courses': [
            {'id': 356, 'title': 'Physics Course'},
            {'id': 357, 'title': 'Chemistry Course'},
          ],
          'live_classes': [
            {
              'id': 1720,
              'title': 'Demo Physics',
              'start': '2021-04-16T13:24:45.972388+05:30',
              'status': 'live',
              'course_id': 356,
              'provider': 'Zoom',
              'duration': 40,
            },
            {
              'id': 1721,
              'title': 'Demo Chemistry',
              'start': '2021-04-16T14:24:45.972388+05:30',
              'status': 'upcoming',
              'course_id': 357,
              'provider': 'Fermion',
              'duration': 50,
            },
          ],
        },
      };

      final response = LiveClassDto.fromListResponse(responseJson);

      expect(response.count, 2);
      expect(response.results.length, 2);

      final first = response.results[0];
      expect(first.id, '1720');
      expect(first.subject, 'Physics Course');
      expect(first.durationMinutes, 40);

      final second = response.results[1];
      expect(second.id, '1721');
      expect(second.subject, 'Chemistry Course');
      expect(second.durationMinutes, 50);
    });
  });
}
