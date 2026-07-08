import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../design/design_provider.dart';

class AppOtpInput extends StatefulWidget {
  const AppOtpInput({
    super.key,
    required this.controller,
    required this.length,
    this.onChanged,
    this.onCompleted,
    this.enabled = true,
  });

  final TextEditingController controller;
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool enabled;

  @override
  State<AppOtpInput> createState() => _AppOtpInputState();
}

class _AppOtpInputState extends State<AppOtpInput> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
    widget.controller.addListener(_onTextChanged);
  }

  void _onFocusChanged() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant AppOtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.controller.text.length == widget.length) {
      widget.onCompleted?.call(widget.controller.text);
    }
    if (mounted) {
      setState(() {}); // Rebuild to update boxes
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final text = widget.controller.text;

    return GestureDetector(
      onTap: () {
        if (widget.enabled) {
          FocusScope.of(context).requestFocus(_focusNode);
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Visible boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (index) {
              final isFocused =
                  _focusNode.hasFocus &&
                  (text.length == index ||
                      (text.length == widget.length &&
                          index == widget.length - 1));
              final hasChar = index < text.length;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: design.spacing.xs),
                width: 48, // Wider
                height: 58, // Bigger
                decoration: BoxDecoration(
                  color: Colors.transparent, // Outer ring only visible
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isFocused
                        ? design.colors.primary
                        : hasChar
                        ? design.colors.textSecondary
                        : const Color(0xFFEDF1F3),
                    width: isFocused ? 2.0 : 1.0,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  hasChar ? text[index] : '',
                  style: design.typography.headline.copyWith(
                    color: design.colors.textPrimary,
                  ), // Slightly larger text to match bigger boxes
                ),
              );
            }),
          ),
          // Invisible TextField on top to reliably handle keyboard input
          Positioned.fill(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              enabled: widget.enabled,
              maxLength: widget.length,
              onChanged: widget.onChanged,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              cursorColor: Colors.transparent,
              enableInteractiveSelection: false,
              style: const TextStyle(color: Colors.transparent, fontSize: 1),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
