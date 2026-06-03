import 'dart:math';

import 'package:flutter/material.dart';

class Orb extends StatelessWidget {
  const Orb({
    super.key,
    this.size = 120,
    this.color = const Color(0xFF6117F4),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _OrbPainter(color),
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  const _OrbPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final shortestSide = min(size.width, size.height);
    final radius = shortestSide * 0.34;

    final glowPaint = Paint()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shortestSide * 0.08);

    for (final layer in _layers(shortestSide)) {
      glowPaint.color = color.withValues(alpha: layer.opacity);
      canvas.drawOval(
        Rect.fromCenter(
          center: center + layer.offset,
          width: radius * layer.width,
          height: radius * layer.height,
        ),
        glowPaint,
      );
    }

    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.92),
          color.withValues(alpha: 0.5),
          color.withValues(alpha: 0.16),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, corePaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = shortestSide * 0.035
      ..color = color.withValues(alpha: 0.22)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shortestSide * 0.025);

    canvas.drawCircle(center, radius * 1.04, ringPaint);
  }

  List<_OrbLayer> _layers(double size) {
    return [
      _OrbLayer(Offset(-size * 0.08, -size * 0.07), 2.05, 1.5, 0.18),
      _OrbLayer(Offset(size * 0.1, -size * 0.02), 1.75, 1.85, 0.16),
      _OrbLayer(Offset(-size * 0.02, size * 0.1), 1.45, 1.95, 0.12),
      _OrbLayer(Offset(size * 0.04, size * 0.02), 1.55, 1.5, 0.2),
    ];
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _OrbLayer {
  const _OrbLayer(this.offset, this.width, this.height, this.opacity);

  final Offset offset;
  final double width;
  final double height;
  final double opacity;
}
