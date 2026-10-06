import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../providers/course_list_provider.dart';

/// A wrapper screen that renders the external course enrollment / approval page
/// in an authenticated [AppWebView].
///
/// When the user finishes or navigates back from this screen, it triggers a
/// refresh of the courses list so that any updated approval/enrollment status
/// is immediately reflected on the course card.
class CourseEnrollmentScreen extends ConsumerWidget {
  const CourseEnrollmentScreen({
    super.key,
    required this.url,
    this.title,
  });

  final String url;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(courseListProvider.notifier).refresh();
        }
      },
      child: AppWebView(
        url: url,
        title: title,
        showHeader: true,
        useSafeArea: false,
      ),
    );
  }
}
