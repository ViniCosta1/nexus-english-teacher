import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Drop-in replacement for [Orb] that plays the raquete video on an infinite
/// loop. Muted so browsers (especially mobile) allow autoplay, and clipped to a
/// circle to keep the round footprint the orb used to have.
class VideoOrb extends StatefulWidget {
  const VideoOrb({
    super.key,
    this.size = 120,
  });

  final double size;

  @override
  State<VideoOrb> createState() => _VideoOrbState();
}

class _VideoOrbState extends State<VideoOrb> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/raquete.mp4')
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted) {
          return;
        }
        _controller.play();
        setState(() {});
      }).catchError((_) {
        // Asset missing or platform without a video backend (e.g. tests):
        // keep the placeholder instead of crashing.
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: ClipOval(
        child: _controller.value.isInitialized
            ? FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            : const ColoredBox(color: Color(0xFF1A1A1A)),
      ),
    );
  }
}
