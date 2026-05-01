import 'package:flutter/material.dart';
import 'package:traveler_app/util/app_theme.dart';

/// Wraps [child] with a pulsing opacity animation. Use with [SkeletonBox]
/// placeholders that read the shared opacity via [InheritedWidget].
class Skeleton extends StatefulWidget {
  final Widget child;

  const Skeleton({super.key, required this.child});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) =>
          _SkeletonScope(opacity: _animation.value, child: widget.child),
    );
  }
}

class _SkeletonScope extends InheritedWidget {
  final double opacity;

  const _SkeletonScope({required this.opacity, required super.child});

  @override
  bool updateShouldNotify(_SkeletonScope oldWidget) =>
      oldWidget.opacity != opacity;

  static double of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_SkeletonScope>();
    return scope?.opacity ?? 1.0;
  }
}

/// Placeholder shape that pulses using the opacity from its nearest
/// [Skeleton] ancestor.
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 4,
    this.shape = BoxShape.rectangle,
  });

  const SkeletonBox.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = 0,
      shape = BoxShape.circle;

  @override
  Widget build(BuildContext context) {
    final opacity = _SkeletonScope.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.border.withValues(alpha: opacity),
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius)
            : null,
      ),
    );
  }
}

/// Standard white card container used as a skeleton item wrapper.
class SkeletonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const SkeletonCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppTheme.spacing16),
    this.margin = const EdgeInsets.only(bottom: AppTheme.spacing12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.border),
      ),
      child: child,
    );
  }
}
