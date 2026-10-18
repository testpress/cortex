import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/data.dart';

void main() {
  group('CommentDto & buildCommentTree', () {
    test('fromJson parses comment and author correctly', () {
      final json = {
        'id': 1052,
        'url': 'https://tenant.testpress.in/api/v2.3/comments/1052/',
        'user': {
          'id': 312,
          'username': 'alex_student',
          'display_name': 'Alex Smith',
          'photo': 'https://media.testpress.in/photos/312_thumb.jpg',
        },
        'parent_id': null,
        'comment': '<p>Could someone clarify why reaction rate doubles?</p>',
        'content_object': {
          'id': 4821,
          'title': 'Introduction to Organic Chemistry',
        },
        'created': '2026-10-15T08:12:00Z',
        'is_public': true,
      };

      final comment = CommentDto.fromJson(json);

      expect(comment.id, 1052);
      expect(comment.url, 'https://tenant.testpress.in/api/v2.3/comments/1052/');
      expect(comment.user.id, 312);
      expect(comment.user.username, 'alex_student');
      expect(comment.user.displayName, 'Alex Smith');
      expect(comment.user.photo, 'https://media.testpress.in/photos/312_thumb.jpg');
      expect(comment.parentId, isNull);
      expect(comment.comment, contains('reaction rate'));
      expect(comment.contentObjectId, 4821);
      expect(comment.contentObjectTitle, 'Introduction to Organic Chemistry');
      expect(comment.isPublic, isTrue);
    });

    test('buildCommentTree correctly groups replies under parent comments', () {
      final flat = [
        CommentDto(
          id: 1,
          url: 'url_1',
          user: const CommentUserDto(id: 1, username: 'user1', displayName: 'User 1'),
          parentId: null,
          comment: 'Root comment 1',
        ),
        CommentDto(
          id: 2,
          url: 'url_2',
          user: const CommentUserDto(id: 2, username: 'user2', displayName: 'User 2'),
          parentId: 1,
          comment: 'Reply to comment 1',
        ),
        CommentDto(
          id: 3,
          url: 'url_3',
          user: const CommentUserDto(id: 3, username: 'user3', displayName: 'User 3'),
          parentId: null,
          comment: 'Root comment 2',
        ),
        CommentDto(
          id: 4,
          url: 'url_4',
          user: const CommentUserDto(id: 1, username: 'user1', displayName: 'User 1'),
          parentId: 2,
          comment: 'Nested reply to comment 2',
        ),
      ];

      final tree = buildCommentTree(flat);

      expect(tree.length, 2); // 2 root comments (1 and 3)
      expect(tree[0].id, 1);
      expect(tree[0].children?.length, 1);
      expect(tree[0].children?[0].id, 2);
      expect(tree[0].children?[0].children?.length, 1);
      expect(tree[0].children?[0].children?[0].id, 4);

      expect(tree[1].id, 3);
      expect(tree[1].children, isEmpty);
    });

    test('LessonDto parses comments_url from API response', () {
      final lessonJson = {
        'id': 4821,
        'title': 'Introduction to Organic Chemistry',
        'content_type': 'Video',
        'comments_url': 'https://tenant.testpress.in/api/v2.3/contents/4821/comments/',
        'duration': '15:00',
        'order': 1,
      };

      final lesson = LessonDto.fromJson(lessonJson);

      expect(lesson.id, '4821');
      expect(lesson.title, 'Introduction to Organic Chemistry');
      expect(lesson.commentsUrl, 'https://tenant.testpress.in/api/v2.3/contents/4821/comments/');
    });
  });
}
