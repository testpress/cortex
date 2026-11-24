import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildSubject({
    required bool isOpen,
    VoidCallback? onClose,
    VoidCallback? onSelectCamera,
    VoidCallback? onSelectGallery,
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
        home: AiAttachmentPickerSheet(
          isOpen: isOpen,
          onClose: onClose ?? () {},
          onSelectCamera: onSelectCamera ?? () {},
          onSelectGallery: onSelectGallery ?? () {},
        ),
      ),
    );
  }

  group('AiAttachmentPickerSheet', () {
    testWidgets('renders camera and gallery options when open', (tester) async {
      await tester.pumpWidget(buildSubject(isOpen: true));
      await tester.pumpAndSettle();

      final galleryOption = find.byKey(
        const ValueKey('ai_attach_gallery_option'),
      );
      final cameraOption = find.byKey(
        const ValueKey('ai_attach_camera_option'),
      );

      expect(galleryOption, findsOneWidget);
      expect(cameraOption, findsOneWidget);
      expect(find.text('Upload an image'), findsOneWidget);
      expect(find.text('Take a photo'), findsOneWidget);
      expect(find.byIcon(LucideIcons.image), findsOneWidget);
      expect(find.byIcon(LucideIcons.camera), findsOneWidget);

      final galleryY = tester.getTopLeft(galleryOption).dy;
      final cameraY = tester.getTopLeft(cameraOption).dy;
      expect(galleryY, lessThan(cameraY));

      // Touch target height satisfies WCAG 2.5.5 minimum of 48dp
      expect(tester.getSize(galleryOption).height, greaterThanOrEqualTo(48.0));
      expect(tester.getSize(cameraOption).height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('tapping camera calls onSelectCamera', (tester) async {
      bool cameraTapped = false;
      await tester.pumpWidget(
        buildSubject(isOpen: true, onSelectCamera: () => cameraTapped = true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('ai_attach_camera_option')));
      expect(cameraTapped, isTrue);
    });

    testWidgets('tapping gallery calls onSelectGallery', (tester) async {
      bool galleryTapped = false;
      await tester.pumpWidget(
        buildSubject(isOpen: true, onSelectGallery: () => galleryTapped = true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('ai_attach_gallery_option')));
      expect(galleryTapped, isTrue);
    });

    testWidgets('tapping scrim dismisses popover and has close semantics', (
      tester,
    ) async {
      bool closed = false;
      await tester.pumpWidget(
        buildSubject(isOpen: true, onClose: () => closed = true),
      );
      await tester.pumpAndSettle();

      final closeSemantics = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Close' &&
            widget.properties.button == true,
      );
      expect(closeSemantics, findsOneWidget);

      await tester.tap(closeSemantics);
      expect(closed, isTrue);
    });

    testWidgets(
      'unanchored fallback uses PositionedDirectional for RTL support',
      (tester) async {
        await tester.pumpWidget(buildSubject(isOpen: true));
        await tester.pumpAndSettle();

        expect(find.byType(PositionedDirectional), findsOneWidget);
        final positioned = tester.widget<PositionedDirectional>(
          find.byType(PositionedDirectional),
        );
        expect(positioned.start, isNotNull);
      },
    );
  });
}
