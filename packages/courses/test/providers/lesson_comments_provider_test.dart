import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/data.dart';
import 'package:courses/providers/lesson_comments_provider.dart';

void main() {
  late CommentsRepository repository;

  setUp(() {
    repository = CommentsRepository(const MockDataSource(), SentryService());
  });

  group('LessonCommentsNotifier', () {
    test('fetches initial comments and builds tree', () async {
      final notifier = LessonCommentsNotifier(
        repository: repository,
        commentsUrl: 'https://tenant.testpress.in/api/v2.3/contents/4821/comments/',
      );

      // Wait for fetchInitial async operation
      await Future.delayed(const Duration(milliseconds: 250));

      final state = notifier.state.value;
      expect(state, isNotNull);
      expect(state!.flatComments.isNotEmpty, isTrue);
      expect(state.treeComments.isNotEmpty, isTrue);
      // The tree comments should have root comment 1052 with reply 1053 attached
      final root = state.treeComments.firstWhere((c) => c.id == 1052);
      expect(root.children?.any((c) => c.id == 1053), isTrue);
    });

    test('postComment adds top-level comment and refreshes tree', () async {
      final notifier = LessonCommentsNotifier(
        repository: repository,
        commentsUrl: 'https://tenant.testpress.in/api/v2.3/contents/4821/comments/',
      );

      await Future.delayed(const Duration(milliseconds: 250));

      final countBefore = notifier.state.value!.totalCount;
      await notifier.postComment('New top level discussion');

      final state = notifier.state.value;
      expect(state!.totalCount, countBefore + 1);
      expect(state.treeComments.any((c) => c.comment == 'New top level discussion'), isTrue);
    });

    test('replying to a comment attaches child under targeted parent', () async {
      final notifier = LessonCommentsNotifier(
        repository: repository,
        commentsUrl: 'https://tenant.testpress.in/api/v2.3/contents/4821/comments/',
      );

      await Future.delayed(const Duration(milliseconds: 250));

      final parent = notifier.state.value!.treeComments.first;
      notifier.setReplyTarget(parent);
      expect(notifier.state.value!.replyingToTarget?.id, parent.id);

      await notifier.postComment('Reply to parent');

      final state = notifier.state.value;
      expect(state!.replyingToTarget, isNull); // Reset after submit
      final updatedParent = state.treeComments.firstWhere((c) => c.id == parent.id);
      expect(updatedParent.children?.any((c) => c.comment == 'Reply to parent'), isTrue);
    });

    test('deleteComment removes comment from tree', () async {
      final notifier = LessonCommentsNotifier(
        repository: repository,
        commentsUrl: 'https://tenant.testpress.in/api/v2.3/contents/4821/comments/',
      );

      await Future.delayed(const Duration(milliseconds: 250));

      final created = await notifier.postComment('Temporary comment');
      expect(notifier.state.value!.treeComments.any((c) => c.id == created.id), isTrue);

      await notifier.deleteComment(created.id);
      expect(notifier.state.value!.treeComments.any((c) => c.id == created.id), isFalse);
    });
  });
}
