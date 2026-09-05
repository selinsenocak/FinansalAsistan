import 'package:flutter/material.dart';

/// A two-series line chart (income vs. expense, by month) with three
/// horizontal grid lines — matches the SVG polyline chart in the
/// original design's Grafikler screen.
class TrendChart extends StatelessWidget {
  final List<double> income;
  final List<double> expense;
  final Color incomeColor;
  final Color expenseColor;
  final Color gridColor;
  final double height;

  const TrendChart({
    super.key,
    required this.income,
    required this.expense,
    required this.incomeColor,
    required this.expenseColor,
    required this.gridColor,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _TrendPainter(
          income: income,
          expense: expense,
          incomeColor: incomeColor,
          expenseColor: expenseColor,
          gridColor: gridColor,
        ),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  final List<double> income;
  final List<double> expense;
  final Color incomeColor;
  final Color expenseColor;
  final Color gridColor;

  _TrendPainter({
    required this.income,
    required this.expense,
    required this.incomeColor,
    required this.expenseColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const pad = 10.0;
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (final f in [0.25, 0.5, 0.75]) {
      final y = size.height * f;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final maxVal = [...income, ...expense].fold<double>(1, (m, v) => v > m ? v : m);
    final n = income.length;
    if (n < 2) return;
    final stepX = (size.width - pad * 2) / (n - 1);

    Offset pointAt(List<double> series, int i) {
      final x = pad + stepX * i;
      final y = size.height - pad - (series[i] / maxVal) * (size.height - pad * 2);
      return Offset(x, y);
    }

    void drawSeries(List<double> series, Color color) {
      final path = Path();
      for (var i = 0; i < n; i++) {
        final p = pointAt(series, i);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      final linePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, linePaint);

      final dotPaint = Paint()..color = color;
      for (var i = 0; i < n; i++) {
        canvas.drawCircle(pointAt(series, i), 3.5, dotPaint);
      }
    }

    drawSeries(income, incomeColor);
    drawSeries(expense, expenseColor);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) {
    return oldDelegate.income != income || oldDelegate.expense != expense;
  }
}
