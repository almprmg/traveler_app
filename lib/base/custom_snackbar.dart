import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

enum SnackType { success, error, info }

/// Project-wide toast. Renders as a translucent dark pill at the top of the
/// screen with a small coloured icon (state indicator) followed by the
/// message — one short, glanceable line. Multiple calls cancel the
/// previous toast so messages never stack.
class GlobalSnackBar {
  // Keep [useToast], [snackPosition] and [toastGravity] on the signature so
  // existing callers across the project keep compiling. They no longer
  // change the visual style — every toast goes through the same overlay.
  static OverlayEntry? _entry;
  static AnimationController? _controller;

  static void show(
    String message,
    SnackType type, {
    bool useToast = true,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    ToastGravity toastGravity = ToastGravity.TOP,
  }) {
    if (message.isEmpty) return;
    final ctx = Get.context;
    if (ctx == null) return;

    _dismiss();

    final overlay = Overlay.maybeOf(ctx, rootOverlay: true);
    if (overlay == null) return;

    final controller = AnimationController(
      vsync: Navigator.of(ctx),
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _controller = controller;

    final entry = OverlayEntry(
      builder: (context) =>
          _ToastView(message: message.tr, type: type, animation: controller),
    );
    _entry = entry;

    overlay.insert(entry);
    controller.forward();

    final lifetime = type == SnackType.error
        ? const Duration(milliseconds: 3200)
        : const Duration(milliseconds: 2200);

    Future.delayed(lifetime, () {
      // Only dismiss if this is still the active toast — a newer call
      // could have replaced it already.
      if (_entry == entry) _dismiss();
    });
  }

  static void _dismiss() {
    final entry = _entry;
    final controller = _controller;
    _entry = null;
    _controller = null;
    if (entry == null) return;
    if (controller == null) {
      entry.remove();
      return;
    }
    controller.reverse().whenComplete(() {
      entry.remove();
      controller.dispose();
    });
  }

  static void showSafe(
    String message,
    SnackType type, {
    bool useToast = false,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    ToastGravity toastGravity = ToastGravity.TOP,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      show(
        message,
        type,
        useToast: useToast,
        snackPosition: snackPosition,
        toastGravity: toastGravity,
      );
    });
  }

  static void showDelayed(
    String message,
    SnackType type, {
    Duration delay = Duration.zero,
    bool useToast = false,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    ToastGravity toastGravity = ToastGravity.TOP,
  }) {
    Future.delayed(delay, () {
      show(
        message,
        type,
        useToast: useToast,
        snackPosition: snackPosition,
        toastGravity: toastGravity,
      );
    });
  }
}

class _ToastView extends StatelessWidget {
  final String message;
  final SnackType type;
  final Animation<double> animation;

  const _ToastView({
    required this.message,
    required this.type,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final slide = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

    return Positioned(
      top: mediaQuery.padding.top + 12,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: slide,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 16, 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StateIcon(type: type),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          message,
                          style: AppTypography.bodyMedium.copyWith(
                            fontFamily: AppTheme.fontFamily,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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

class _StateIcon extends StatelessWidget {
  final SnackType type;
  const _StateIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (type) {
      SnackType.success => (
        AppTheme.success,
        HugeIcons.strokeRoundedCheckmarkCircle02,
      ),
      SnackType.error => (AppTheme.error, HugeIcons.strokeRoundedAlert02),
      SnackType.info => (
        AppTheme.primaryLight,
        HugeIcons.strokeRoundedInformationCircle,
      ),
    };

    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: HugeIcon(icon: icon, size: 16, color: color),
    );
  }
}
