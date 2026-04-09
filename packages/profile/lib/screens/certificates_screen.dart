import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/certificate.dart';
import '../providers/certificates_provider.dart';

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

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
    final certificates = ref.watch(paidActiveCertificatesProvider);

    return ColoredBox(
      color: design.colors.canvas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CertificatesHeader(onBack: onBack),
          Expanded(
            child: _CertificatesBody(
              certificates: certificates,
              onContinueCourse: onContinueCourse,
              onOpenPreview: onOpenPreview,
              onDownloadCertificate: onDownloadCertificate,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _CertificatesHeader extends StatelessWidget {
  const _CertificatesHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: topPadding + design.spacing.md,
        bottom: design.spacing.md,
        left: design.spacing.md,
        right: design.spacing.md,
      ),
      decoration: _headerDecoration(design),
      child: Align(
        alignment: Alignment.centerLeft,
        child: _BackButton(label: l10n.curriculumBackButton, onBack: onBack),
      ),
    );
  }

  BoxDecoration _headerDecoration(Design design) => BoxDecoration(
        color: design.isDark ? design.colors.surface : design.colors.card,
        border: Border(bottom: BorderSide(color: design.colors.border)),
      );
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.label, required this.onBack});

  final String label;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppSemantics.button(
      label: label,
      onTap: onBack,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onBack,
        child: SizedBox(
          height: design.iconSize.lg + design.spacing.xs,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.chevronLeft,
                size: design.iconSize.md,
                color: design.colors.textPrimary,
              ),
              SizedBox(width: design.spacing.sm),
              AppText.subtitle(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body
// ---------------------------------------------------------------------------

class _CertificatesBody extends StatelessWidget {
  const _CertificatesBody({
    required this.certificates,
    required this.onOpenPreview,
    this.onContinueCourse,
    this.onDownloadCertificate,
  });

  final List<CourseCertificate> certificates;
  final ValueChanged<CourseCertificate> onOpenPreview;
  final ValueChanged<CourseCertificate>? onContinueCourse;
  final ValueChanged<CourseCertificate>? onDownloadCertificate;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppScroll(
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        design.spacing.lg,
        design.spacing.md,
        design.spacing.xxl,
      ),
      children: [
        _ScreenTitle(l10n: l10n, design: design),
        SizedBox(height: design.spacing.lg),
        _CertificateList(
          certificates: certificates,
          onContinueCourse: onContinueCourse,
          onOpenPreview: onOpenPreview,
          onDownloadCertificate: onDownloadCertificate,
        ),
      ],
    );
  }
}

class _ScreenTitle extends StatelessWidget {
  const _ScreenTitle({required this.l10n, required this.design});

  final L10n l10n;
  final Design design;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.xl2(
          l10n.profileCertificates,
          style: const TextStyle(fontWeight: FontWeight.w700, height: 1.33),
        ),
        SizedBox(height: design.spacing.xs),
        AppText.sm(
          l10n.certificatesSubtitleAvailable,
          color: design.colors.textSecondary,
        ),
      ],
    );
  }
}

class _CertificateList extends StatelessWidget {
  const _CertificateList({
    required this.certificates,
    required this.onOpenPreview,
    this.onContinueCourse,
    this.onDownloadCertificate,
  });

  final List<CourseCertificate> certificates;
  final ValueChanged<CourseCertificate> onOpenPreview;
  final ValueChanged<CourseCertificate>? onContinueCourse;
  final ValueChanged<CourseCertificate>? onDownloadCertificate;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final design = Design.of(context);

    if (certificates.isEmpty) {
      return AppText.subtitle(
        l10n.certificatesEmptyPaidNewDesc,
        color: design.colors.textSecondary,
      );
    }

    return Column(
      children: certificates
          .map((certificate) => _CertificateCardSpaced(
                certificate: certificate,
                onContinueCourse: onContinueCourse,
                onOpenPreview: onOpenPreview,
                onDownloadCertificate: onDownloadCertificate,
              ))
          .toList(),
    );
  }
}

class _CertificateCardSpaced extends StatelessWidget {
  const _CertificateCardSpaced({
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

    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.md),
      child: _CertificateCard(
        certificate: certificate,
        onContinueCourse: onContinueCourse,
        onOpenPreview: onOpenPreview,
        onDownloadCertificate: onDownloadCertificate,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Certificate Card
// ---------------------------------------------------------------------------

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

    return AppCard(
      showShadow: true,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: design.radius.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardHeader(certificate: certificate),
            Padding(
              padding: EdgeInsets.fromLTRB(
                design.spacing.md,
                design.spacing.sm,
                design.spacing.md,
                design.spacing.md,
              ),
              child: _CardBody(
                certificate: certificate,
                onContinueCourse: onContinueCourse,
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

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.certificate});

  final CourseCertificate certificate;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(gradient: _headerGradient(design)),
      child: Row(
        children: [
          _StatusIcon(certificate: certificate),
          SizedBox(width: design.spacing.sm),
          Expanded(
            child: _StatusLabel(certificate: certificate, l10n: l10n),
          ),
        ],
      ),
    );
  }

  LinearGradient _headerGradient(Design design) {
    final lockedColors = [
      design.colors.textTertiary,
      design.colors.textSecondary,
    ];
    final unlockedColors = [
      design.colors.accent4.withValues(alpha: 0.8),
      design.colors.accent4,
    ];

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: certificate.isLocked ? lockedColors : unlockedColors,
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.certificate});

