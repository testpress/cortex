import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/models/course_dto.dart';

void main() {
  group('CourseDto JSON Serialization', () {
    test(
      'fromJson correctly parses external_content_link and external_link_label',
      () {
        final json = {
          'id': 768,
          'title': 'IBPS RRB PO XV PRELIMS-2026',
          'chapters_count': 1,
          'contents_count': 10,
          'exams_count': 10,
          'order': 1,
          'external_content_link': 'https://example.com/sso/register/768',
          'external_link_label': 'REQUEST PACKAGE',
        };

        final dto = CourseDto.fromJson(json);

        expect(dto.id, '768');
        expect(dto.title, 'IBPS RRB PO XV PRELIMS-2026');
        expect(dto.chapterCount, 1);
        expect(dto.totalContents, 10);
        expect(dto.examsCount, 10);
        expect(dto.externalContentLink, 'https://example.com/sso/register/768');
        expect(dto.externalLinkLabel, 'REQUEST PACKAGE');
        expect(dto.requiresExternalRegistration, isTrue);
        expect(dto.isPendingApproval, isFalse);
      },
    );

    test('toJson preserves externalContentLink and externalLinkLabel', () {
      const dto = CourseDto(
        id: '123',
        title: 'Sample Course',
        colorIndex: 0,
        chapterCount: 2,
        totalContents: 5,
        externalContentLink: 'https://example.com/register',
        externalLinkLabel: 'RESUBMIT',
      );

      final json = dto.toJson();

      expect(json['external_content_link'], 'https://example.com/register');
      expect(json['external_link_label'], 'RESUBMIT');
    });
  });

  group('CourseDto Helper Getters', () {
    test(
      'requiresExternalRegistration returns true when externalContentLink or actionable externalLinkLabel is present',
      () {
        const normalCourse = CourseDto(
          id: '1',
          title: 'Normal Course',
          colorIndex: 0,
          chapterCount: 1,
          totalContents: 1,
        );
        expect(normalCourse.requiresExternalRegistration, isFalse);

        const contentsLabelCourse = CourseDto(
          id: '2',
          title: 'Contents Label Course',
          colorIndex: 0,
          chapterCount: 1,
          totalContents: 1,
          externalLinkLabel: 'Contents',
        );
        expect(contentsLabelCourse.requiresExternalRegistration, isFalse);

        const emptyLinkCourse = CourseDto(
          id: '3',
          title: 'Empty Link Course',
          colorIndex: 0,
          chapterCount: 1,
          totalContents: 1,
          externalContentLink: '   ',
        );
        expect(emptyLinkCourse.requiresExternalRegistration, isFalse);

        const lockedCourseWithLink = CourseDto(
          id: '4',
          title: 'Locked Course With Link',
          colorIndex: 0,
          chapterCount: 1,
          totalContents: 1,
          externalContentLink: 'https://example.com/sso',
        );
        expect(lockedCourseWithLink.requiresExternalRegistration, isTrue);

        const lockedCourseWithLabelOnly = CourseDto(
          id: '5',
          title: 'Locked Course With Label Only',
          colorIndex: 0,
          chapterCount: 1,
          totalContents: 1,
          externalLinkLabel: 'REQUEST PACKAGE',
        );
        expect(lockedCourseWithLabelOnly.requiresExternalRegistration, isFalse);
      },
    );

    test('isPendingApproval detects RESUBMIT and PENDING labels', () {
      const requestCourse = CourseDto(
        id: '1',
        title: 'Request Course',
        colorIndex: 0,
        chapterCount: 1,
        totalContents: 1,
        externalContentLink: 'https://example.com/sso',
        externalLinkLabel: 'REQUEST PACKAGE',
      );
      expect(requestCourse.isPendingApproval, isFalse);

      const resubmitCourse = CourseDto(
        id: '2',
        title: 'Resubmit Course',
        colorIndex: 0,
        chapterCount: 1,
        totalContents: 1,
        externalContentLink: 'https://example.com/sso',
        externalLinkLabel: 'RESUBMIT',
      );
      expect(resubmitCourse.isPendingApproval, isTrue);

      const pendingCourse = CourseDto(
        id: '3',
        title: 'Pending Course',
        colorIndex: 0,
        chapterCount: 1,
        totalContents: 1,
        externalContentLink: 'https://example.com/sso',
        externalLinkLabel: 'Pending Approval',
      );
      expect(pendingCourse.isPendingApproval, isTrue);
    });
  });
}
