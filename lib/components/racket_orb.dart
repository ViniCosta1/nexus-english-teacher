import 'package:flutter/material.dart';

class RacketOrb extends StatefulWidget {
  const RacketOrb({super.key, this.size = 120});

  final double size;

  @override
  State<RacketOrb> createState() => _RacketOrbState();
}

class _RacketOrbState extends State<RacketOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnim;
  late final Animation<double> _tiltAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -0.045, end: 0.045)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);
    _tiltAnim = Tween<double>(begin: -0.06, end: 0.06)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => SizedBox.square(
        dimension: s,
        child: ClipOval(
          child: ColoredBox(
            color: const Color(0xFF101010),
            child: Transform.translate(
              offset: Offset(0, _floatAnim.value * s),
              child: Transform.rotate(
                angle: _tiltAnim.value,
                child: CustomPaint(
                  size: Size(s, s),
                  painter: const _RacketPainter(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RacketPainter extends CustomPainter {
  const _RacketPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    // Scale to ~54% of canvas height so float animation doesn't clip badly
    final scale = h * 0.54;

    final headRx = scale * 0.47;
    final headRy = scale * 0.46;
    final headCy = cy - scale * 0.10;
    final headCenter = Offset(cx, headCy);
    final headRect = Rect.fromCenter(
      center: headCenter,
      width: headRx * 2,
      height: headRy * 2,
    );

    final throatTopHalfW = scale * 0.08;
    final throatBotHalfW = scale * 0.14;
    final throatTopY = headCy + headRy - scale * 0.03;
    final throatBotY = throatTopY + scale * 0.15;

    final handleHalfW = scale * 0.14;
    final handleTopY = throatBotY;
    final handleBotY = handleTopY + scale * 0.42;

    // Glow around head
    canvas.drawOval(
      headRect.inflate(12),
      Paint()
        ..color = const Color(0xFF6117F4).withOpacity(0.20)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );

    // String grid clipped to head interior
    canvas.save();
    canvas.clipPath(Path()..addOval(headRect.deflate(w * 0.042)));
    final strPaint = Paint()
      ..color = const Color(0xFFCFAAFF).withOpacity(0.42)
      ..strokeWidth = 0.85;
    const n = 9;
    for (int i = 1; i < n; i++) {
      final t = i / n;
      // horizontal
      canvas.drawLine(
        Offset(headCenter.dx - headRx, headCenter.dy - headRy + headRy * 2 * t),
        Offset(headCenter.dx + headRx, headCenter.dy - headRy + headRy * 2 * t),
        strPaint,
      );
      // vertical
      canvas.drawLine(
        Offset(headCenter.dx - headRx + headRx * 2 * t, headCenter.dy - headRy),
        Offset(headCenter.dx - headRx + headRx * 2 * t, headCenter.dy + headRy),
        strPaint,
      );
    }
    canvas.restore();

    // Head frame
    canvas.drawOval(
      headRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFF9B59FF)
        ..strokeWidth = w * 0.046
        ..strokeCap = StrokeCap.round,
    );

    // Throat
    canvas.drawPath(
      Path()
        ..moveTo(cx - throatTopHalfW, throatTopY)
        ..lineTo(cx + throatTopHalfW, throatTopY)
        ..lineTo(cx + throatBotHalfW, throatBotY)
        ..lineTo(cx - throatBotHalfW, throatBotY)
        ..close(),
      Paint()..color = const Color(0xFF7830D8),
    );

    // Handle body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, (handleTopY + handleBotY) / 2),
          width: handleHalfW * 2,
          height: handleBotY - handleTopY,
        ),
        Radius.circular(handleHalfW * 0.45),
      ),
      Paint()..color = const Color(0xFF5A1EAA),
    );

    // Handle grip lines
    final gripPaint = Paint()
      ..color = Colors.white.withOpacity(0.13)
      ..strokeWidth = 1.0;
    for (int i = 1; i <= 5; i++) {
      final y = handleTopY + (handleBotY - handleTopY) * i / 6;
      canvas.drawLine(
        Offset(cx - handleHalfW + 2, y),
        Offset(cx + handleHalfW - 2, y),
        gripPaint,
      );
    }

    // Butt cap
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, handleBotY - 3),
          width: handleHalfW * 2 + 5,
          height: 7,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF6117F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
