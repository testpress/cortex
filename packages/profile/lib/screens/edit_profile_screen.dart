import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;
  String? _selectedAvatarPath;
  Uint8List? _selectedAvatarBytes;
  bool _isAvatarRemoved = false;
  bool _isAvatarSheetOpen = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider).value;

    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedAvatarPath = image.path;
        _selectedAvatarBytes = bytes;
        _isAvatarRemoved = false;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateAndSave() async {
    final l10n = L10n.of(context);
    setState(() {
      _firstNameError = _firstNameController.text.trim().isEmpty
          ? l10n.editProfileErrorNameEmpty
          : null;
      _lastNameError = null;
      _phoneError = null;
      _errorMessage = null;
    });

    if (_firstNameError == null) {
      final isLoggedIn = ref.read(authProvider).asData?.value ?? false;
      if (!isLoggedIn) return;

      if (_isSaving) return;
      setState(() => _isSaving = true);

      try {
        await ref
            .read(userActionsControllerProvider.notifier)
            .updateProfile(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              phone: _phoneController.text.trim(),
              photo: _selectedAvatarPath,
              removePhoto: _isAvatarRemoved,
            );

        if (mounted) context.pop(true);
      } catch (e, stack) {
        if (e is! ApiException) {
          ref
              .read(sentryServiceProvider)
              .captureException(e, stackTrace: stack);
        }

        if (mounted) {
          if (e is ApiException && e.data is Map) {
            final data = (e.data as Map).cast<String, dynamic>();

            String? getFieldError(String key) {
              final value = data[key];
              if (value is List && value.isNotEmpty) {
                return value.first.toString();
              }
              if (value is String && value.isNotEmpty) return value;
              return null;
            }

            final phoneErr = getFieldError('phone');
            final firstErr = getFieldError('first_name');
            final lastErr = getFieldError('last_name');
            final generalErr =
                getFieldError('non_field_errors') ??
                getFieldError('detail') ??
                getFieldError('message');

            setState(() {
              _phoneError = phoneErr;
              _firstNameError = firstErr ?? _firstNameError;
              _lastNameError = lastErr ?? _lastNameError;

              if (generalErr != null) {
                _errorMessage = generalErr;
              } else if (phoneErr == null &&
                  firstErr == null &&
                  lastErr == null) {
                _errorMessage = e.message;
              } else {
                _errorMessage = null;
              }
            });
          } else {
            setState(
              () =>
                  _errorMessage = e is ApiException ? e.message : e.toString(),
            );
          }
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userProvider, (previous, next) {
      final user = next.value;
      if (user != null &&
          _firstNameController.text.isEmpty &&
          _lastNameController.text.isEmpty) {
        _firstNameController.text = user.firstName ?? '';
        _lastNameController.text = user.lastName ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = user.phone ?? '';
      }
    });

    final design = Design.of(context);
    final l10n = L10n.of(context);
    final padding = MediaQuery.paddingOf(context);

    final viewInsets = MediaQuery.viewInsetsOf(context);

    return AppShell(
      backgroundColor: design.colors.canvas,
      bottomSheet: _buildAvatarSheet(design, l10n),
      child: Padding(
        padding: EdgeInsets.only(bottom: viewInsets.bottom),
        child: Column(
          children: [
            AppHeader(
              title: l10n.editProfileTitle,
              leading: AppBackButton(onTap: () => context.pop()),
            ),
            Expanded(
              child: AppScroll(
                padding: EdgeInsets.fromLTRB(
                  padding.left > design.spacing.md
                      ? padding.left
                      : design.spacing.md,
                  design.spacing.md,
                  padding.right > design.spacing.md
                      ? padding.right
                      : design.spacing.md,
                  design.spacing.lg,
                ),
                children: [
                  if (_errorMessage != null) ...[
                    SizedBox(height: design.spacing.md),
                    AppText.bodySmall(
                      _errorMessage!,
                      color: design.colors.error,
                    ),
                  ],
                  SizedBox(height: design.spacing.sm),
                  _buildAvatarSection(design, l10n),
                  SizedBox(height: design.spacing.lg),
                  AppTextField(
                    label: l10n.editProfileFirstNameLabel,
                    hintText: l10n.editProfileFirstNameHint,
                    controller: _firstNameController,
                    errorText: _firstNameError,
                    onChanged: (_) {
                      if (_firstNameError != null) {
                        setState(() => _firstNameError = null);
                      }
                    },
                  ),
                  SizedBox(height: design.spacing.lg),
                  AppTextField(
                    label: l10n.editProfileLastNameLabel,
                    hintText: l10n.editProfileLastNameHint,
                    controller: _lastNameController,
                    errorText: _lastNameError,
                    onChanged: (_) {
                      if (_lastNameError != null) {
                        setState(() => _lastNameError = null);
                      }
                    },
                  ),
                  SizedBox(height: design.spacing.lg),
                  AppTextField(
                    label: l10n.editProfileEmailLabel,
                    hintText: l10n.editProfileEmailHint,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                    helperText: l10n.editProfileEmailHelper,
                  ),
                  SizedBox(height: design.spacing.lg),
                  AppTextField(
                    label: l10n.editProfilePhoneLabel,
                    hintText: l10n.editProfilePhoneHint,
                    controller: _phoneController,
                    errorText: _phoneError,
                    keyboardType: TextInputType.phone,
                    onChanged: (_) {
                      if (_phoneError != null) {
                        setState(() => _phoneError = null);
                      }
                    },
                  ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  padding.left > design.spacing.md
                      ? padding.left
                      : design.spacing.md,
                  design.spacing.md,
                  padding.right > design.spacing.md
                      ? padding.right
                      : design.spacing.md,
                  design.spacing.md,
                ),
                decoration: BoxDecoration(
                  color: design.colors.surface,
                  border: Border(top: BorderSide(color: design.colors.divider)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton.secondary(
                        label: l10n.labelCancel,
                        fullWidth: true,
                        height: 48,
                        onPressed: _isSaving ? null : () => context.pop(),
                        backgroundColor: design.colors.surfaceVariant,
                        foregroundColor: design.colors.textPrimary,
                        borderColor: const Color(0x00000000),
                      ),
                    ),
                    SizedBox(width: design.spacing.md),
                    Expanded(
                      child: AppButton(
                        label: l10n.editProfileSave,
                        onPressed: _validateAndSave,
                        loading: _isSaving,
                        fullWidth: true,
                        height: 48,
                        backgroundColor: design.colors.primary,
                        foregroundColor: design.colors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasCustomAvatar(String? avatarUrl) {
    if (avatarUrl == null || avatarUrl.trim().isEmpty) return false;
    return !avatarUrl.contains('default_');
  }

  Widget _buildAvatarSection(DesignConfig design, dynamic l10n) {
    final user = ref.watch(userProvider).value;
    if (user == null) return const SizedBox.shrink();

    final hasNetworkAvatar =
        !_isAvatarRemoved && user.avatar != null && user.avatar!.isNotEmpty;

    final displayName = _getUserDisplayName(user);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.label(l10n.editProfilePhotoLabel),
        SizedBox(height: design.spacing.md),
        Center(
          child: GestureDetector(
            onTap: () => setState(() => _isAvatarSheetOpen = true),
            child: Stack(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: design.colors.primary,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _selectedAvatarBytes != null && !_isAvatarRemoved
                      ? Image.memory(_selectedAvatarBytes!, fit: BoxFit.cover)
                      : (hasNetworkAvatar
                            ? Image.network(
                                user.avatar!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildInitialsAvatar(displayName, design),
                              )
                            : _buildInitialsAvatar(displayName, design)),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: design.colors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: design.colors.card, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: design.colors.shadow,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.pencil,
                        size: 16,
                        color: design.colors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarSheet(DesignConfig design, dynamic l10n) {
    final user = ref.watch(userProvider).value;
    final hasCustomSavedAvatar = _hasCustomAvatar(user?.avatar);
    final hasAvatar =
        !_isAvatarRemoved &&
        (_selectedAvatarBytes != null || hasCustomSavedAvatar);

    return AppBottomSheet(
      isOpen: _isAvatarSheetOpen,
      onClose: () => setState(() => _isAvatarSheetOpen = false),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                AppText.title(
                  l10n.editProfileAvatarSheetTitle,
                  color: design.colors.textPrimary,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: design.spacing.md),
                _buildSheetOption(
                  icon: LucideIcons.camera,
                  label: l10n.editProfileCamera,
                  design: design,
                  onTap: () {
                    setState(() => _isAvatarSheetOpen = false);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildSheetOption(
                  icon: LucideIcons.image,
                  label: l10n.editProfileGallery,
                  design: design,
                  onTap: () {
                    setState(() => _isAvatarSheetOpen = false);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (hasAvatar)
                  _buildSheetOption(
                    icon: LucideIcons.trash2,
                    label: l10n.editProfileRemovePhoto,
                    design: design,
                    isDestructive: true,
                    onTap: () {
                      setState(() {
                        _isAvatarSheetOpen = false;
                        _selectedAvatarPath = null;
                        _selectedAvatarBytes = null;
                        _isAvatarRemoved = true;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSheetOption({
    required IconData icon,
    required String label,
    required DesignConfig design,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? design.colors.error
        : design.colors.textPrimary;
    return AppFocusable(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: design.spacing.md),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            SizedBox(width: design.spacing.md),
            AppText.bodySmall(
              label,
              color: color,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  String _getUserDisplayName(UsersTableData user) {
    if (user.name != null && user.name!.trim().isNotEmpty) {
      return user.name!.trim();
    }
    final combined = '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
    if (combined.isNotEmpty) return combined;
    return user.email ?? '';
  }

  Widget _buildInitialsAvatar(String name, DesignConfig design) {
    final trimmed = name.trim();
    final initials = trimmed.isNotEmpty
        ? trimmed
              .split(RegExp(r'\s+'))
              .take(2)
              .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
              .join()
        : '?';
    return Center(
      child: AppText.headline(
        initials.isEmpty ? '?' : initials,
        color: design.colors.onPrimary,
      ),
    );
  }
}
