import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traveler_app/util/app_theme.dart';

/// Soft sky background used as the canvas behind illustrated screens.
///
/// By default the image is anchored to the top of the screen and only
/// covers ~35% of the height before fading into a clean white surface,
/// which keeps content underneath legible. Pass [coverFull] to render the
/// image edge-to-edge (used by detail heroes, for example).
class SkyBackground extends StatelessWidget {
  final Widget? child;
  final bool coverFull;
  final double topFraction;
  final double opacity;

  // Kept for backwards compatibility; ignored.
  final bool clouds;

  const SkyBackground({
    super.key,
    this.child,
    this.coverFull = false,
    this.topFraction = 0.35,
    this.opacity = 0.55,
    this.clouds = false,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final imageHeight =
        coverFull ? mq.size.height : mq.size.height * topFraction;

    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppTheme.white),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: imageHeight,
          child: _SkyLayer(coverFull: coverFull, opacity: opacity),
        ),
        if (child != null) child!,
      ],
    );
  }
}

class _SkyLayer extends StatelessWidget {
  final bool coverFull;
  final double opacity;

  const _SkyLayer({required this.coverFull, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(gradient: _SkyGradient.gradient),
        ),
        Opacity(opacity: opacity, child: const _SkyImage()),
        if (!coverFull)
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00FFFFFF),
                  Color(0x00FFFFFF),
                  AppTheme.white,
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
      ],
    );
  }
}

class _SkyGradient {
  static const gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppTheme.skyTop, AppTheme.skyBottom],
  );
}

class _SkyImage extends StatefulWidget {
  const _SkyImage();

  @override
  State<_SkyImage> createState() => _SkyImageState();
}

class _SkyImageState extends State<_SkyImage> {
  bool _exists = true;

  @override
  void initState() {
    super.initState();
    _probe();
  }

  Future<void> _probe() async {
    try {
      await rootBundle.load('assets/images/sky_background.png');
    } catch (_) {
      if (mounted) setState(() => _exists = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_exists) return const SizedBox.shrink();
    return Image.asset(
      'assets/images/sky_background.png',
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const SizedBox.shrink(),
    );
  }
}
