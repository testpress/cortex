import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/certificate.dart';
import '../providers/certificates_provider.dart';

class CertificatesScreen extends ConsumerWidget {
  const CertificatesScreen({
    super.key,
    required this.onBack,
    required this.onOpenPreview,
    this.onContinueCourse,
    this.onDownloadCertificate,
  });

  final VoidCallback onBack;
  final ValueChanged<CourseCertificate> onOpenPreview;
  final ValueChanged<CourseCertificate>? onContinueCourse;
  final ValueChanged<CourseCertificate>? onDownloadCertificate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final certificates = ref.watch(paidActiveCertificatesProvider);

    return ColoredBox(
      color: design.colors.canvas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CertificatesHeader(onBack: onBack),
          Expanded(
            child: AppScroll(
              padding: EdgeInsets.fromLTRB(
                design.spacing.md,
                design.spacing.lg,
                design.spacing.md,
                design.spacing.xxl,
              ),
              children: [
                AppText.xl2(
                  l10n.profileCertificates,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    height: 1.33,
                  ),
                ),
                SizedBox(height: design.spacing.xs),
                AppText.sm(
                  l10n.certificatesSubtitleAvailable,
                  color: design.colors.textSecondary,
                ),
                SizedBox(height: design.spacing.lg),
                if (certificates.isEmpty)
                  AppText.subtitle(
                    l10n.certificatesEmptyPaidNewDesc,
                    color: design.colors.textSecondary,
                  )
                else
                  ...certificates.map(
                    (certificate) => Padding(
                      padding: EdgeInsets.only(bottom: design.spacing.md),
                      child: _CertificateCard(
                        certificate: certificate,
                        onContinueCourse: onContinueCourse,
                        onOpenPreview: onOpenPreview,
                        onDownloadCertificate: onDownloadCertificate,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificatesHeader extends StatelessWidget {
  const _CertificatesHeader({required this.onBack});

  final VoidCallback onBack;

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
      child: Align(
        alignment: Alignment.centerLeft,
        child: AppSemantics.button(
          label: l10n.curriculumBackButton,
          onTap: onBack,
          child: AppFocusable(
            onTap: onBack,
            borderRadius: design.radius.button,
            child: SizedBox(
              height: design.iconSize.lg + design.spacing.xs,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.chevronLeft,
                    size: design.iconSize.md,
                    color: design.colors.textPrimary,
                  ),
                  SizedBox(width: design.spacing.sm),
                  AppText.subtitle(
                    l10n.curriculumBackButton,
                    color: design.colors.textPrimary,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({
    required this.certificate,
    required this.onOpenPreview,
    this.onContinueCourse,
    this.onDownloadCertificate,
  });

  final CourseCertificate certificate;
  final ValueChanged<CourseCertificate> onOpenPreview;
  final ValueChanged<CourseCertificate>? onContinueCourse;
  final ValueChanged<CourseCertificate>? onDownloadCertificate;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final unlockedHeaderStart = design.subjectPalette
        .atIndex(certificate.course.colorIndex)
        .accent;
    final unlockedHeaderEnd = design.colors.accent4;

    return AppCard(
      showShadow: true,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: design.radius.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(design.spacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: certificate.isLocked
                      ? [
                          design.colors.textTertiary,
                          design.colors.textSecondary,
                        ]
                      : [unlockedHeaderStart, unlockedHeaderEnd],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: design.spacing.xxl,
                    height: design.spacing.xxl,
                    decoration: BoxDecoration(
                      color: design.colors.textInverse.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(design.radius.lg),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      certificate.isLocked
                          ? LucideIcons.lock
                          : LucideIcons.shieldCheck,
                      size: design.iconSize.md,
                      color: design.colors.textInverse,
                    ),
                  ),
                  SizedBox(width: design.spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.caption(
                          certificate.isLocked
                              ? l10n.certificatesLockedBadge
                              : l10n.certificatesUnlockedBadge,
                          color: design.colors.textInverse.withValues(
                            alpha: 0.84,
                          ),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: design.spacing.xs / 2),
                        AppText.body(
                          certificate.course.title,
                          color: design.colors.textInverse,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(design.spacing.md),
              child: certificate.isLocked
                  ? _LockedCertificateDetails(
                      certificate: certificate,
                      onContinueCourse: onContinueCourse,
                    )
                  : _UnlockedCertificateDetails(
                      certificate: certificate,
                      onOpenPreview: onOpenPreview,
                      onDownloadCertificate: onDownloadCertificate,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LockedCertificateDetails extends StatelessWidget {
  const _LockedCertificateDetails({
    required this.certificate,
    this.onContinueCourse,
  });

  final CourseCertificate certificate;
  final ValueChanged<CourseCertificate>? onContinueCourse;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.caption(
              l10n.certificatesCourseProgress,
              color: design.colors.textSecondary,
            ),
            AppText.caption(
              '${certificate.progress}%',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: design.spacing.xs),
        Container(
          height: design.spacing.xs,
          decoration: BoxDecoration(
            color: design.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(design.radius.full),
          ),
          child: FractionallySizedBox(
            widthFactor: certificate.progress / 100,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: design.colors.accent2,
                borderRadius: BorderRadius.circular(design.radius.full),
              ),
            ),
          ),
        ),
        SizedBox(height: design.spacing.md),
        AppText.subtitle(
          l10n.certificatesKeepGoing,
          color: design.colors.textSecondary,
        ),
        SizedBox(height: design.spacing.md),
        AppButton.primary(
          label: l10n.certificatesContinueCourse,
          fullWidth: true,
          backgroundColor: design.colors.accent2,
          onPressed: () => onContinueCourse?.call(certificate),
        ),
      ],
    );
  }
}

class _UnlockedCertificateDetails extends StatelessWidget {
  const _UnlockedCertificateDetails({
    required this.certificate,
    required this.onOpenPreview,
    this.onDownloadCertificate,
  });

  final CourseCertificate certificate;
  final ValueChanged<CourseCertificate> onOpenPreview;
  final ValueChanged<CourseCertificate>? onDownloadCertificate;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final locale = l10n.localeName;
    final completionDate = certificate.completionDate;
    final dateText = completionDate == null
        ? ''
        : DateFormat.yMMMMd(locale).format(completionDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              LucideIcons.calendar,
              size: design.iconSize.sm,
              color: design.colors.textSecondary,
            ),
            SizedBox(width: design.spacing.xs),
            Expanded(
              child: AppText.caption(
                l10n.certificatesCompletedOn(dateText),
                color: design.colors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: design.spacing.md),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(design.spacing.sm),
          decoration: BoxDecoration(
            color: design.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(design.radius.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.caption(
                l10n.certificatesCertificateId,
                color: design.colors.textSecondary,
              ),
              SizedBox(height: design.spacing.xs / 2),
              AppText.body(
                certificate.certificateId ?? '-',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        SizedBox(height: design.spacing.md),
        Row(
          children: [
            Expanded(
              child: AppButton.primary(
                label: l10n.certificatesViewCertificate,
                backgroundColor: design.colors.accent2,
                onPressed: () => onOpenPreview(certificate),
              ),
            ),
            SizedBox(width: design.spacing.sm),
            AppSemantics.button(
              label: l10n.certificatesDownload,
              onTap: () => onDownloadCertificate?.call(certificate),
              child: AppFocusable(
                onTap: () => onDownloadCertificate?.call(certificate),
                borderRadius: design.radius.button,
                child: Container(
                  width: design.spacing.xxl,
                  height: design.spacing.xxl,
                  decoration: BoxDecoration(
                    color: design.colors.surfaceVariant,
                    borderRadius: design.radius.button,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    LucideIcons.download,
                    size: design.iconSize.md,
                    color: design.colors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
