import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

import 'package:intl/intl.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    this.avatarUrl,
    this.joinedDate,
    this.onEditProfileTap,
  });

  final String name;
  final String? avatarUrl;
  final DateTime? joinedDate;
  final VoidCallback? onEditProfileTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: AppFocusable(
        onTap: onEditProfileTap,
        child: AppCard(
          showShadow: true,
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: design.spacing.xl,
                  horizontal: design.spacing.md,
                ),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: avatarUrl != null && avatarUrl!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(avatarUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: design.colors.surfaceVariant,
                        ),
                        child: avatarUrl == null || avatarUrl!.isEmpty
                            ? Center(
                                child: AppText.xl2(
                                  name.isNotEmpty ? name[0] : '?',
                                  color: design.colors.textSecondary,
                                ),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: design.spacing.lg),
                    AppText.headline(name, textAlign: TextAlign.center),
                    if (joinedDate != null) ...[
                      SizedBox(height: design.spacing.xs),
                      AppText.caption(
                        L10n.of(context).profileMembershipLabel(
                          DateFormat.yMMMM().format(joinedDate!),
                        ),
                        color: design.colors.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              Positioned(
                right: design.spacing.md,
                top: design.spacing.md,
                child: Container(
                  padding: EdgeInsets.all(design.spacing.sm),
                  decoration: BoxDecoration(
                    color: design.colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.pencil,
                    size: design.iconSize.sm,
                    color: design.colors.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
