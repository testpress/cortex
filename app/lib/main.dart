import 'package:flutter/material.dart';
import 'package:testpress/course_list.dart';
import 'package:core/core.dart';

void main() {
  runApp(const CortexAppRoot());
}

/// Root widget with mutable DesignConfig for hot reload testing.
///
/// To test runtime design changes:
/// 1. Change the primary color below
/// 2. Save the file (hot reload)
/// 3. See the UI update immediately
class CortexAppRoot extends StatefulWidget {
  const CortexAppRoot({super.key});

  @override
  State<CortexAppRoot> createState() => _CortexAppRootState();
}

class _CortexAppRootState extends State<CortexAppRoot> {
  @override
  Widget build(BuildContext context) {
    // 🎨 HOT RELOAD TEST: Change this color and save to see live updates
    // The text color will automatically adjust for contrast!
    final customConfig = DesignConfig(
      colors: DesignColors.smart(
        primary: const Color(
          0xFF6366F1,
        ), // 👈 Try: 0xFFFF0000, 0xFF00FF00, 0xFFFFFF00
        // onPrimary is automatically calculated for WCAG AA contrast!
      ),
      spacing: DesignSpacing.defaults(),
      typography: DesignTypography.defaults(),
      motion: DesignMotion.defaults(),
      radius: DesignRadius.defaults(),
    );

    return DesignProvider(config: customConfig, child: const CortexApp());
  }
}

/// Cortex reference application.
///
/// Demonstrates consumption of the testpress SDK. Uses MaterialApp
/// as a container only - no Material widgets in the UI layer.
class CortexApp extends StatelessWidget {
  const CortexApp({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return MaterialApp(
      title: 'Cortex',
      debugShowCheckedModeBanner: false,
      home: DefaultTextStyle(
        // Required: AppText uses Text internally which needs DefaultTextStyle
        style: design.typography.body.copyWith(
          color: design.colors.textPrimary,
          decoration: TextDecoration.none,
        ),
        child: const CourseListScreen(),
      ),
    );
  }
}
