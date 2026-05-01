import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/base/custom_loader.dart';

class CustomFullScreenLoading extends StatefulWidget {
  final bool isVisible;
  final String? title;
  final String? subtitle;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double? indicatorSize;
  final Widget? customIndicator;
  final bool dismissible;
  final bool closeKeyboard;

  const CustomFullScreenLoading({
    super.key,
    required this.isVisible,
    this.title,
    this.subtitle,
    this.backgroundColor,
    this.indicatorColor,
    this.indicatorSize,
    this.customIndicator,
    this.dismissible = false,
    this.closeKeyboard = true,
  });

  @override
  State<CustomFullScreenLoading> createState() =>
      _CustomFullScreenLoadingState();
}

class _CustomFullScreenLoadingState extends State<CustomFullScreenLoading>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    if (widget.isVisible) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    // Close keyboard when loading starts
    if (widget.closeKeyboard) {
      _closeKeyboard();
    }

    _fadeController.forward();
    _scaleController.forward();
  }

  void _stopAnimations() {
    _fadeController.reverse();
    _scaleController.reverse();
  }

  void _closeKeyboard() {
    // Multiple methods to ensure keyboard closes
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void didUpdateWidget(CustomFullScreenLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _startAnimations();
      } else {
        _stopAnimations();
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return _fadeAnimation.value == 0.0
            ? const SizedBox.shrink()
            : Positioned.fill(
                child: Material(
                  color: (widget.backgroundColor ?? Colors.transparent)
                      .withValues(
                        alpha:
                            _fadeAnimation.value *
                            (widget.backgroundColor != null ? 1.0 : 0.0),
                      ),
                  child: GestureDetector(
                    onTap: widget.dismissible ? () {} : null,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: _buildLoadingContent(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget _buildLoadingContent() {
    final hasText = widget.title != null || widget.subtitle != null;
    final indicatorSize = widget.indicatorSize ?? 80;
    // Indicator-only state collapses to a tight glass square sized to the
    // loader (with even padding on all sides). When text is present the
    // box widens to accommodate it.
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: hasText
              ? const EdgeInsets.symmetric(horizontal: 32, vertical: 28)
              : const EdgeInsets.all(20),
          constraints: hasText
              ? const BoxConstraints(maxWidth: 340, minWidth: 300)
              : null,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: indicatorSize,
                height: indicatorSize,
                child: _buildLoadingIndicator(),
              ),
              if (widget.title != null) ...[
                const SizedBox(height: 24),
                Text(
                  widget.title!,
                  style: AppTypography.h5.copyWith(
                    color: Colors.white,
                    fontWeight: AppTypography.semiBold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (widget.subtitle != null) ...[
                const SizedBox(height: 12),
                Text(
                  widget.subtitle!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: AppTypography.regular,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (widget.customIndicator != null) {
      return widget.customIndicator!;
    }

    return CustomLoader(size: widget.indicatorSize ?? 80);
  }
}

// Utility class for easy usage
class LoadingOverlay {
  /// Routed through [Get.dialog] (not Flutter's [showDialog]) so that
  /// [Get.isDialogOpen] reports `true` while the loader is on screen and
  /// callers can safely close it later with [Get.back].
  static void show(
    BuildContext context, {
    String? title,
    String? subtitle,
    Color? backgroundColor,
    Color? indicatorColor,
    bool dismissible = false,
    bool closeKeyboard = true,
  }) {
    Get.dialog(
      CustomFullScreenLoading(
        isVisible: true,
        title: title,
        subtitle: subtitle,
        backgroundColor: backgroundColor,
        indicatorColor: indicatorColor,
        dismissible: dismissible,
        closeKeyboard: closeKeyboard,
      ),
      barrierDismissible: dismissible,
      barrierColor: Colors.transparent,
    );
  }

  static void hide(BuildContext context) {
    if (Get.isDialogOpen ?? false) Get.back();
  }
}

// Simplified wrapper widget for reactive usage
class ReactiveLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingTitle;
  final String? loadingSubtitle;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final bool closeKeyboard;

  const ReactiveLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingTitle,
    this.loadingSubtitle,
    this.backgroundColor,
    this.indicatorColor,
    this.closeKeyboard = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        CustomFullScreenLoading(
          isVisible: isLoading,
          title: loadingTitle,
          subtitle: loadingSubtitle,
          backgroundColor: backgroundColor,
          indicatorColor: indicatorColor,
          closeKeyboard: closeKeyboard,
        ),
      ],
    );
  }
}
