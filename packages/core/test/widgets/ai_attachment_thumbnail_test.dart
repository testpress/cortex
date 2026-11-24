import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const _validPng = [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];

void main() {
  Widget buildSubject({
    required StagedAttachment attachment,
    VoidCallback? onRemove,
    VoidCallback? onRetry,
  }) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: WidgetsApp(
        color: const Color(0xFF000000),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        home: Center(
          child: AiAttachmentThumbnail(
            attachment: attachment,
            onRemove: onRemove,
            onRetry: onRetry,
          ),
        ),
      ),
    );
  }

  group('AiAttachmentThumbnail', () {
    testWidgets('renders image and triggers onRemove when tapped', (
      tester,
    ) async {
      bool removed = false;
      final attachment = StagedAttachment(
        localId: 'local-1',
        bytes: Uint8List.fromList(_validPng),
        fileName: 'test.png',
        attachmentId: 'att-1',
      );

      await tester.pumpWidget(
        buildSubject(attachment: attachment, onRemove: () => removed = true),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AiAttachmentThumbnail), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      await tester.tap(find.byIcon(LucideIcons.x));
      expect(removed, isTrue);
    });

    testWidgets('remove button preserves 48dp minimum touch target', (
      tester,
    ) async {
      final attachment = StagedAttachment(
        localId: 'local-1',
        bytes: Uint8List.fromList(_validPng),
        fileName: 'test.png',
        attachmentId: 'att-1',
      );

      await tester.pumpWidget(
        buildSubject(attachment: attachment, onRemove: () {}),
      );
      await tester.pumpAndSettle();

      final gestureFinder = find.ancestor(
        of: find.byIcon(LucideIcons.x),
        matching: find.byType(GestureDetector),
      );
      final size = tester.getSize(gestureFinder);
      expect(size.width, greaterThanOrEqualTo(48.0));
      expect(size.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('displays placeholder icon when bytes are null', (
      tester,
    ) async {
      const attachment = StagedAttachment(
        localId: 'local-no-bytes',
        fileName: 'test.png',
      );

      await tester.pumpWidget(buildSubject(attachment: attachment));
      expect(find.byIcon(LucideIcons.image), findsOneWidget);
    });

    testWidgets('displays loading indicator while uploading', (tester) async {
      const attachment = StagedAttachment(
        localId: 'local-2',
        fileName: 'uploading.png',
        isUploading: true,
      );

      await tester.pumpWidget(buildSubject(attachment: attachment));

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('displays error badge and semantics when upload failed', (
      tester,
    ) async {
      const attachment = StagedAttachment(
        localId: 'local-3',
        fileName: 'failed.png',
        hasError: true,
        errorCode: 'upload_failed',
      );

      await tester.pumpWidget(buildSubject(attachment: attachment));

      expect(find.byIcon(LucideIcons.alertCircle), findsOneWidget);
      expect(find.bySemanticsLabel('Failed to upload image'), findsOneWidget);
    });

    testWidgets('tapping error thumbnail triggers onRetry callback', (
      tester,
    ) async {
      var retryCalled = false;
      const attachment = StagedAttachment(
        localId: 'local-retry',
        fileName: 'failed.png',
        hasError: true,
        errorCode: 'upload_failed',
      );

      await tester.pumpWidget(
        buildSubject(attachment: attachment, onRetry: () => retryCalled = true),
      );

      await tester.tap(find.byType(AiAttachmentThumbnail));
      await tester.pump();

      expect(retryCalled, isTrue);
    });

    testWidgets('tapping delete button triggers onRemove and not onRetry', (
      tester,
    ) async {
      var removeCalled = false;
      var retryCalled = false;
      const attachment = StagedAttachment(
        localId: 'local-remove-test',
        fileName: 'failed.png',
        hasError: true,
        errorCode: 'upload_failed',
      );

      await tester.pumpWidget(
        buildSubject(
          attachment: attachment,
          onRemove: () => removeCalled = true,
          onRetry: () => retryCalled = true,
        ),
      );

      await tester.tap(find.byIcon(LucideIcons.x));
      await tester.pump();

      expect(removeCalled, isTrue);
      expect(retryCalled, isFalse);
    });
  });
}
