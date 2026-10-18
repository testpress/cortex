import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/data.dart';

void main() {
  late DataSource source;
  late SentryService sentryService;
  late CommentsRepository repository;

  setUp(() {
    source = const MockDataSource();
    sentryService = SentryService();
    repository = CommentsRepository(source, sentryService);
  });

  group('CommentsRepository', () {
    test('fetchComments returns mock comments', () async {
      final result = await repository.fetchComments(
        commentsUrl:
            'https://tenant.testpress.in/api/v2.3/contents/4821/comments/',
      );

      expect(result.results.isNotEmpty, isTrue);
      expect(result.results.any((c) => c.id == 1052), isTrue);
    });

    test('postComment creates a new comment', () async {
      final comment = await repository.postComment(
        commentsUrl:
            'https://tenant.testpress.in/api/v2.3/contents/4821/comments/',
        comment: 'This is a test comment',
      );

      expect(comment.comment, 'This is a test comment');
      expect(comment.id, isPositive);
    });

    test('deleteComment removes the comment', () async {
      final comment = await repository.postComment(
        commentsUrl:
            'https://tenant.testpress.in/api/v2.3/contents/4821/comments/',
        comment: 'To be deleted',
      );

      await repository.deleteComment(comment.id);

      final listAfter = await repository.fetchComments(
        commentsUrl:
            'https://tenant.testpress.in/api/v2.3/contents/4821/comments/',
      );

      expect(listAfter.results.any((c) => c.id == comment.id), isFalse);
    });
  });
}
