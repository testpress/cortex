import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';

/// A platform-neutral bottom sheet widget for the Cortex design system.
///
/// This provides a consistent bottom sheet experience without Material dependencies.
class AppBottomSheet extends StatefulWidget {
  const AppBottomSheet({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.child,
    this.backgroundColor,
  });

  final bool isOpen;
  final VoidCallback onClose;
  final Widget child;
  final Color? backgroundColor;

  @override
  State<AppBottomSheet> createState() => _AppBottomSheetState();
}

class _AppBottomSheetState extends State<AppBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    if (widget.isOpen) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AppBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return PopScope(
      canPop: !widget.isOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (widget.isOpen) {
          widget.onClose();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isDismissed && !widget.isOpen) {
            return const SizedBox.shrink();
          }

          return Stack(
            children: [
              // Backdrop
              GestureDetector(
                onTap: widget.onClose,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(color: design.colors.overlay),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: widget.child,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
