import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class CircleShape extends StatelessWidget {
  final Color? color;
  final Color? borderColor;
  final Widget? child;
  final double? size;

  const CircleShape({
    super.key,
    this.color,
    this.borderColor,
    this.child,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.5)
            : null,
      ),
      child: child,
    );
  }
}

class SquareShape extends StatelessWidget {
  final Color? color;
  final Color? borderColor;
  final Widget? child;
  final double? size;

  const SquareShape({
    super.key,
    this.color,
    this.borderColor,
    this.child,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.5)
            : null,
      ),
      child: child,
    );
  }
}

class DiamondShape extends StatelessWidget {
  final Color color;
  final Widget? child;
  final double? size;

  const DiamondShape({super.key, required this.color, this.child, this.size});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: child != null
            ? Transform.rotate(angle: -math.pi / 4, child: child)
            : null,
      ),
    );
  }
}

class HexagonShape extends StatelessWidget {
  final Color color;
  final Widget? child;
  final double? size;

  const HexagonShape({super.key, required this.color, this.child, this.size});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HexagonClipper(),
      child: Container(width: size, height: size, color: color, child: child),
    );
  }
}

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final h = size.height;
    final w = size.width;
    path.moveTo(w * 0.5, 0);
    path.lineTo(w, h * 0.25);
    path.lineTo(w, h * 0.75);
    path.lineTo(w * 0.5, h);
    path.lineTo(0, h * 0.75);
    path.lineTo(0, h * 0.25);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
