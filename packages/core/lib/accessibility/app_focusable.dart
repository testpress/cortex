import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import '../design/design_provider.dart';

/// A platform-neutral focusable widget for the Cortex design system.
///
/// Wraps its child in a [Focus] widget and renders a custom focus ring
/// when the node is focused via keyboard or other non-touch inputs.
///
/// This provides a consistent focus visual across iPad, Android, and Web
/// while adhering to the Neutral UI philosophy.
class AppFocusable extends StatefulWidget {
  const AppFocusable({
    super.key,
    required this.child,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  @override
  State<AppFocusable> createState() => _AppFocusableState();
}

class _AppFocusableState extends State<AppFocusable> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted && _focusNode.hasFocus != _isFocused) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: (node, event) {
        if (widget.onTap != null &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          widget.onTap!();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            widget.child,
            if (_isFocused)
              Positioned.fill(
                left: -widget.padding.left - 2,
                top: -widget.padding.top - 2,
                right: -widget.padding.right - 2,
                bottom: -widget.padding.bottom - 2,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: (widget.borderRadius ?? BorderRadius.zero)
                          .add(const BorderRadius.all(Radius.circular(2))),
                      border: Border.all(
                        color: design.colors.focus,
                        width: 3.0,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
