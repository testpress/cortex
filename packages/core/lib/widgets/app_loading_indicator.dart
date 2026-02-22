import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';

class AppLoadingIndicator extends StatefulWidget {
  const AppLoadingIndicator({super.key});

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return SizedBox(
      width: 24,
      height: 24,
      child: Center(
        child: RotationTransition(
          turns: _controller,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border(
                top: BorderSide(color: design.colors.primary, width: 2),
                left: BorderSide(color: design.colors.primary, width: 2),
                bottom: BorderSide(
                  color: design.colors.primary.withOpacity(0.1),
                  width: 2,
                ),
                right: BorderSide(
                  color: design.colors.primary.withOpacity(0.1),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
