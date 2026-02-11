import 'package:flutter/material.dart';
import 'package:testpress/course_list.dart';
import 'package:core/core.dart';

void main() {
  runApp(const CortexApp());
}

/// Cortex reference application.
///
/// Demonstrates consumption of the testpress SDK. Uses MaterialApp
/// as a container only - no Material widgets in the UI layer.
class CortexApp extends StatelessWidget {
  const CortexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cortex',
      debugShowCheckedModeBanner: false,
      home: DefaultTextStyle(
        // Provide default text style to prevent debug decorations
        style: AppTypography.body.copyWith(
          color: AppColors.textPrimary,
          decoration: TextDecoration.none,
        ),
        child: const CourseListScreen(),
      ),
    );
  }
}
