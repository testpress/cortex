import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return SizedBox(
      width: 24,
      height: 24,
      child: Center(
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: design.colors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
