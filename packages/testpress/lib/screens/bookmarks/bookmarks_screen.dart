import 'package:flutter/material.dart' show FloatingActionButton;
import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:exams/exams.dart';
import 'widgets/bookmark_item.dart';
import 'widgets/folder_item.dart';
import 'widgets/bookmarks_header.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

final _dummyFolders = List.generate(
  5,
  (index) => const BookmarkFolderDto(
    id: 0,
    name: 'Loading Folder Name',
    bookmarksCount: 0,
  ),
);

final _dummyBookmarks = List.generate(
  5,
  (index) => const BookmarkDto(
    id: 0,
    lessonId: 0,
    title: 'Loading Bookmark Title Long',
    chapterName: 'Loading Chapter Name',
    type: '',
  ),
);

class BookmarksScreen extends ConsumerStatefulWidget {
  final String? folderName;
  const BookmarksScreen({super.key, this.folderName});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  String _activeFilter = 'all';

  String _selectedContentType = 'All contents';
  final List<String> _contentTypes = [
    'All contents',
    'Questions',
    'Videos',
    'PDFs',
    'Notes',
    'Exams and Quiz',
    'Live Classes',
  ];

  String _selectedSort = 'Recent';
  final List<String> _sortOptions = ['Recent', 'Oldest', 'Lastly opened'];

  bool _isFolderOptionsOpen = false;
  bool _isBookmarkOptionsOpen = false;
  bool _isBookmarkFolderSheetOpen = false;
  bool _isCreateFolderDialogOpen = false;
  BookmarkDto? _selectedBookmark;
  BookmarkFolderDto? _selectedFolder;

  bool _isContentTypeOptionsOpen = false;
  bool _isSortOptionsOpen = false;

  String _localizeContentType(String type, BuildContext context) {
    final l10n = L10n.of(context);
    return switch (type) {
      'All contents' => l10n.bookmarkFilterAllContents,
      'Questions' => l10n.bookmarkFilterQuestions,
      'Videos' => l10n.bookmarkFilterVideos,
      'PDFs' => l10n.bookmarkFilterPDFs,
      'Notes' => l10n.bookmarkFilterNotes,
      'Exams and Quiz' => l10n.bookmarkFilterExamsAndQuiz,
      'Live Classes' => l10n.bookmarkFilterLiveClasses,
      _ => type,
    };
  }

  String _localizeSort(String sort, BuildContext context) {
    final l10n = L10n.of(context);
    return switch (sort) {
      'Recent' => l10n.bookmarkSortRecent,
      'Oldest' => l10n.bookmarkSortOldest,
      'Lastly opened' => l10n.bookmarkSortLastlyOpened,
      _ => sort,
    };
  }

  void _navigateToBookmark(BuildContext context, BookmarkDto bookmark) {
    final type = (bookmark.bookmarkType ?? bookmark.type).toLowerCase();
    switch (type) {
      case 'forumpost':
        if (bookmark.slug != null && bookmark.slug!.isNotEmpty) {
          context.push('/home/discussions/forum/posts/${bookmark.slug}');
        }
        break;
      case 'video':
      case 'livestream':
      case 'pdf':
      case 'attachment':
      case 'notes':
      case 'html':
        if (bookmark.lessonId > 0) {
          context.push('/study/lesson/${bookmark.lessonId}');
        }
        break;
      case 'question':
      case 'userselectedanswer':
        if (bookmark.attemptId != null) {
          _navigateToReviewQuestion(context, bookmark);
        }
        break;
      default:
        // No-ops for unsupported types (post, exam, notice, etc.)
        break;
    }
  }

