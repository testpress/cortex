import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
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

  // ---------------------------------------------------------------------------
  // PdfScrollThumbPill — regression tests for the 3-digit page count overflow
  // bug where '100 / 200' wrapped onto two lines and the second line was clipped.
  //
  // The pill is pumped in isolation (no PdfViewerScrollThumb required), wrapped
  // in a DesignProvider so Design.of(context) resolves, and given an unconstrained
  // width via OverflowBox so IntrinsicWidth can size freely.
  // ---------------------------------------------------------------------------
  group('PdfScrollThumbPill — page label rendering', () {
    /// Pumps [PdfScrollThumbPill] inside a minimal design-aware widget tree.
    Future<void> pumpPill(
      WidgetTester tester, {
      required int pageNumber,
      required int pageCount,
    }) async {
      await tester.pumpWidget(
        DesignProvider(
          config: DesignConfig.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: PdfScrollThumbPill(
                pageNumber: pageNumber,
                pageCount: pageCount,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders correct label for 2-digit page count (12 / 50)',
        (tester) async {
      await pumpPill(tester, pageNumber: 12, pageCount: 50);

      expect(find.text('12 / 50'), findsOneWidget);
      // Exactly one Text widget — no wrapping into multiple nodes.
      expect(find.byType(Text), findsOneWidget);
      // No overflow errors thrown during layout.
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders correct label for 3-digit page count (100 / 200)',
        (tester) async {
      await pumpPill(tester, pageNumber: 100, pageCount: 200);

      // Regression: previously '/ 200' wrapped onto a second line and was clipped.
      expect(find.text('100 / 200'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'renders correct label for 3-digit page count at last page (999 / 999)',
        (tester) async {
      await pumpPill(tester, pageNumber: 999, pageCount: 999);

      expect(find.text('999 / 999'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders correct label for 4-digit page count (1000 / 2000)',
        (tester) async {
      await pumpPill(tester, pageNumber: 1000, pageCount: 2000);

      expect(find.text('1000 / 2000'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'pill height stays at 28 logical pixels regardless of page count',
        (tester) async {
      await pumpPill(tester, pageNumber: 100, pageCount: 200);

      // Verify via rendered size — the Container's height is set to 28.
      final renderBox = tester.renderObject<RenderBox>(
        find
            .descendant(
              of: find.byType(PdfScrollThumbPill),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(renderBox.size.height, equals(28.0));
    });
  });
}
