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

      expect(
        find.byKey(const ValueKey('ai_attach_camera_option')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('ai_attach_gallery_option')),
        findsOneWidget,
      );
      expect(find.text('Take photo'), findsOneWidget);
      expect(find.text('Attach image'), findsOneWidget);
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
  });
}
