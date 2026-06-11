import 'dart:math' as math;
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
                child: Padding(
                  padding: EdgeInsets.all(s * 0.06),
                  child: Image.asset(
                    'assets/images/racket.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
