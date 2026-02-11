import 'package:flutter/material.dart';
import 'package:testpress/course_list.dart';

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
    return const MaterialApp(
      title: 'Cortex',
      debugShowCheckedModeBanner: false,
      home: CourseListScreen(),
    );
  }
}
