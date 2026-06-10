import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Plays the raquete video on an infinite loop. Muted so browsers (especially
/// mobile) allow autoplay, and clipped to a circle to keep the round footprint
/// the orb used to have.
///
/// The video is loaded from the same origin as a plain static file
/// (`/raquete.mp4`) instead of a Flutter asset: bundled assets are cached by
/// the service worker, which serves them without honoring HTTP Range requests
/// and breaks `<video>` playback on web. While the video loads — or on
/// platforms without a video backend (e.g. tests) — the racket image is shown
/// instead.
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
    _controller = VideoPlayerController.networkUrl(
      Uri.base.resolve('raquete.mp4'),
    );
    _setup();
  }

  Future<void> _setup() async {
    try {
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.setVolume(0);
      await _controller.play();
      if (mounted) {
        setState(() {});
      }
    } catch (_) {
      // Video missing or platform without a video backend (e.g. tests):
      // keep the racket image instead of crashing.
    }
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
            : Image.asset(
                'assets/images/racket.png',
                fit: BoxFit.cover,
                width: widget.size,
                height: widget.size,
              ),
      ),
    );
  }
}
