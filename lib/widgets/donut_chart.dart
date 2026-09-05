import 'dart:math';

import 'package:flutter/material.dart';

/// A simple conic-gradient-style donut, drawn as stacked arcs — used for
/// the category breakdown on the dashboard and the Grafikler screen.
class DonutChart extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;
  final double size;
  final double strokeWidth;

  const DonutChart({
    super.key,
    required this.values,
    required this.colors,
    this.size = 140,
    this.strokeWidth = 28,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DonutPainter(values: values, colors: colors, strokeWidth: strokeWidth),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final double strokeWidth;

  _DonutPainter({required this.values, required this.colors, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (s, v) => s + v);
    final rect = Offset.zero & size;
    final inset = strokeWidth / 2;
    final arcRect = rect.deflate(inset);

    if (total <= 0) {
      final paint = Paint()
        ..color = colors.isNotEmpty ? colors.first.withValues(alpha: 0.25) : const Color(0x33000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawArc(arcRect, 0, 2 * pi, false, paint);
      return;
    }

    double start = -pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * pi;
      if (sweep <= 0) continue;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(arcRect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.colors != colors || oldDelegate.strokeWidth != strokeWidth;
  }
}
