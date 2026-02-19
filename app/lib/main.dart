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
    // 🎨 DARK MODE SUPPORT: Both configs are now passed to DesignProvider.
    // It will automatically switch based on system brightness!
    final lightConfig = DesignConfig.light();
    final darkConfig = DesignConfig.dark();

    return DesignProvider(
      config: lightConfig,
      darkConfig: darkConfig,
      mode: DesignMode.system, // This is the default
      child: const CortexApp(),
    );
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
