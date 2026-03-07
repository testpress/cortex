import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../models/certificate.dart';

class CertificatePreviewScreen extends StatelessWidget {
  const CertificatePreviewScreen({
    super.key,
    required this.certificate,
    required this.onClose,
    this.onDownload,
    this.onShare,
  });

  final CourseCertificate certificate;
  final VoidCallback onClose;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return ColoredBox(
      color: design.colors.canvas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PreviewHeader(onClose: onClose),
          Expanded(
            child: AppScroll(
              padding: EdgeInsets.fromLTRB(
                design.spacing.md,
                design.spacing.lg,
                design.spacing.md,
                design.spacing.xxl,
              ),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          design.layout.tabletBreakpoint + design.spacing.xxl,
                    ),
                    child: _CertificatePreviewCard(certificate: certificate),
                  ),
                ),
                SizedBox(height: design.spacing.lg),
                Container(
                  decoration: BoxDecoration(
                    color: design.colors.accent2.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(design.radius.lg),
                    border: Border.all(
                      color: design.colors.accent2.withValues(alpha: 0.28),
                    ),
                  ),
                  padding: EdgeInsets.all(design.spacing.md),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: design.spacing.xl,
                        height: design.spacing.xl,
                        decoration: BoxDecoration(
                          color: design.colors.accent2,
                          borderRadius: BorderRadius.circular(design.radius.md),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          LucideIcons.award,
                          size: design.iconSize.sm,
                          color: design.colors.onPrimary,
                        ),
                      ),
                      SizedBox(width: design.spacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.label(
                              l10n.certificatesShareAchievementTitle,
                              color: design.colors.accent2,
                            ),
                            SizedBox(height: design.spacing.xs / 2),
                            AppText.caption(
                              l10n.certificatesShareAchievementDescription,
                              color: design.colors.accent2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: design.spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppButton.primary(
                        label: l10n.certificatesDownload,
                        height: 48.0,
                        backgroundColor: design.colors.accent2,
                        leading: Icon(
                          LucideIcons.download,
                          size: design.iconSize.sm,
                          color: design.colors.onPrimary,
                        ),
                        onPressed: onDownload,
                      ),
                    ),
                    SizedBox(width: design.spacing.sm),
                    Expanded(
                      child: AppButton.secondary(
                        label: l10n.certificatesShare,
                        height: 48.0,
                        leading: Icon(
                          LucideIcons.share2,
                          size: design.iconSize.sm,
                          color: design.colors.textPrimary,
                        ),
                        onPressed: onShare,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: design.spacing.md),
                AppText.caption(
                  l10n.certificatesHelpText,
                  color: design.colors.textSecondary,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewHeader extends StatelessWidget {
  const _PreviewHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final padding = MediaQuery.of(context).padding;

    return Container(
      padding: EdgeInsets.only(
        top: padding.top + design.spacing.md,
        bottom: design.spacing.md,
        left: design.spacing.md,
        right: design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.isDark ? design.colors.surface : design.colors.card,
        border: Border(bottom: BorderSide(color: design.colors.border)),
      ),
      child: Row(
        children: [
          AppSemantics.button(
            label: l10n.commonCloseButton,
            onTap: onClose,
            child: AppFocusable(
              onTap: onClose,
              borderRadius: design.radius.button,
              child: Container(
                width: design.spacing.xxl,
                height: design.spacing.xxl,
                alignment: Alignment.center,
                child: Icon(
                  LucideIcons.x,
                  size: design.iconSize.md,
                  color: design.colors.textPrimary,
                ),
              ),
            ),
          ),
          Expanded(
            child: AppText.label(
              l10n.certificatesPreviewTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(width: design.spacing.xxl),
        ],
      ),
    );
  }
}

class _CertificatePreviewCard extends StatelessWidget {
  const _CertificatePreviewCard({required this.certificate});

  final CourseCertificate certificate;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final locale = l10n.localeName;
    final completionDate = certificate.completionDate;
    final dateText = completionDate == null
        ? ''
        : DateFormat.yMMMMd(locale).format(completionDate);
    final awardedText = l10n.certificatesAwardedOn(dateText);

    return AppCard(
      showShadow: true,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: design.radius.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: design.spacing.md - design.spacing.xs,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    design.colors.accent2,
                    design.colors.accent1,
                    design.colors.accent4,
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                design.spacing.xl,
                design.spacing.xl + design.spacing.xs,
                design.spacing.xl,
                design.spacing.xl,
              ),
              child: Column(
                children: [
                  Container(
                    width: design.spacing.xxl + design.spacing.xl,
                    height: design.spacing.xxl + design.spacing.xl,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          design.colors.accent4.withValues(alpha: 0.8),
                          design.colors.accent4,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(design.radius.xl),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      LucideIcons.shieldCheck,
                      size: design.iconSize.xl + design.iconSize.sm,
                      color: design.colors.textInverse,
                    ),
                  ),
                  SizedBox(height: design.spacing.lg),
                  AppText.caption(
                    l10n.certificatesCertificateOfCompletion.toUpperCase(),
                    color: design.colors.textSecondary,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: design.spacing.xs,
                    ),
                  ),
                  SizedBox(height: design.spacing.sm + design.spacing.xs),
                  Container(
                    height: design.spacing.xs / 4,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: design.spacing.xxl),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          design.colors.border.withValues(alpha: 0.0),
                          design.colors.border,
                          design.colors.border.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: design.spacing.xl),
                  AppText.subtitle(
                    l10n.certificatesCertifyLine,
                    color: design.colors.textSecondary,
                  ),
                  SizedBox(height: design.spacing.xs),
                  AppText.xl2(
                    certificate.studentName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: design.spacing.sm),
                  Container(
                    height: design.spacing.xs / 4,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: design.spacing.xxl),
                    color: design.colors.border,
                  ),
                  SizedBox(height: design.spacing.lg),
                  AppText.subtitle(
                    l10n.certificatesCompletedCourseLine,
                    color: design.colors.textSecondary,
                  ),
                  SizedBox(height: design.spacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                      child: AppText.title(
                        certificate.course.title.trim(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: design.spacing.lg),
                  Text.rich(
                    _awardedTextSpan(
                      awardedText: awardedText,
                      dateText: dateText,
                      baseStyle: design.typography.subtitle.copyWith(
                        color: design.colors.textSecondary,
                      ),
                      boldStyle: design.typography.subtitle.copyWith(
                        color: design.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: design.spacing.lg),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: design.spacing.lg,
                      bottom: design.spacing.xl,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: design.colors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _SignatureBlock(
                            name: certificate.signerOneName ?? '',
                            role: certificate.signerOneRole ?? '',
                          ),
                        ),
                        SizedBox(width: design.spacing.md),
                        Expanded(
                          child: _SignatureBlock(
                            name: certificate.signerTwoName ?? '',
                            role: certificate.signerTwoRole ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: design.spacing.xs / 2),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(design.spacing.md),
                    decoration: BoxDecoration(
                      color: design.colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(design.radius.lg),
                      border: Border.all(color: design.colors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.caption(
                                l10n.certificatesCertificateId.toUpperCase(),
                                color: design.colors.textSecondary,
                                style: TextStyle(
                                  letterSpacing: design.spacing.xs / 2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: design.spacing.xs / 2),
                              AppText.body(
                                certificate.certificateId ?? '-',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: design.spacing.xs / 2,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: design.spacing.sm,
                                height: design.spacing.sm,
                                decoration: BoxDecoration(
                                  color: design.colors.success,
                                  borderRadius: BorderRadius.circular(
                                    design.radius.full,
                                  ),
                                ),
                              ),
                              SizedBox(width: design.spacing.xs),
                              AppText.caption(
                                l10n.certificatesVerified,
                                color: design.colors.success,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: design.spacing.lg),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: design.spacing.lg),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: design.colors.border),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.award,
                              size: design.iconSize.sm,
                              color: design.colors.accent2,
                            ),
                            SizedBox(width: design.spacing.xs),
                            AppText.label(
                              certificate.instituteName ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: design.spacing.xs / 2),
                        AppText.caption(
                          certificate.instituteTagline ?? '',
                          color: design.colors.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: design.spacing.md - design.spacing.xs,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    design.colors.accent4,
                    design.colors.accent1,
                    design.colors.accent2,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextSpan _awardedTextSpan({
    required String awardedText,
    required String dateText,
    required TextStyle baseStyle,
    required TextStyle boldStyle,
  }) {
    if (dateText.isNotEmpty) {
      final start = awardedText.indexOf(dateText);
      if (start >= 0) {
        final end = start + dateText.length;
        return TextSpan(
          style: baseStyle,
          children: [
            TextSpan(text: awardedText.substring(0, start)),
            TextSpan(text: dateText, style: boldStyle),
            TextSpan(text: awardedText.substring(end)),
          ],
        );
      }
    }

    return TextSpan(text: awardedText, style: baseStyle);
  }
}

class _SignatureBlock extends StatelessWidget {
  const _SignatureBlock({required this.name, required this.role});

  final String name;
  final String role;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Column(
      children: [
        Container(
          height: design.spacing.xl + design.spacing.sm,
          alignment: Alignment.bottomCenter,
          child: Container(
            height: design.spacing.xs / 4,
            width: design.spacing.xxl + design.spacing.xl + design.spacing.sm,
            color: design.colors.border,
          ),
        ),
        SizedBox(height: design.spacing.sm + design.spacing.xs / 2),
        AppText.subtitle(
          name,
          color: design.colors.textPrimary,
          style: const TextStyle(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: design.spacing.xs),
        AppText.caption(
          role,
          color: design.colors.textSecondary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
