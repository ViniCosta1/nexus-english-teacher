import 'package:flutter/material.dart';

class VideoOrb extends StatelessWidget {
  const VideoOrb({
    super.key,
    this.size = 120,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: ClipOval(
        child: Container(
          color: const Color(0xFF1A1A1A),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/racket.png',
            fit: BoxFit.cover,
            width: size,
            height: size,
          ),
        ),
      ),
    );
  }
}
