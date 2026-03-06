import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    this.avatarUrl,
    this.membershipText = 'Learning with us since August 2025',
  });

  final String name;
  final String? avatarUrl;
  final String membershipText;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
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
                  AppText.xl(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: design.spacing.xs),
                  AppText.caption(
                    membershipText,
                    color: design.colors.textSecondary,
                    textAlign: TextAlign.center,
                  ),
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
    );
  }
}