  final CourseCertificate certificate;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      width: design.spacing.xxl,
      height: design.spacing.xxl,
      decoration: BoxDecoration(
        color: design.colors.textInverse.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(design.radius.lg),
      ),
      alignment: Alignment.center,
      child: Icon(
        certificate.isLocked ? LucideIcons.lock : LucideIcons.shieldCheck,
        size: design.iconSize.md,
        color: design.colors.textInverse,
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.certificate, required this.l10n});

  final CourseCertificate certificate;
  final L10n l10n;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final badgeText = certificate.isLocked
        ? l10n.certificatesLockedBadge
        : l10n.certificatesUnlockedBadge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.caption(
          badgeText,
          color: design.colors.textInverse.withValues(alpha: 0.84),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: design.spacing.xs / 2),
        AppText.body(
          certificate.course.title,
          color: design.colors.textInverse,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({
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
    if (certificate.isLocked) {
      return _LockedCertificateDetails(
        certificate: certificate,
        onContinueCourse: onContinueCourse,
      );
    }
    return _UnlockedCertificateDetails(
      certificate: certificate,
      onOpenPreview: onOpenPreview,
      onDownloadCertificate: onDownloadCertificate,
    );
  }
}

// ---------------------------------------------------------------------------
// Locked State
// ---------------------------------------------------------------------------

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
        _ProgressBar(progress: certificate.progress),
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

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final int progress;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      children: [
        _ProgressLabel(progress: progress, l10n: l10n, design: design),
        SizedBox(height: design.spacing.xs),
        _ProgressTrack(progress: progress, design: design),
      ],
    );
  }
}

class _ProgressLabel extends StatelessWidget {
  const _ProgressLabel({
    required this.progress,
    required this.l10n,
    required this.design,
  });

  final int progress;
  final L10n l10n;
  final Design design;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.caption(
          l10n.certificatesCourseProgress,
          color: design.colors.textSecondary,
        ),
        AppText.caption(
          '$progress%',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({required this.progress, required this.design});

  final int progress;
  final Design design;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: design.spacing.xs,
      decoration: BoxDecoration(
        color: design.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(design.radius.full),
      ),
      child: FractionallySizedBox(
        widthFactor: progress / 100,
        alignment: Alignment.centerLeft,
        child: _ProgressFill(design: design),
      ),
    );
  }
}

class _ProgressFill extends StatelessWidget {
  const _ProgressFill({required this.design});

  final Design design;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: design.colors.accent2,
        borderRadius: BorderRadius.circular(design.radius.full),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Unlocked State
// ---------------------------------------------------------------------------

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompletionDate(certificate: certificate),
        SizedBox(height: design.spacing.sm),
        _CertificateIdBox(certificateId: certificate.certificateId),
        SizedBox(height: design.spacing.md),
        _ActionButtons(
          certificate: certificate,
          onOpenPreview: onOpenPreview,
          onDownloadCertificate: onDownloadCertificate,
        ),
      ],
    );
  }
}

class _CompletionDate extends StatelessWidget {
  const _CompletionDate({required this.certificate});

  final CourseCertificate certificate;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final dateText = _formatCompletionDate(certificate.completionDate, l10n);

    return Row(
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
    );
  }

  String _formatCompletionDate(DateTime? date, L10n l10n) {
    if (date == null) return '';
    return DateFormat.yMMMMd(l10n.localeName).format(date);
  }
}

class _CertificateIdBox extends StatelessWidget {
  const _CertificateIdBox({required this.certificateId});

  final String? certificateId;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: design.colors.surface,
        border: Border.all(color: design.colors.border),
        borderRadius: BorderRadius.circular(design.radius.md),
      ),
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
          AppText.subtitle(
            certificateId ?? '-',
            color: design.colors.textPrimary,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
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

    return Row(
      children: [
        Expanded(
          child: AppButton.primary(
            label: l10n.certificatesViewCertificate,
            height: 44.0,
            fullWidth: true,
            backgroundColor: design.colors.accent2,
            onPressed: () => onOpenPreview(certificate),
          ),
        ),
        SizedBox(width: design.spacing.sm),
        _DownloadIconButton(
          label: l10n.certificatesDownload,
          onTap: () => onDownloadCertificate?.call(certificate),
        ),
      ],
    );
  }
}

class _DownloadIconButton extends StatelessWidget {
  const _DownloadIconButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppSemantics.button(
      label: label,
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: design.radius.button,
        child: Container(
          width: 44.0,
          height: 44.0,
          decoration: BoxDecoration(
            color: design.colors.surface,
            border: Border.all(color: design.colors.border),
            borderRadius: design.radius.button,
          ),
          alignment: Alignment.center,
          child: Icon(
            LucideIcons.download,
            size: design.iconSize.sm,
            color: design.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
