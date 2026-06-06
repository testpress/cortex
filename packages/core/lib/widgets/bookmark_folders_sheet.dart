import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show TextInputAction;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core.dart';
import '../data/providers/bookmark_provider.dart';
import '../data/models/bookmark_dto.dart';

/// A premium, platform-neutral bottom sheet widget that displays a list of
/// bookmark folders, letting the user add/remove a lesson from them.
class BookmarkFoldersSheet extends ConsumerStatefulWidget {
  const BookmarkFoldersSheet({
    super.key,
    required this.lessonId,
    required this.category,
    required this.onClose,
    required this.onCreateFolderRequest,
    required this.parentContext,
  });

  final int lessonId;
  final String category;
  final VoidCallback onClose;
  final VoidCallback onCreateFolderRequest;

  /// A stable context from the parent screen (e.g. orchestrator) that
  /// remains mounted after this sheet is dismissed. Used for toast display.
  final BuildContext parentContext;

  @override
  ConsumerState<BookmarkFoldersSheet> createState() => _BookmarkFoldersSheetState();
}

class _BookmarkFoldersSheetState extends ConsumerState<BookmarkFoldersSheet> {
  final ScrollController _scrollController = ScrollController();
  
  // No background state variables needed as sheet dismisses instantly like YouTube.

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _toggleBookmark({
    required List<BookmarkDto> existingBookmarks,
    required String? folderName,
  }) async {
    // 1. Close the bottom sheet instantly (YouTube-style)
    widget.onClose();

    final l10n = L10n.of(widget.parentContext);

    // 2. Show optimistic toast using the parent's stable context
    final toastMessage = existingBookmarks.isNotEmpty
        ? l10n.bookmarkRemoved
        : l10n.bookmarkAddedToFolder(folderName ?? l10n.labelUncategorized);
    AppToast.show(
      widget.parentContext,
      message: toastMessage,
    );

    // 3. Fire the API call in the background
    try {
      if (existingBookmarks.isNotEmpty) {
        for (final b in existingBookmarks) {
          await ref.read(removeBookmarkProvider(
            bookmarkId: b.id,
            lessonId: widget.lessonId,
          ).future);
        }
      } else {
        await ref.read(addBookmarkProvider(
          category: widget.category,
          lessonId: widget.lessonId,
          folder: folderName,
        ).future);
      }
    } catch (e, stack) {
      debugPrint('Error updating bookmark: $e\n$stack');
      if (widget.parentContext.mounted) {
        AppToast.show(
          widget.parentContext,
          message: L10n.of(widget.parentContext).errorFailedToUpdateBookmark,
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final foldersAsync = ref.watch(bookmarkFoldersProvider);
    final bookmarksAsync = ref.watch(bookmarksForLessonProvider(widget.lessonId));

    return Padding(
      padding: EdgeInsets.fromLTRB(
        design.spacing.sm,
        0,
        design.spacing.sm,
        design.spacing.md,
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                design.spacing.lg,
                design.spacing.md,
                design.spacing.lg,
                design.spacing.lg,
              ),
              decoration: BoxDecoration(
                color: design.colors.card,
                borderRadius: BorderRadius.all(
                  Radius.circular(design.radius.xxl),
                ),
                boxShadow: design.shadows.floating,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
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

                  // Header Section
                  AppSemantics.header(
                    label: L10n.of(context).bookmarkSaveToFolders,
                    child: AppText.title(
                      L10n.of(context).bookmarkSaveTo,
                      color: design.colors.textPrimary,
                    ),
                  ),

                  SizedBox(height: design.spacing.md),

                  // Folders List
                  Flexible(
                    child: foldersAsync.when(
                      data: (folders) {
                        return bookmarksAsync.when(
                          data: (activeBookmarks) {
                            // 1. Check if lesson has "Uncategorized" bookmark (folderId == null)
                            final uncategorizedBookmarks = activeBookmarks.where(
                              (b) => b.folderId == null,
                            ).toList();

                            return ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                              child: RawScrollbar(
                                controller: _scrollController,
                                thumbVisibility: true,
                                thickness: 4.0,
                                radius: Radius.circular(design.radius.full),
                                thumbColor: design.colors.textSecondary.withValues(alpha: 0.3),
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  child: Padding(
                                    // Add minor right padding so scrollbar doesn't overlap rows
                                    padding: EdgeInsets.only(right: design.spacing.sm),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Uncategorized row (Hardcoded at the top)
                                        _buildFolderRow(
                                          title: L10n.of(context).labelUncategorized,
                                          isChecked: uncategorizedBookmarks.isNotEmpty,
                                          onTap: () => _toggleBookmark(
                                            existingBookmarks: uncategorizedBookmarks,
                                            folderName: null,
                                          ),
                                          design: design,
                                        ),

                                        // Dynamic User folders
                                        ...folders.map((folder) {
                                          final folderBookmarks = activeBookmarks.where(
                                            (b) => b.folderId == folder.id,
                                          ).toList();

                                          return _buildFolderRow(
                                            title: folder.name,
                                            isChecked: folderBookmarks.isNotEmpty,
                                            onTap: () => _toggleBookmark(
                                              existingBookmarks: folderBookmarks,
                                              folderName: folder.name,
                                            ),
                                            design: design,
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          loading: () => _buildLoadingState(design),
                          error: (err, stack) => _buildErrorState(design),
                        );
                      },
                      loading: () => _buildLoadingState(design),
                      error: (err, stack) => _buildErrorState(design),
                    ),
                  ),

                  // Inline Create Folder Area
                  Container(
                    height: 1,
                    color: design.colors.border,
                    margin: EdgeInsets.only(
                      top: design.spacing.sm,
                      bottom: design.spacing.md,
                    ),
                  ),
                  _buildCreateFolderButton(design),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderRow({
    required String title,
    required bool isChecked,
    required VoidCallback onTap,
    required DesignConfig design,
  }) {
    return AppSemantics.button(
      label: '$title, ${isChecked ? 'selected' : 'unselected'}',
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: design.spacing.md),
          child: Row(
            children: [
              Icon(
                LucideIcons.folder,
                size: design.iconSize.md,
                color: isChecked ? design.colors.primary : design.colors.textSecondary,
              ),
              SizedBox(width: design.spacing.md),
              Expanded(
                child: isChecked
                    ? AppText.labelBold(
                        title,
                        color: design.colors.primary,
                        overflow: TextOverflow.ellipsis,
                      )
                    : AppText.body(
                        title,
                        color: design.colors.textPrimary,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateFolderButton(DesignConfig design) {
    final l10n = L10n.of(context);
    return AppSemantics.button(
      label: l10n.actionCreateNewFolder,
      onTap: widget.onCreateFolderRequest,
      child: GestureDetector(
        onTap: widget.onCreateFolderRequest,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: design.spacing.md),
          child: Row(
            children: [
              Icon(
                LucideIcons.plus,
                size: design.iconSize.sm,
                color: design.colors.accent2,
              ),
              SizedBox(width: design.spacing.sm),
              AppText.labelBold(
                l10n.actionCreateNewFolder,
                color: design.colors.accent2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(DesignConfig design) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: const AppLoadingIndicator(),
    );
  }

  Widget _buildErrorState(DesignConfig design) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: AppText.body(
        L10n.of(context).errorFailedToLoadFolders,
        color: design.colors.textSecondary,
      ),
    );
  }
}

/// A premium modal dialog to create a new folder and bookmark a lesson in it.
class CreateFolderDialog extends ConsumerStatefulWidget {
  const CreateFolderDialog({
    super.key,
    this.lessonId,
    this.category,
    this.initialName,
    this.folderId,
    required this.onClose,
  });

  final int? lessonId;
  final String? category;
  final String? initialName;
  final int? folderId;
  final VoidCallback onClose;

  bool get isRenameMode => folderId != null;

  @override
  ConsumerState<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends ConsumerState<CreateFolderDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) {
      _nameController.text = widget.initialName!;
    }
    _nameController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onTextChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // Rebuild to update Save button visibility dynamically
    setState(() {});
  }

  Future<void> _saveFolder() async {
    final folderName = _nameController.text.trim();
    if (folderName.isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (widget.isRenameMode) {
        await ref.read(updateBookmarkFolderProvider(
          widget.folderId!,
          folderName,
        ).future);
      } else {
        // 1. Create the folder on server and save locally
        final newFolder = await ref.read(createBookmarkFolderProvider(folderName).future);

        // 2. Automatically select it for the current lesson if provided
        if (widget.lessonId != null && widget.category != null) {
          await ref.read(addBookmarkProvider(
            category: widget.category!,
            lessonId: widget.lessonId!,
            folder: newFolder.name,
          ).future);
        }
      }

      if (mounted) {
        widget.onClose();
      }
    } catch (e, stack) {
      debugPrint('Error saving folder: $e\n$stack');
      if (mounted) {
        setState(() {
          _errorMessage = widget.isRenameMode ? 'Failed to rename folder.' : L10n.of(context).errorFailedToCreateFolder;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final hasText = _nameController.text.trim().isNotEmpty;

    return Stack(
      children: [
        // Backdrop overlay
        GestureDetector(
          onTap: widget.onClose,
          child: Container(
            color: design.colors.overlay,
          ),
        ),
        // Centered dialog with keyboard avoidance
        Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                design.spacing.lg,
                design.spacing.lg,
                design.spacing.lg,
                design.spacing.lg + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 360),
                padding: EdgeInsets.all(design.spacing.lg),
                decoration: BoxDecoration(
                  color: design.colors.card,
                  borderRadius: BorderRadius.circular(design.radius.xl),
                  boxShadow: design.shadows.floating,
                  border: Border.all(
                    color: design.colors.border,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.title(
                      widget.isRenameMode ? L10n.of(context).bookmarkActionRenameFolder : L10n.of(context).labelNewFolder,
                      color: design.colors.textPrimary,
                    ),
                    if (_errorMessage != null) ...[
                      SizedBox(height: design.spacing.xs),
                      AppText.labelSmall(
                        _errorMessage!,
                        color: design.colors.error,
                      ),
                    ],
                    SizedBox(height: design.spacing.md),
                    AppTextField(
                      label: L10n.of(context).hintEnterFolderName,
                      hintText: L10n.of(context).hintExampleFolderName,
                      controller: _nameController,
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => hasText ? _saveFolder() : null,
                    ),
                    SizedBox(height: design.spacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton.primary(
                            label: L10n.of(context).labelCancel,
                            fullWidth: true,
                            onPressed: widget.onClose,
                            backgroundColor: design.colors.surfaceVariant,
                            foregroundColor: design.colors.textPrimary,
                            height: 52,
                          ),
                        ),
                        SizedBox(width: design.spacing.md),
                        Expanded(
                          child: AppButton.primary(
                            label: L10n.of(context).labelSave,
                            fullWidth: true,
                            loading: _isLoading,
                            onPressed: (hasText && !_isLoading) ? _saveFolder : null,
                            backgroundColor: (hasText && !_isLoading)
                                ? design.colors.accent2
                                : design.colors.accent2.withValues(alpha: 0.5),
                            foregroundColor: (hasText && !_isLoading)
                                ? design.colors.textInverse
                                : design.colors.textInverse.withValues(alpha: 0.9),
                            height: 52,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
