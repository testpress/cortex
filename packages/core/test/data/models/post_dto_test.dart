import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/models/post_dto.dart';

void main() {
  group('PostDto JSON Serialization', () {
    test('fromJson correctly parses nested category map', () {
      final json = {
        'id': 101,
        'slug': 'physics-formula-sheet',
        'title': 'Physics Formula Sheet',
        'category_id': 5,
        'category_name': 'Exams',
        'short_link': 'fseznr',
        'summary': 'Summary text',
        'content_html': '<p>Content</p>',
        'cover_image': 'https://example.com/cover.png',
        'published_date': '2026-10-27T10:00:00Z',
        'web_url': 'https://example.com/posts/physics-formula-sheet',
        'allow_comments': true,
      };

      final dto = PostDto.fromJson(json);

      expect(dto.id, 101);
      expect(dto.slug, 'physics-formula-sheet');
      expect(dto.title, 'Physics Formula Sheet');
      expect(dto.categoryId, 5);
      expect(dto.categoryName, 'Exams');
      expect(dto.shortLink, 'fseznr');
      expect(dto.summary, 'Summary text');
      expect(dto.contentHtml, '<p>Content</p>');
      expect(dto.coverImage, 'https://example.com/cover.png');
      expect(dto.publishedDate, '2026-10-27T10:00:00Z');
      expect(dto.webUrl, 'https://example.com/posts/physics-formula-sheet');
      expect(dto.allowComments, isTrue);
    });

    test(
      'fromJson falls back safely when category is null or missing name',
      () {
        final json = {
          'id': 102,
          'slug': 'general-notice',
          'title': 'General Notice',
          'category': null,
          'short_link': 'gn1234',
          'summary': '',
          'content_html': '',
          'published_date': '2026-10-27T10:00:00Z',
        };

        final dto = PostDto.fromJson(json);

        expect(dto.id, 102);
        expect(dto.categoryId, isNull);
        expect(dto.categoryName, isNull);
      },
    );

    test(
      'fromJson preserves explicit category_name and category_id if present',
      () {
        final json = {
          'id': 103,
          'slug': 'announcement',
          'title': 'Announcement',
          'category_id': 12,
          'category_name': 'Updates',
          'short_link': 'ann123',
          'summary': '',
          'content_html': '',
          'published_date': '2026-10-27T10:00:00Z',
        };

        final dto = PostDto.fromJson(json);

        expect(dto.categoryId, 12);
        expect(dto.categoryName, 'Updates');
      },
    );

    test('toJson produces correct map', () {
      const dto = PostDto(
        id: 104,
        slug: 'test-slug',
        title: 'Test Post',
        categoryId: 3,
        categoryName: 'News',
        shortLink: 'xyz123',
        summary: 'A summary',
        contentHtml: '<div>Html</div>',
        publishedDate: '2026-10-27T10:00:00Z',
        allowComments: false,
      );

      final json = dto.toJson();

      expect(json['id'], 104);
      expect(json['slug'], 'test-slug');
      expect(json['category_id'], 3);
      expect(json['category_name'], 'News');
      expect(json['short_link'], 'xyz123');
    });
  });

  group('PostCategoryDto JSON Serialization', () {
    test('fromJson and toJson roundtrip', () {
      final json = {
        'id': 1,
        'name': 'Announcements',
        'order': 2,
        'color': '#FF0000',
        'slug': 'announcements',
        'is_starred': true,
      };

      final dto = PostCategoryDto.fromJson(json);
      expect(dto.id, 1);
      expect(dto.name, 'Announcements');
      expect(dto.order, 2);
      expect(dto.color, '#FF0000');
      expect(dto.slug, 'announcements');
      expect(dto.isStarred, isTrue);

      final serialized = dto.toJson();
      expect(serialized['name'], 'Announcements');
      expect(serialized['is_starred'], isTrue);
    });
  });
}
