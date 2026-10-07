import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart'
    show
        TextField,
        InputDecoration,
        InputBorder,
        Icon,
        Material,
        MaterialType,
        TextInputAction;
import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';
import '../accessibility/app_semantics.dart';
import '../localization/l10n_helper.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.clearSemanticLabel,
    this.controller,
    this.backgroundColor,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  /// Accessibility label for the clear button. Defaults to localized "Clear search".
  final String? clearSemanticLabel;
  final TextEditingController? controller;
  final Color? backgroundColor;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  TextEditingController? _internalController;
  TextEditingController get _effectiveController =>
      widget.controller ?? (_internalController ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    _effectiveController.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(AppSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      if (oldWidget.controller == null && _internalController != null) {
        _internalController!.removeListener(_onTextChanged);
        _internalController!.dispose();
        _internalController = null;
      }
      _effectiveController.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    (widget.controller ?? _internalController)?.removeListener(_onTextChanged);
    _internalController?.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleClear() {
    _effectiveController.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final hasText = _effectiveController.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? design.colors.surface,
        borderRadius: BorderRadius.circular(design.radius.lg),
        border: Border.all(color: design.colors.border.withValues(alpha: 0.5)),
      ),
      padding: EdgeInsets.only(
        left: design.spacing.md,
        right: hasText ? 0 : design.spacing.md,
      ),
      child: Row(
        children: [
          Icon(LucideIcons.search, color: design.colors.textTertiary, size: 20),
          SizedBox(width: design.spacing.sm),
          Expanded(
            child: Material(
              type: MaterialType.transparency,
              child: TextField(
                controller: _effectiveController,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                textInputAction: TextInputAction.search,
                style: design.typography.body.copyWith(
                  color: design.colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: design.typography.body.copyWith(
                    color: design.colors.textTertiary,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: design.spacing.sm,
                  ),
                ),
              ),
            ),
          ),
          if (hasText)
            AppSemantics.button(
              label:
                  widget.clearSemanticLabel ?? l10n.commonClearSearchSemantic,
              onTap: _handleClear,
              child: GestureDetector(
                onTap: _handleClear,
                behavior: HitTestBehavior.opaque,
                excludeFromSemantics: true,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 48),
                  child: Center(
                    child: Icon(
                      LucideIcons.x,
                      color: design.colors.textTertiary,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