  void _navigateToReviewQuestion(BuildContext context, BookmarkDto bookmark) {
    final attemptId = bookmark.attemptId!;
    final navigator = Navigator.of(context);

    navigator.push(
      AppRoute(
        page: ReviewAnswerDetailScreen(
          assessmentTitle: bookmark.chapterName,
          questions: const [],
          attemptStates: const {},
          attempt: AttemptDto(id: attemptId),
          onBack: () => navigator.pop(),
          initialQuestionId: bookmark.lessonId.toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    // Derive filter params from UI state
    final String? folderParam =
        widget.folderName ??
        (_activeFilter == 'uncategorized' ? 'uncategorized' : null);

    String? orderParam;
    if (_selectedSort == 'Oldest') {
      orderParam = 'created';
    } else if (_selectedSort == 'Lastly opened') {
      orderParam = '-modified';
    } else {
      orderParam = '-created';
    }

    String? filterParam;
    if (_selectedContentType == 'Exams and Quiz' ||
        _selectedContentType == 'Questions') {
      filterParam = 'question';
    }
    if (_selectedContentType == 'Videos') {
      filterParam = 'video';
    }
    if (_selectedContentType == 'PDFs') {
      filterParam = 'attachment';
    }
    if (_selectedContentType == 'Notes') {
      filterParam = 'html';
    }
    if (_selectedContentType == 'Live Classes') {
      filterParam = 'video';
    }

    final bookmarkFilter = BookmarkFilter(
      folder: folderParam,
      order: orderParam,
      filter: filterParam,
    );

    final bookmarksAsync = ref.watch(
      paginatedBookmarksProvider(filter: bookmarkFilter),
    );
    final isFetchingNextPage = ref.watch(
      paginatedBookmarksFetchingPageProvider(bookmarkFilter),
    );
    final foldersAsync = ref.watch(bookmarkFoldersProvider);

    return AppShell(
      backgroundColor: design.colors.canvas,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: design.colors.card,
                child: BookmarksHeader(
                  title: widget.folderName ?? l10n.bookmarksTitle,
                  onBack: () => Navigator.of(context).pop(),
                  showDivider: false,
                ),
              ),
              if (widget.folderName == null)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: design.colors.card,
                    border: Border(
                      bottom: BorderSide(
                        color: design.colors.divider.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterChips(design),
                      SizedBox(height: design.spacing.xs),
                      if (_activeFilter == 'folders') ...[
                        // Folders don't have search support
                      ] else if (_activeFilter == 'all') ...[
                        _buildDropdownsRow(design),
                        SizedBox(height: design.spacing.md),
                      ],
                    ],
                  ),
                ),
              Expanded(
                child: _activeFilter == 'folders'
                    ? foldersAsync.when(
                        data: (folders) => _buildFoldersList(folders, design),
                        loading: () => _buildFoldersList(
                          _dummyFolders,
                          design,
                          isLoading: true,
                        ),
                        error: (err, stack) =>
                            Center(child: Text(l10n.errorGenericTitle)),
                      )
                    : bookmarksAsync.when(
                        data: (bookmarks) => _buildBookmarksList(
                          bookmarks,
                          design,
                          bookmarkFilter: bookmarkFilter,
                          isFetchingNextPage: isFetchingNextPage,
                        ),
                        loading: () => _buildBookmarksList(
                          _dummyBookmarks,
                          design,
                          isLoading: true,
                          bookmarkFilter: bookmarkFilter,
                        ),
                        error: (err, stack) =>
                            Center(child: Text(l10n.errorGenericTitle)),
                      ),
              ),
            ],
          ),
          if (_activeFilter == 'folders' && widget.folderName == null)
            Positioned(
              bottom: design.spacing.xxl,
              right: design.spacing.lg,
              child: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    _selectedBookmark = null; // Clear selection
                    _selectedFolder = null; // Clear folder selection
                    _isCreateFolderDialogOpen = true;
                  });
                },
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(design.radius.full),
                ),
                backgroundColor: design.colors.primary,
                foregroundColor: design.colors.onPrimary,
                icon: Icon(
                  LucideIcons.folderPlus,
                  size: design.iconSize.lg,
                  color: design.colors.onPrimary,
                ),
                label: AppText.labelBold(
                  l10n.labelNewFolder,
                  color: design.colors.onPrimary,
                ),
              ),
            ),
          AppBottomSheet(
            isOpen: _isFolderOptionsOpen,
            onClose: () => setState(() => _isFolderOptionsOpen = false),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                design.spacing.sm,
                0,
                design.spacing.sm,
                design.spacing.md,
              ),
              child: SafeArea(
                top: false,
                child: Container(
                  decoration: BoxDecoration(
                    color: design.colors.card,
                    borderRadius: BorderRadius.all(
                      Radius.circular(design.radius.xxl),
                    ),
                    boxShadow: design.shadows.floating,
                  ),
                  padding: EdgeInsets.fromLTRB(
                    design.spacing.lg,
                    design.spacing.md,
                    design.spacing.lg,
                    design.spacing.lg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: design.spacing.xl * 1.5,
                        height: 4,
                        decoration: BoxDecoration(
                          color: design.colors.border,
                          borderRadius: BorderRadius.circular(
                            design.radius.full,
                          ),
                        ),
                      ),
                      SizedBox(height: design.spacing.lg),
                      _buildOption(
                        context,
                        LucideIcons.edit2,
                        l10n.bookmarkActionRenameFolder,
                        design,
                        onTap: () {
                          setState(() {
                            _isFolderOptionsOpen = false;
                            _isCreateFolderDialogOpen = true;
                          });
                        },
                      ),
                      SizedBox(height: design.spacing.md),
                      _buildOption(
                        context,
                        LucideIcons.trash2,
                        'Delete Folder',
                        design,
                        isDestructive: true,
                        onTap: () async {
                          if (_selectedFolder == null) return;

                          setState(() {
                            _isFolderOptionsOpen = false;
                          });

                          try {
                            await ref.read(
                              deleteBookmarkFolderProvider(
                                _selectedFolder!.id,
                              ).future,
                            );
                            if (context.mounted) {
                              AppToast.show(
                                context,
                                message: 'Deleted folder successfully.',
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              AppToast.show(
                                context,
                                message: 'Failed to delete folder.',
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AppBottomSheet(
            isOpen: _isBookmarkOptionsOpen,
            onClose: () => setState(() => _isBookmarkOptionsOpen = false),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                design.spacing.sm,
                0,
                design.spacing.sm,
                design.spacing.md,
              ),
              child: SafeArea(
                top: false,
                child: Container(
                  decoration: BoxDecoration(
                    color: design.colors.card,
                    borderRadius: BorderRadius.all(
                      Radius.circular(design.radius.xxl),
                    ),
                    boxShadow: design.shadows.floating,
                  ),
                  padding: EdgeInsets.fromLTRB(
                    design.spacing.lg,
                    design.spacing.md,
                    design.spacing.lg,
                    design.spacing.lg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: design.spacing.xl * 1.5,
                        height: 4,
                        decoration: BoxDecoration(
                          color: design.colors.border,
                          borderRadius: BorderRadius.circular(
                            design.radius.full,
                          ),
                        ),
                      ),
                      SizedBox(height: design.spacing.lg),
                      _buildOption(
                        context,
                        LucideIcons.folderInput,
                        'Move to Folder',
                        design,
                        onTap: () {
                          setState(() {
                            _isBookmarkOptionsOpen = false;
                            _isBookmarkFolderSheetOpen = true;
                          });
                        },
                      ),
                      SizedBox(height: design.spacing.md),
                      _buildOption(
                        context,
                        LucideIcons.trash2,
                        'Remove Bookmark',
                        design,
                        isDestructive: true,
                        onTap: () async {
                          if (_selectedBookmark == null) return;

                          setState(() {
                            _isBookmarkOptionsOpen = false;
                          });

                          try {
                            await ref.read(
                              removeBookmarkProvider(
                                bookmarkId: _selectedBookmark!.id,
                                lessonId: _selectedBookmark!.lessonId,
                              ).future,
                            );

                            if (!context.mounted) return;
                            AppToast.show(context, message: 'Bookmark removed');
                          } catch (e) {
                            if (!context.mounted) return;
                            AppToast.show(
                              context,
                              message: 'Failed to remove bookmark',
                              isError: true,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AppBottomSheet(
            isOpen: _isBookmarkFolderSheetOpen,
            onClose: () => setState(() => _isBookmarkFolderSheetOpen = false),
            child: _selectedBookmark != null
                ? BookmarkFoldersSheet(
                    lessonId: _selectedBookmark!.lessonId,
                    category: _selectedBookmark!.type,
                    parentContext: context,
                    onClose: () =>
                        setState(() => _isBookmarkFolderSheetOpen = false),
                    onCreateFolderRequest: () {
                      setState(() {
                        _isBookmarkFolderSheetOpen = false;
                        _isCreateFolderDialogOpen = true;
                      });
                    },
                  )
                : const SizedBox.shrink(),
          ),
          if (_isCreateFolderDialogOpen)
            CreateFolderDialog(
              lessonId: _selectedBookmark?.lessonId,
              category: _selectedBookmark?.type,
              initialName: _selectedFolder?.name,
              folderId: _selectedFolder?.id,
              onClose: () => setState(() {
                _isCreateFolderDialogOpen = false;
                _selectedBookmark = null; // Clear selection after closing
                _selectedFolder = null; // Clear folder selection after closing
              }),
            ),
          AppBottomSheet(
            isOpen: _isContentTypeOptionsOpen,
            onClose: () => setState(() => _isContentTypeOptionsOpen = false),
            child: _buildOptionsSheet(
              l10n.bookmarkLabelContentType,
              _contentTypes,
              _selectedContentType,
              (val) {
                setState(() {
                  _selectedContentType = val;
                  _isContentTypeOptionsOpen = false;
                });
              },
              design,
              (val) => _localizeContentType(val, context),
            ),
          ),
          AppBottomSheet(
            isOpen: _isSortOptionsOpen,
            onClose: () => setState(() => _isSortOptionsOpen = false),
            child: _buildOptionsSheet(
              l10n.bookmarkLabelSortBy,
              _sortOptions,
              _selectedSort,
              (val) {
                setState(() {
                  _selectedSort = val;
                  _isSortOptionsOpen = false;
                });
              },
              design,
              (val) => _localizeSort(val, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoldersList(
    List<BookmarkFolderDto> folders,
    DesignConfig design, {
    bool isLoading = false,
  }) {
    if (!isLoading && folders.isEmpty) {
      return _buildEmptyState(
        design: design,
        icon: LucideIcons.folder,
        title: 'No Folders Found',
        subtitle: 'Create a folder to organize your bookmarks.',
      );
    }

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        padding: EdgeInsets.all(design.spacing.md),
        itemCount: folders.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: design.spacing.sm),
        itemBuilder: (context, index) {
          return FolderItem(
            folder: {
              'id': folders[index].id,
              'name': folders[index].name,
              'count': folders[index].bookmarksCount,
            },
            onTap: () {
              if (folders[index].name.isNotEmpty) {
                // Navigate to folder contents
                Navigator.of(context).push(
                  AppRoute(
                    page: BookmarksScreen(folderName: folders[index].name),
                  ),
                );
              }
            },
            onMoreTap: () {
              if (!isLoading) {
                setState(() {
                  _selectedFolder = folders[index];
                  _isFolderOptionsOpen = true;
                });
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildBookmarksList(
    List<BookmarkDto> bookmarks,
    DesignConfig design, {
    bool isLoading = false,
    bool isFetchingNextPage = false,
    required BookmarkFilter bookmarkFilter,
  }) {
    if (!isLoading && bookmarks.isEmpty) {
      return _buildEmptyState(
        design: design,
        icon: LucideIcons.bookmark,
        title: 'No Bookmarks Found',
        subtitle: 'You haven\'t bookmarked any items yet.',
      );
    }

    return Skeletonizer(
      enabled: isLoading,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (!isLoading &&
              notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 200) {
            ref
                .read(
                  paginatedBookmarksProvider(filter: bookmarkFilter).notifier,
                )
                .loadMore();
          }
          return false;
        },
        child: ListView.separated(
          padding: EdgeInsets.all(design.spacing.md),
          itemCount: bookmarks.length + (isFetchingNextPage ? 1 : 0),
          separatorBuilder: (context, index) =>
              SizedBox(height: design.spacing.sm),
          itemBuilder: (context, index) {
            if (index == bookmarks.length) {
              return Skeletonizer(
                enabled: true,
                child: BookmarkItem(
                  item: {
                    'id': 'dummy',
                    'title': 'Loading Bookmark Title Long',
                    'chapterName': 'Loading Chapter Name',
                    'savedDate': '',
                    'contentType': 'video',
                    'thumbnailColor': design.colors.surfaceVariant,
                    'iconColor': design.colors.surfaceVariant,
                  },
                  onTap: () {},
                ),
              );
            }
            final bookmark = bookmarks[index];
            return BookmarkItem(
              item: {
                'id': bookmark.id.toString(),
                'title': bookmark.title.isNotEmpty
                    ? bookmark.title
                    : 'Unknown Lesson',
                'chapterName': bookmark.chapterName,
                'savedDate': bookmark.created != null
                    ? DateFormatter.formatFullDate(bookmark.created!)
                    : '',
                'contentType': bookmark.bookmarkType ?? bookmark.type,
                'thumbnailColor': isLoading
                    ? design.colors.surfaceVariant
                    : null,
                'iconColor': isLoading ? design.colors.surfaceVariant : null,
              },
              onTap: () => _navigateToBookmark(context, bookmark),
              onMoreTap: (!isLoading)
                  ? () {
                      setState(() {
                        _selectedBookmark = bookmark;
                        _isBookmarkOptionsOpen = true;
                      });
                    }
                  : null,
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptionsSheet(
    String title,
    List<String> options,
    String currentValue,
    Function(String) onSelected,
    DesignConfig design,
    String Function(String) localize,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        design.spacing.sm,
        0,
        design.spacing.sm,
        design.spacing.md,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.all(Radius.circular(design.radius.xxl)),
            boxShadow: design.shadows.floating,
          ),
          padding: EdgeInsets.fromLTRB(
            design.spacing.lg,
            design.spacing.md,
            design.spacing.lg,
            design.spacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: design.spacing.xl * 1.5,
                  height: 4,
                  decoration: BoxDecoration(
                    color: design.colors.border,
                    borderRadius: BorderRadius.circular(design.radius.full),
                  ),
                ),
              ),
              SizedBox(height: design.spacing.lg),
              AppText.subtitle(
                title,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: design.spacing.sm),
              ...options.map((option) {
                final isSelected = option == currentValue;
                return AppFocusable(
                  onTap: () => onSelected(option),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: design.spacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.body(
                          localize(option),
                          color: isSelected
                              ? design.colors.accent2
                              : design.colors.textPrimary,
                        ),
                        if (isSelected)
                          Icon(
                            LucideIcons.check,
                            color: design.colors.accent2,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    IconData icon,
    String label,
    DesignConfig design, {
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return AppFocusable(
      onTap:
          onTap ??
          () {
            setState(() => _isFolderOptionsOpen = false);
          },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: design.spacing.md),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive
                  ? design.colors.error
                  : design.colors.textPrimary,
              size: 20,
            ),
            SizedBox(width: design.spacing.md),
            AppText.bodySmall(
              label,
              color: isDestructive
                  ? design.colors.error
                  : design.colors.textPrimary,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(DesignConfig design) {
    final filters = const ['All', 'Folders', 'Uncategorized'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      child: Row(
        children: filters.map((filter) {
          final filterId = filter.toLowerCase();
          final isActive = _activeFilter == filterId;
          return Padding(
            padding: EdgeInsets.only(right: design.spacing.sm),
            child: _FilterChip(
              label: filter,
              isSelected: isActive,
              onTap: () {
                setState(() {
                  _activeFilter = filterId;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDropdownsRow(DesignConfig design) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown(
              _localizeContentType(_selectedContentType, context),
              () => setState(() => _isContentTypeOptionsOpen = true),
              design,
            ),
          ),
          SizedBox(width: design.spacing.sm),
          Expanded(
            child: _buildDropdown(
              _localizeSort(_selectedSort, context),
              () => setState(() => _isSortOptionsOpen = true),
              design,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String value, VoidCallback onTap, DesignConfig design) {
    return AppFocusable(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: design.colors.card,
          border: Border.all(color: design.colors.border),
          borderRadius: BorderRadius.circular(design.radius.sm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.labelSmall(value),
            Icon(
              LucideIcons.chevronDown,
              size: 16,
              color: design.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required DesignConfig design,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: design.colors.textTertiary.withValues(alpha: 0.2),
          ),
          SizedBox(height: design.spacing.lg),
          AppText.headline(title, color: design.colors.textSecondary),
          SizedBox(height: design.spacing.xs),
          AppText.body(
            subtitle,
            color: design.colors.textTertiary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppSemantics.button(
      label: label,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? design.colors.primary
                : design.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(design.radius.full),
          ),
          child: AppText.bodySmall(
            label,
            color: isSelected
                ? design.colors.textInverse
                : design.colors.textPrimary,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
