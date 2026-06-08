import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../models/paginated_response_dto.dart';
import '../models/post_dto.dart';
import '../sources/data_source.dart';

/// Repository for Posts/Announcements and their Categories.
class PostsRepository {
  final AppDatabase _db;
  final DataSource _source;

  PostsRepository(this._db, this._source);

  // ── Post Categories ────────────────────────────────────────────────────────

  /// Watch all post categories from the local database.
  Stream<List<PostCategoryDto>> watchPostCategories() {
    return _db.watchPostCategories().map(
      (rows) => rows
          .map(
            (r) => PostCategoryDto(
              id: r.id,
              name: r.name,
              order: r.displayOrder,
              color: r.color,
              slug: r.slug,
              isStarred: r.isStarred,
            ),
          )
          .toList(),
    );
  }

  /// Fetch post categories from the network and cache them locally.
  Future<List<PostCategoryDto>> fetchPostCategories() async {
    final categories = await _source.getPostCategories();
    final companions = categories
        .map(
          (dto) => PostCategoriesTableCompanion.insert(
            id: Value(dto.id),
            name: dto.name,
            displayOrder: dto.order,
            color: dto.color,
            slug: dto.slug,
            isStarred: dto.isStarred,
          ),
        )
        .toList();
    await _db.replacePostCategories(companions);
    return categories;
  }

  // ── Posts ──────────────────────────────────────────────────────────────────

  /// Watch all posts from the local database.
  Stream<List<PostDto>> watchPosts() {
    return _db.watchPosts().map(
      (rows) => rows
          .map(
            (r) => PostDto(
              id: r.id,
              slug: r.slug,
              title: r.title,
              categoryId: r.categoryId,
              categoryName: r.categoryName,
              shortLink: r.shortLink,
              summary: r.summary,
              contentHtml: r.contentHtml,
              coverImage: r.coverImage,
              publishedDate: r.publishedDate,
              webUrl: r.webUrl,
              allowComments: r.allowComments,
            ),
          )
          .toList(),
    );
  }

  /// Fetch a paginated list of posts from the network and cache them locally.
  Future<PaginatedResponseDto<PostDto>> fetchPosts({
    int page = 1,
    String? categorySlug,
  }) async {
    final response = await _source.getPosts(
      page: page,
      categorySlug: categorySlug,
    );
    final companions = response.results
        .map(
          (dto) => PostsTableCompanion.insert(
            id: Value(dto.id),
            slug: dto.slug,
            title: dto.title,
            categoryId: Value(dto.categoryId),
            categoryName: Value(dto.categoryName),
            shortLink: dto.shortLink,
            summary: dto.summary,
            contentHtml: dto.contentHtml,
            coverImage: Value(dto.coverImage),
            publishedDate: dto.publishedDate,
            webUrl: Value(dto.webUrl),
            allowComments: dto.allowComments,
          ),
        )
        .toList();
    // Page 1 = fresh sync — replace all to delete stale entries.
    // Page > 1 = additive pagination — upsert only.
    if (page == 1) {
      await _db.replacePosts(companions);
    } else {
      await _db.upsertPosts(companions);
    }
    return response;
  }
}
