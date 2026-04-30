import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    
    return Container(
      color: design.colors.surface,
      child: Center(
        child: Text(
          'Exams Landing Page',
          style: design.typography.headline.copyWith(
            color: design.colors.textPrimary,
          ),
        ),
      ),
    );
  }
}
