// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookmarkFoldersHash() => r'd688a42f9f7ead677c4fbb117a66ee74d753389c';

/// Stream of all bookmark folders.
///
/// Copied from [bookmarkFolders].
@ProviderFor(bookmarkFolders)
final bookmarkFoldersProvider =
    AutoDisposeStreamProvider<List<BookmarkFolderDto>>.internal(
      bookmarkFolders,
      name: r'bookmarkFoldersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookmarkFoldersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookmarkFoldersRef =
    AutoDisposeStreamProviderRef<List<BookmarkFolderDto>>;
String _$bookmarksForLessonHash() =>
    r'621e40a3b55905e8c3a6b8137bd6a9dea3cce050';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Stream of all active bookmarks for a given lesson.
///
/// Copied from [bookmarksForLesson].
@ProviderFor(bookmarksForLesson)
const bookmarksForLessonProvider = BookmarksForLessonFamily();

/// Stream of all active bookmarks for a given lesson.
///
/// Copied from [bookmarksForLesson].
class BookmarksForLessonFamily extends Family<AsyncValue<List<BookmarkDto>>> {
  /// Stream of all active bookmarks for a given lesson.
  ///
  /// Copied from [bookmarksForLesson].
  const BookmarksForLessonFamily();

  /// Stream of all active bookmarks for a given lesson.
  ///
  /// Copied from [bookmarksForLesson].
  BookmarksForLessonProvider call(int lessonId) {
    return BookmarksForLessonProvider(lessonId);
  }

  @override
  BookmarksForLessonProvider getProviderOverride(
    covariant BookmarksForLessonProvider provider,
  ) {
    return call(provider.lessonId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bookmarksForLessonProvider';
}

/// Stream of all active bookmarks for a given lesson.
///
/// Copied from [bookmarksForLesson].
class BookmarksForLessonProvider
    extends AutoDisposeStreamProvider<List<BookmarkDto>> {
  /// Stream of all active bookmarks for a given lesson.
  ///
  /// Copied from [bookmarksForLesson].
  BookmarksForLessonProvider(int lessonId)
    : this._internal(
        (ref) => bookmarksForLesson(ref as BookmarksForLessonRef, lessonId),
        from: bookmarksForLessonProvider,
        name: r'bookmarksForLessonProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$bookmarksForLessonHash,
        dependencies: BookmarksForLessonFamily._dependencies,
        allTransitiveDependencies:
            BookmarksForLessonFamily._allTransitiveDependencies,
        lessonId: lessonId,
      );

  BookmarksForLessonProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lessonId,
  }) : super.internal();

  final int lessonId;

  @override
  Override overrideWith(
    Stream<List<BookmarkDto>> Function(BookmarksForLessonRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookmarksForLessonProvider._internal(
        (ref) => create(ref as BookmarksForLessonRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lessonId: lessonId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<BookmarkDto>> createElement() {
    return _BookmarksForLessonProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookmarksForLessonProvider && other.lessonId == lessonId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lessonId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookmarksForLessonRef on AutoDisposeStreamProviderRef<List<BookmarkDto>> {
  /// The parameter `lessonId` of this provider.
  int get lessonId;
}

class _BookmarksForLessonProviderElement
    extends AutoDisposeStreamProviderElement<List<BookmarkDto>>
    with BookmarksForLessonRef {
  _BookmarksForLessonProviderElement(super.provider);

  @override
  int get lessonId => (origin as BookmarksForLessonProvider).lessonId;
}

String _$refreshBookmarkFoldersHash() =>
    r'005b08b82129a2bc2fc2becdc449072ff2b37a9f';

/// Action to refresh bookmark folders.
///
/// Copied from [refreshBookmarkFolders].
@ProviderFor(refreshBookmarkFolders)
final refreshBookmarkFoldersProvider = AutoDisposeFutureProvider<void>.internal(
  refreshBookmarkFolders,
  name: r'refreshBookmarkFoldersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$refreshBookmarkFoldersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RefreshBookmarkFoldersRef = AutoDisposeFutureProviderRef<void>;
String _$createBookmarkFolderHash() =>
    r'292a6f252f38123df7a1d9be64e3fd5f5e3350b2';

/// Action to create a new bookmark folder.
///
/// Copied from [createBookmarkFolder].
@ProviderFor(createBookmarkFolder)
const createBookmarkFolderProvider = CreateBookmarkFolderFamily();

/// Action to create a new bookmark folder.
///
/// Copied from [createBookmarkFolder].
class CreateBookmarkFolderFamily extends Family<AsyncValue<BookmarkFolderDto>> {
  /// Action to create a new bookmark folder.
  ///
  /// Copied from [createBookmarkFolder].
  const CreateBookmarkFolderFamily();

  /// Action to create a new bookmark folder.
  ///
  /// Copied from [createBookmarkFolder].
  CreateBookmarkFolderProvider call(String folderName) {
    return CreateBookmarkFolderProvider(folderName);
  }

  @override
  CreateBookmarkFolderProvider getProviderOverride(
    covariant CreateBookmarkFolderProvider provider,
  ) {
    return call(provider.folderName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createBookmarkFolderProvider';
}

/// Action to create a new bookmark folder.
///
/// Copied from [createBookmarkFolder].
class CreateBookmarkFolderProvider
    extends AutoDisposeFutureProvider<BookmarkFolderDto> {
  /// Action to create a new bookmark folder.
  ///
  /// Copied from [createBookmarkFolder].
  CreateBookmarkFolderProvider(String folderName)
    : this._internal(
        (ref) =>
            createBookmarkFolder(ref as CreateBookmarkFolderRef, folderName),
        from: createBookmarkFolderProvider,
        name: r'createBookmarkFolderProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$createBookmarkFolderHash,
        dependencies: CreateBookmarkFolderFamily._dependencies,
        allTransitiveDependencies:
            CreateBookmarkFolderFamily._allTransitiveDependencies,
        folderName: folderName,
      );

  CreateBookmarkFolderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.folderName,
  }) : super.internal();

  final String folderName;

  @override
  Override overrideWith(
    FutureOr<BookmarkFolderDto> Function(CreateBookmarkFolderRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateBookmarkFolderProvider._internal(
        (ref) => create(ref as CreateBookmarkFolderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        folderName: folderName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<BookmarkFolderDto> createElement() {
    return _CreateBookmarkFolderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateBookmarkFolderProvider &&
        other.folderName == folderName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, folderName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateBookmarkFolderRef
    on AutoDisposeFutureProviderRef<BookmarkFolderDto> {
  /// The parameter `folderName` of this provider.
  String get folderName;
}

class _CreateBookmarkFolderProviderElement
    extends AutoDisposeFutureProviderElement<BookmarkFolderDto>
    with CreateBookmarkFolderRef {
  _CreateBookmarkFolderProviderElement(super.provider);

  @override
  String get folderName => (origin as CreateBookmarkFolderProvider).folderName;
}

String _$addBookmarkHash() => r'813b125bb1beea10e23c4cdd704ae6dbc24aa657';

/// Action to add a bookmark for a lesson.
///
/// Copied from [addBookmark].
@ProviderFor(addBookmark)
const addBookmarkProvider = AddBookmarkFamily();

/// Action to add a bookmark for a lesson.
///
/// Copied from [addBookmark].
class AddBookmarkFamily extends Family<AsyncValue<BookmarkDto>> {
  /// Action to add a bookmark for a lesson.
  ///
  /// Copied from [addBookmark].
  const AddBookmarkFamily();

  /// Action to add a bookmark for a lesson.
  ///
  /// Copied from [addBookmark].
  AddBookmarkProvider call({
    required String category,
    required int lessonId,
    String? folder,
    String? bookmarkType,
  }) {
    return AddBookmarkProvider(
      category: category,
      lessonId: lessonId,
      folder: folder,
      bookmarkType: bookmarkType,
    );
  }

  @override
  AddBookmarkProvider getProviderOverride(
    covariant AddBookmarkProvider provider,
  ) {
    return call(
      category: provider.category,
      lessonId: provider.lessonId,
      folder: provider.folder,
      bookmarkType: provider.bookmarkType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'addBookmarkProvider';
}

/// Action to add a bookmark for a lesson.
///
/// Copied from [addBookmark].
class AddBookmarkProvider extends AutoDisposeFutureProvider<BookmarkDto> {
  /// Action to add a bookmark for a lesson.
  ///
  /// Copied from [addBookmark].
  AddBookmarkProvider({
    required String category,
    required int lessonId,
    String? folder,
    String? bookmarkType,
  }) : this._internal(
         (ref) => addBookmark(
           ref as AddBookmarkRef,
           category: category,
           lessonId: lessonId,
           folder: folder,
           bookmarkType: bookmarkType,
         ),
         from: addBookmarkProvider,
         name: r'addBookmarkProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$addBookmarkHash,
         dependencies: AddBookmarkFamily._dependencies,
         allTransitiveDependencies:
             AddBookmarkFamily._allTransitiveDependencies,
         category: category,
         lessonId: lessonId,
         folder: folder,
         bookmarkType: bookmarkType,
       );

  AddBookmarkProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
    required this.lessonId,
    required this.folder,
    required this.bookmarkType,
  }) : super.internal();

  final String category;
  final int lessonId;
  final String? folder;
  final String? bookmarkType;

  @override
  Override overrideWith(
    FutureOr<BookmarkDto> Function(AddBookmarkRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddBookmarkProvider._internal(
        (ref) => create(ref as AddBookmarkRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
        lessonId: lessonId,
        folder: folder,
        bookmarkType: bookmarkType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<BookmarkDto> createElement() {
    return _AddBookmarkProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddBookmarkProvider &&
        other.category == category &&
        other.lessonId == lessonId &&
        other.folder == folder &&
        other.bookmarkType == bookmarkType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, lessonId.hashCode);
    hash = _SystemHash.combine(hash, folder.hashCode);
    hash = _SystemHash.combine(hash, bookmarkType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddBookmarkRef on AutoDisposeFutureProviderRef<BookmarkDto> {
  /// The parameter `category` of this provider.
  String get category;

  /// The parameter `lessonId` of this provider.
  int get lessonId;

  /// The parameter `folder` of this provider.
  String? get folder;

  /// The parameter `bookmarkType` of this provider.
  String? get bookmarkType;
}

class _AddBookmarkProviderElement
    extends AutoDisposeFutureProviderElement<BookmarkDto>
    with AddBookmarkRef {
  _AddBookmarkProviderElement(super.provider);

  @override
  String get category => (origin as AddBookmarkProvider).category;
  @override
  int get lessonId => (origin as AddBookmarkProvider).lessonId;
  @override
  String? get folder => (origin as AddBookmarkProvider).folder;
  @override
  String? get bookmarkType => (origin as AddBookmarkProvider).bookmarkType;
}

String _$removeBookmarkHash() => r'8d622c612df3d3542084a5a311e6e0f56e33053c';

/// Action to remove a bookmark by ID.
///
/// Copied from [removeBookmark].
@ProviderFor(removeBookmark)
const removeBookmarkProvider = RemoveBookmarkFamily();

/// Action to remove a bookmark by ID.
///
/// Copied from [removeBookmark].
class RemoveBookmarkFamily extends Family<AsyncValue<void>> {
  /// Action to remove a bookmark by ID.
  ///
  /// Copied from [removeBookmark].
  const RemoveBookmarkFamily();

  /// Action to remove a bookmark by ID.
  ///
  /// Copied from [removeBookmark].
  RemoveBookmarkProvider call({
    required int bookmarkId,
    required int lessonId,
  }) {
    return RemoveBookmarkProvider(bookmarkId: bookmarkId, lessonId: lessonId);
  }

  @override
  RemoveBookmarkProvider getProviderOverride(
    covariant RemoveBookmarkProvider provider,
  ) {
    return call(bookmarkId: provider.bookmarkId, lessonId: provider.lessonId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'removeBookmarkProvider';
}

/// Action to remove a bookmark by ID.
///
/// Copied from [removeBookmark].
class RemoveBookmarkProvider extends AutoDisposeFutureProvider<void> {
  /// Action to remove a bookmark by ID.
  ///
  /// Copied from [removeBookmark].
  RemoveBookmarkProvider({required int bookmarkId, required int lessonId})
    : this._internal(
        (ref) => removeBookmark(
          ref as RemoveBookmarkRef,
          bookmarkId: bookmarkId,
          lessonId: lessonId,
        ),
        from: removeBookmarkProvider,
        name: r'removeBookmarkProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$removeBookmarkHash,
        dependencies: RemoveBookmarkFamily._dependencies,
        allTransitiveDependencies:
            RemoveBookmarkFamily._allTransitiveDependencies,
        bookmarkId: bookmarkId,
        lessonId: lessonId,
      );

  RemoveBookmarkProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookmarkId,
    required this.lessonId,
  }) : super.internal();

  final int bookmarkId;
  final int lessonId;

  @override
  Override overrideWith(
    FutureOr<void> Function(RemoveBookmarkRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoveBookmarkProvider._internal(
        (ref) => create(ref as RemoveBookmarkRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookmarkId: bookmarkId,
        lessonId: lessonId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _RemoveBookmarkProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoveBookmarkProvider &&
        other.bookmarkId == bookmarkId &&
        other.lessonId == lessonId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookmarkId.hashCode);
    hash = _SystemHash.combine(hash, lessonId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RemoveBookmarkRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `bookmarkId` of this provider.
  int get bookmarkId;

  /// The parameter `lessonId` of this provider.
  int get lessonId;
}

class _RemoveBookmarkProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with RemoveBookmarkRef {
  _RemoveBookmarkProviderElement(super.provider);

  @override
  int get bookmarkId => (origin as RemoveBookmarkProvider).bookmarkId;
  @override
  int get lessonId => (origin as RemoveBookmarkProvider).lessonId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
