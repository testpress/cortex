import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

import '../providers/user_provider.dart';

const double _kHeaderContentHeight = 60.0;

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
  String? _selectedAvatarPath;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider).value;
    
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _selectedAvatarPath = image.path;
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
      _lastNameError = _lastNameController.text.trim().isEmpty
          ? l10n.editProfileErrorNameEmpty
          : null;
    });

    if (_firstNameError == null && _lastNameError == null) {
      final isLoggedIn = ref.read(authProvider).asData?.value ?? false;
      if (!isLoggedIn) return;

      try {
        await ref.read(userActionsControllerProvider.notifier).updateProfile(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              phone: _phoneController.text.trim(),
              photo: _selectedAvatarPath,
            );
        
        if (mounted) context.pop(true);
      } catch (e) {
        // Error handling can be added here (e.g., showing a snackbar)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    // Padding for bottom area to handle safe area and consistent spacing
    final bottomPadding =
        MediaQuery.of(context).padding.bottom + design.spacing.lg;

    return ColoredBox(
      color: design.colors.canvas,
      child: Column(
        children: [
          _buildHeader(context, design, l10n),
          Expanded(
            child: AppScroll(
              padding: EdgeInsets.only(
                left: design.spacing.md,
                right: design.spacing.md,
                top: design.spacing.md,
                bottom: bottomPadding,
              ),
              children: [
                AppText.headline(l10n.editProfileTitle),
                SizedBox(height: design.spacing.xl),
                _buildAvatarSection(design, l10n),
                SizedBox(height: design.spacing.xxl),
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
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DesignConfig design, dynamic l10n) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Container(
      width: double.infinity,
      // Total height = status bar + content bar height
      height: statusBarHeight + _kHeaderContentHeight,
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(
          bottom: BorderSide(color: design.colors.border, width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Container(
          // Inner container for the interactive elements
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button - Standardized with Study Page
              AppSemantics.button(
                label: l10n.editProfileBack,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.pop(),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.chevronLeft,
                          size: design.iconSize.md,
                          color: design.colors.textPrimary,
                        ),
                        SizedBox(width: design.spacing.xs),
                        AppText.label(
                          l10n.editProfileBack,
                          color: design.colors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Save Button - Explicitly constrained height
              SizedBox(
                height: 36,
                child: AppButton(
                   label: l10n.editProfileSave,
                   onPressed: _validateAndSave,
                   padding: EdgeInsets.symmetric(horizontal: design.spacing.lg),
                   backgroundColor: design.colors.accent2,
                   foregroundColor: design.colors.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(DesignConfig design, dynamic l10n) {
    final user = ref.watch(userProvider).value;
    if (user == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.label(l10n.editProfilePhotoLabel),
        SizedBox(height: design.spacing.sm),
        Row(
          children: [
            GestureDetector(
              onTap: _pickAndUploadImage,
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: design.colors.accent2,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _selectedAvatarPath != null
                        ? Image.file(
                            File(_selectedAvatarPath!),
                            fit: BoxFit.cover,
                          )
                        : (user.avatar != null && user.avatar!.isNotEmpty
                            ? Image.network(
                                user.avatar!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildInitialsAvatar(user.name ?? '', design),
                              )
                            : _buildInitialsAvatar(user.name ?? '', design)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: design.colors.accent2,
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
                          LucideIcons.camera,
                          size: 14,
                          color: design.colors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: design.spacing.lg),
            AppButton(
              label: l10n.editProfileChangePhoto,
              onPressed: _pickAndUploadImage,
              backgroundColor: design.colors.surfaceVariant,
              foregroundColor: design.colors.textPrimary,
              height: 36,
              padding: EdgeInsets.symmetric(horizontal: design.spacing.lg),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInitialsAvatar(String name, DesignConfig design) {
     final initials = name.isNotEmpty
         ? name.split(' ').take(2).map((e) => e.isNotEmpty ? e[0].toUpperCase() : '').join()
         : '?';
     return Center(
       child: AppText.headline(
          initials,
          color: design.colors.onPrimary,
       ),
     );
  }
}
