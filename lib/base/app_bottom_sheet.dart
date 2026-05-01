import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/custom_snackbar.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class AppBottomSheet extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final Widget? footer;
  final double? height;
  final bool showHandle;
  final Widget? action;

  /// true  → glassmorphism theme (white 0.35 alpha) — like the login/auth sheet
  /// false → standard theme (white 0.88 alpha) — default
  final bool withBackgroundTheme;

  final double horizontalInset;

  /// When false, hides the close (×) button in the header.
  final bool showCloseButton;

  /// When provided, overrides the default white overlay color of the sheet.
  final Color? backgroundColor;

  /// When true, child shrinks to its intrinsic height (no Flexible wrapper).
  final bool shrinkContent;

  const AppBottomSheet({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.footer,
    this.height,
    this.showHandle = true,
    this.action,
    this.withBackgroundTheme = false,
    this.horizontalInset = 10,
    this.showCloseButton = true,
    this.backgroundColor,
    this.shrinkContent = false,
  });

  double get _overlayAlpha => withBackgroundTheme ? 0.35 : 0.88;

  Color get _handleColor => withBackgroundTheme
      ? AppTheme.white.withValues(alpha: 0.6)
      : AppTheme.border;

  Color get _closeButtonBg => withBackgroundTheme
      ? AppTheme.white.withValues(alpha: 0.5)
      : AppTheme.background;

  Color get _closeButtonIcon =>
      withBackgroundTheme ? AppTheme.textPrimary : AppTheme.textSecondary;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final keyboardOpen = keyboardHeight > 0;
    // The modal bottom sheet route already lifts the sheet by
    // `viewInsets.bottom` when the keyboard opens — adding `keyboardHeight`
    // as inner padding here on top of that double-counts and leaves a big
    // empty strip between the sheet and the keyboard. So when the
    // keyboard is up we drop the bottom padding entirely; otherwise we
    // keep room for the home-indicator + a small breath.
    final bottomPadding = keyboardOpen ? 0.0 : mediaQuery.padding.bottom + 12;
    final screenHeight = mediaQuery.size.height;
    final maxHeight = height ?? (screenHeight - keyboardHeight) * 0.85;

    final sheet = Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalInset,
        0,
        horizontalInset,
        bottomPadding,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/loginbackground.webp'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radius24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radius24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      backgroundColor ??
                      AppTheme.white.withValues(alpha: _overlayAlpha),
                  borderRadius: BorderRadius.circular(AppTheme.radius24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle
                    if (showHandle) ...[
                      const Gap(AppTheme.spacing12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _handleColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],

                    // Header
                    if (title != null) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppTheme.spacing16,
                          AppTheme.spacing12,
                          AppTheme.spacing16,
                          AppTheme.spacing8,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (title!.isNotEmpty)
                                    Text(
                                      title!,
                                      style: AppTypography.h4.copyWith(
                                        fontWeight: AppTypography.semiBold,
                                      ),
                                    ),
                                  if (subtitle != null) ...[
                                    if (title!.isNotEmpty)
                                      const Gap(AppTheme.spacing4),
                                    Text(
                                      subtitle!,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (action != null) ...[
                              action!,
                              const Gap(AppTheme.spacing8),
                            ],
                            if (showCloseButton)
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: _closeButtonBg,
                                    borderRadius: BorderRadius.circular(
                                      AppTheme.radius8,
                                    ),
                                  ),
                                  child: HugeIcon(
                                    icon: HugeIcons.strokeRoundedCancel01,
                                    size: 17,
                                    color: _closeButtonIcon,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ] else if (showHandle)
                      const Gap(AppTheme.spacing4),

                    // Content
                    shrinkContent ? child : Flexible(child: child),

                    // Footer
                    if (footer != null) footer!,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return sheet;
  }

  static Future<T?> showWithBarrierToast<T>({
    String? title,
    String? subtitle,
    required Widget child,
    Widget? footer,
    double? height,
    Widget? action,
    bool withBackgroundTheme = false,
    double horizontalInset = 10,
    bool showCloseButton = true,
    bool showHandle = true,
    Color? backgroundColor,
    String barrierToastMessage = '',
  }) {
    return showGeneralDialog<T>(
      context: Get.context!,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (ctx, a1, a2, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: a1, curve: Curves.easeOut)),
        child: child,
      ),
      pageBuilder: (ctx, _, __) => _BarrierConfirmSheet(
        barrierToastMessage: barrierToastMessage,
        sheet: AppBottomSheet(
          title: title,
          subtitle: subtitle,
          height: height,
          action: action,
          footer: footer,
          withBackgroundTheme: withBackgroundTheme,
          horizontalInset: horizontalInset,
          showCloseButton: showCloseButton,
          showHandle: showHandle,
          backgroundColor: backgroundColor,
          child: child,
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    String? title,
    String? subtitle,
    required Widget child,
    Widget? footer,
    double? height,
    Widget? action,
    bool withBackgroundTheme = false,
    double horizontalInset = 10,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showCloseButton = true,
    bool showHandle = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: Get.context!,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      // Barrier stays fixed — only the sheet slides up
      barrierColor: Colors.black54,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(Get.context!),
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 180),
      ),
      builder: (_) => AppBottomSheet(
        title: title,
        subtitle: subtitle,
        height: height,
        action: action,
        footer: footer,
        withBackgroundTheme: withBackgroundTheme,
        horizontalInset: horizontalInset,
        showCloseButton: showCloseButton,
        showHandle: showHandle,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }
}

class _BarrierConfirmSheet extends StatefulWidget {
  final Widget sheet;
  final String barrierToastMessage;

  const _BarrierConfirmSheet({
    required this.sheet,
    required this.barrierToastMessage,
  });

  @override
  State<_BarrierConfirmSheet> createState() => _BarrierConfirmSheetState();
}

class _BarrierConfirmSheetState extends State<_BarrierConfirmSheet> {
  DateTime? _lastBarrierTap;

  void _onBarrierTap() {
    final now = DateTime.now();
    if (_lastBarrierTap != null &&
        now.difference(_lastBarrierTap!) < const Duration(seconds: 2)) {
      Navigator.of(context).pop();
    } else {
      _lastBarrierTap = now;
      GlobalSnackBar.show(widget.barrierToastMessage, SnackType.info);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _onBarrierTap,
              child: Container(color: Colors.black54),
            ),
          ),
          AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: widget.sheet,
            ),
          ),
        ],
      ),
    );
  }
}
