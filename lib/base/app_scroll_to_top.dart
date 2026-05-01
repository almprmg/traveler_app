import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';

class AppScrollToTop extends StatefulWidget {
  final ScrollController scrollController;
  final double threshold;

  /// Set to false when the parent already handles positioning
  /// (e.g. PositionedDirectional). Default true adds automatic
  /// bottom offset above the floating nav bar.
  final bool withNavOffset;

  const AppScrollToTop({
    super.key,
    required this.scrollController,
    this.threshold = 300,
    this.withNavOffset = true,
  });

  @override
  State<AppScrollToTop> createState() => _AppScrollToTopState();
}

class _AppScrollToTopState extends State<AppScrollToTop> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final show = widget.scrollController.offset > widget.threshold;
    if (show != _show) {
      setState(() => _show = show);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.withNavOffset) return _buildFab();
    final systemBottom = MediaQuery.of(context).padding.bottom;
    // nav bar margin(24) + inner height(~58) + desired gap(36)
    return Padding(
      padding: EdgeInsets.only(bottom: systemBottom + 118.0),
      child: _buildFab(),
    );
  }

  Widget _buildFab() {
    return AnimatedScale(
      scale: _show ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedOpacity(
        opacity: _show ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: FloatingActionButton.small(
              heroTag: 'scrollToTopFAB_${widget.hashCode}',
              onPressed: () {
                widget.scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              backgroundColor: AppTheme.background.withValues(alpha: 0.8),
              elevation: 0,
              shape: CircleBorder(
                side: BorderSide(
                  color: Colors.black.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowUp01,
                color: Colors.black45,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
