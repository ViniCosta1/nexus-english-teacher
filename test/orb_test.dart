import 'package:beach_talk/components/orb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Orb exposes reusable defaults and paints itself', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: Orb(),
        ),
      ),
    );

    final orb = tester.widget<Orb>(find.byType(Orb));
    final orbPaint = find.descendant(
      of: find.byType(Orb),
      matching: find.byType(CustomPaint),
    );

    expect(orb.size, 120);
    expect(orb.color, const Color(0xFF6117F4));
    expect(
      orbPaint,
      paints
        ..something(_drawsCoreCircle)
        ..something(_drawsBlurredRing),
    );
  });
}

bool _drawsCoreCircle(Symbol methodName, List<dynamic> arguments) {
  if (methodName != #drawCircle) {
    return false;
  }

  final center = arguments[0] as Offset;
  final radius = arguments[1] as double;
  final paint = arguments[2] as Paint;

  return _isCloseTo(center.dx, 60) &&
      _isCloseTo(center.dy, 60) &&
      _isCloseTo(radius, 40.8) &&
      paint.shader != null;
}

bool _drawsBlurredRing(Symbol methodName, List<dynamic> arguments) {
  if (methodName != #drawCircle) {
    return false;
  }

  final center = arguments[0] as Offset;
  final radius = arguments[1] as double;
  final paint = arguments[2] as Paint;

  return _isCloseTo(center.dx, 60) &&
      _isCloseTo(center.dy, 60) &&
      _isCloseTo(radius, 42.432) &&
      _isCloseTo(paint.strokeWidth, 4.2) &&
      paint.style == PaintingStyle.stroke &&
      paint.maskFilter != null;
}

bool _isCloseTo(double actual, double expected) {
  return (actual - expected).abs() < 0.001;
}
