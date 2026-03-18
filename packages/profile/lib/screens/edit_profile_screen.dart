import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

const double _kHeaderContentHeight = 60.0;

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).effectiveUser;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email ?? '');
    _phoneController = TextEditingController(text: user.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateAndSave() {
    final l10n = L10n.of(context);
    setState(() {
      _nameError = _nameController.text.trim().isEmpty
          ? l10n.editProfileErrorNameEmpty
          : null;
    });

    if (_nameError == null) {
      final user = ref.read(authProvider).effectiveUser;
      final updatedUser = UserDto(
        id: user.id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        avatar: user.avatar,
        isPro: user.isPro,
        joinedDate: user.joinedDate,
      );

      ref.read(authProvider.notifier).updateProfile(updatedUser);
      context.pop(true);
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
                  label: l10n.editProfileNameLabel,
                  hintText: l10n.editProfileNameHint,
                  controller: _nameController,
                  errorText: _nameError,
                  onChanged: (_) {
                    if (_nameError != null) setState(() => _nameError = null);
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
    final user = ref.read(authProvider).effectiveUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.label(l10n.editProfilePhotoLabel),
        SizedBox(height: design.spacing.sm),
        Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: design.colors.accent2,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: user.avatar != null && user.avatar!.isNotEmpty
                      ? Image.network(
                          user.avatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildInitialsAvatar(user.name, design),
                        )
                      : _buildInitialsAvatar(user.name, design),
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
            SizedBox(width: design.spacing.lg),
            AppButton(
              label: l10n.editProfileChangePhoto,
              onPressed: () {},
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
        ? name
              .split(' ')
              .take(2)
              .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
              .join()
        : '?';
    return Center(
      child: AppText.headline(initials, color: design.colors.onPrimary),
    );
  }
}
