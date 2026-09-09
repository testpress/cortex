import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:courses/widgets/lesson_detail/pdf_viewer.dart';

void main() {
  group('AppPdfViewer resource identity tests (isSameResource)', () {
    test(
        'returns true when network URL paths match even if pre-signed tokens differ',
        () {
      const viewerA = AppPdfViewer.network(
        url:
            'https://cloudfront.net/courses/1583/sample.pdf?Expires=1789042895&Signature=sig1',
      );
      const viewerB = AppPdfViewer.network(
        url:
            'https://cloudfront.net/courses/1583/sample.pdf?response-content-disposition=attachment&Expires=1789042898&Signature=sig2',
      );

      expect(AppPdfViewer.isSameResource(viewerA, viewerB), isTrue);
    });

    test('returns false when network URL paths differ', () {
      const viewerA = AppPdfViewer.network(
        url:
            'https://cloudfront.net/courses/1583/sample_1.pdf?Expires=1789042895',
      );
      const viewerB = AppPdfViewer.network(
        url:
            'https://cloudfront.net/courses/1583/sample_2.pdf?Expires=1789042895',
      );

      expect(AppPdfViewer.isSameResource(viewerA, viewerB), isFalse);
    });

    test('returns false when network URL hosts differ', () {
      const viewerA = AppPdfViewer.network(
        url: 'https://cdn-a.net/sample.pdf',
      );
      const viewerB = AppPdfViewer.network(
        url: 'https://cdn-b.net/sample.pdf',
      );

      expect(AppPdfViewer.isSameResource(viewerA, viewerB), isFalse);
    });

    test('returns false when comparing network viewer to file viewer', () {
      const networkViewer = AppPdfViewer.network(
        url: 'https://cloudfront.net/sample.pdf',
      );
      final fileViewer = AppPdfViewer.file(
        file: File('/storage/emulated/0/Download/sample.pdf'),
      );

      expect(AppPdfViewer.isSameResource(networkViewer, fileViewer), isFalse);
      expect(AppPdfViewer.isSameResource(fileViewer, networkViewer), isFalse);
    });

    test('returns true when file viewers share the same file path', () {
      final fileViewerA = AppPdfViewer.file(
        file: File('/storage/emulated/0/Download/sample.pdf'),
      );
      final fileViewerB = AppPdfViewer.file(
        file: File('/storage/emulated/0/Download/sample.pdf'),
      );

      expect(AppPdfViewer.isSameResource(fileViewerA, fileViewerB), isTrue);
    });

    test('returns false when file viewers have different file paths', () {
      final fileViewerA = AppPdfViewer.file(
        file: File('/storage/emulated/0/Download/sample_1.pdf'),
      );
      final fileViewerB = AppPdfViewer.file(
        file: File('/storage/emulated/0/Download/sample_2.pdf'),
      );

      expect(AppPdfViewer.isSameResource(fileViewerA, fileViewerB), isFalse);
    });
  });
}
