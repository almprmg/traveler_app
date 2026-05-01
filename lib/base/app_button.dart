import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final ButtonSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final IconData? icon;
  final Widget? widgetIcon;
  final IconPosition iconPosition;
  final double? width;
  final double borderRadius;
  final double borderWidth;
  final Color? iconColor;
  final double? iconSize;
  final double? textSize;
  final List<Color>? gradientColors;

  const AppButton({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.widgetIcon,
    this.iconPosition = IconPosition.start,
    this.width,
    this.borderRadius = 8.0,
    this.iconColor,
    this.iconSize,
    this.textSize,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = _getButtonHeight();
    final padding = _getPadding();
    final isDisabled = onPressed == null && !isLoading;

    return SizedBox(
      width: width,
      height: buttonHeight,
      child: _buildButton(context, padding, isDisabled),
    );
  }

  Widget _buildButton(
    BuildContext context,
    EdgeInsets padding,
    bool isDisabled,
  ) {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? () {} : (isDisabled ? null : onPressed),
          style:
              ElevatedButton.styleFrom(
                backgroundColor: isLoading
                    ? (backgroundColor ?? AppTheme.primary).withValues(
                        alpha: 0.8,
                      )
                    : backgroundColor ?? AppTheme.primary,
                foregroundColor: textColor ?? AppTheme.textOnPrimary,
                disabledBackgroundColor: AppTheme.borderMedium,
                disabledForegroundColor: AppTheme.textTertiary,
                elevation: 0,
                padding: padding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ).copyWith(
                elevation: WidgetStateProperty.all(0),
                overlayColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.hovered)) {
                    return AppTheme.textOnPrimary.withValues(alpha: 0.1);
                  }
                  if (states.contains(WidgetState.pressed)) {
                    return AppTheme.textOnPrimary.withValues(alpha: 0.2);
                  }
                  return null;
                }),
              ),
          child: _buildButtonContent(
            isDisabled ? AppTheme.textTertiary : AppTheme.textOnPrimary,
          ),
        );

      case ButtonType.secondary:
        return OutlinedButton(
          onPressed: isLoading ? () {} : (isDisabled ? null : onPressed),
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? AppTheme.textPrimary,
            disabledForegroundColor: AppTheme.textTertiary,
            backgroundColor: backgroundColor ?? Colors.white,
            side: BorderSide(
              color: isDisabled
                  ? AppTheme.borderMedium
                  : (borderColor ?? AppTheme.border),
              width: borderWidth,
            ),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: _buildButtonContent(
            isDisabled ? AppTheme.textTertiary : AppTheme.textPrimary,
          ),
        );

      case ButtonType.ghost:
        return OutlinedButton(
          onPressed: isLoading ? () {} : (isDisabled ? null : onPressed),
          style:
              OutlinedButton.styleFrom(
                backgroundColor:
                    backgroundColor ??
                    AppTheme.borderDark.withValues(alpha: 0.2),
                foregroundColor: textColor ?? AppTheme.textPrimary,
                disabledBackgroundColor: AppTheme.border.withValues(alpha: 0.3),
                disabledForegroundColor: AppTheme.textTertiary,
                side: BorderSide(
                  color: isDisabled
                      ? AppTheme.borderMedium.withValues(alpha: 0.5)
                      : (borderColor ?? AppTheme.border.withValues(alpha: 0.6)),
                  width: borderWidth,
                ),
                elevation: 0,
                padding: padding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ).copyWith(
                elevation: WidgetStateProperty.all(0),
                overlayColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.hovered)) {
                    return AppTheme.textPrimary.withValues(alpha: 0.03);
                  }
                  if (states.contains(WidgetState.pressed)) {
                    return AppTheme.textPrimary.withValues(alpha: 0.06);
                  }
                  return null;
                }),
              ),
          child: _buildButtonContent(
            isDisabled ? AppTheme.textTertiary : AppTheme.textPrimary,
          ),
        );

      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? () {} : (isDisabled ? null : onPressed),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.primary,
            disabledForegroundColor: AppTheme.textTertiary,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: _buildButtonContent(
            isDisabled ? AppTheme.textTertiary : AppTheme.primary,
          ),
        );

      case ButtonType.danger:
        return ElevatedButton(
          onPressed: isLoading ? () {} : (isDisabled ? null : onPressed),
          style:
              ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: AppTheme.textOnPrimary,
                disabledBackgroundColor: AppTheme.borderMedium,
                disabledForegroundColor: AppTheme.textTertiary,
                elevation: 0,
                padding: padding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ).copyWith(
                elevation: WidgetStateProperty.all(0),
                overlayColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.hovered)) {
                    return AppTheme.textOnPrimary.withValues(alpha: 0.1);
                  }
                  if (states.contains(WidgetState.pressed)) {
                    return AppTheme.textOnPrimary.withValues(alpha: 0.2);
                  }
                  return null;
                }),
              ),
          child: _buildButtonContent(
            isDisabled ? AppTheme.textTertiary : AppTheme.textOnPrimary,
          ),
        );

      case ButtonType.success:
        return ElevatedButton(
          onPressed: isLoading ? () {} : (isDisabled ? null : onPressed),
          style:
              ElevatedButton.styleFrom(
                backgroundColor: AppTheme.success,
                foregroundColor: AppTheme.textOnPrimary,
                disabledBackgroundColor: AppTheme.borderMedium,
                disabledForegroundColor: AppTheme.textTertiary,
                elevation: 0,
                padding: padding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ).copyWith(
                elevation: WidgetStateProperty.all(0),
                overlayColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.hovered)) {
                    return AppTheme.textOnPrimary.withValues(alpha: 0.1);
                  }
                  if (states.contains(WidgetState.pressed)) {
                    return AppTheme.textOnPrimary.withValues(alpha: 0.2);
                  }
                  return null;
                }),
              ),
          child: _buildButtonContent(
            isDisabled ? AppTheme.textTertiary : AppTheme.textOnPrimary,
          ),
        );

      case ButtonType.gradient:
        return _GradientButton(
          onPressed: isLoading ? () {} : (isDisabled ? null : onPressed),
          padding: padding,
          borderRadius: borderRadius,
          isDisabled: isDisabled,
          gradientColors: gradientColors,
          child: _buildButtonContent(
            isDisabled ? AppTheme.textTertiary : AppTheme.textOnPrimary,
          ),
        );
    }
  }

  Widget _buildButtonContent(Color textColor) {
    if (isLoading) {
      return SpinKitThreeBounce(color: textColor, size: _getLoadingSize());
    }

    final textStyle = _getTypographyStyle();
    final styledText =
        (textSize != null
                ? AppTypography.withColor(
                    textStyle,
                    textColor,
                  ).copyWith(fontSize: textSize)
                : AppTypography.withColor(textStyle, textColor))
            .copyWith(fontFamily: AppTheme.fontFamily);

    if (icon != null || widgetIcon != null) {
      final iconActualColor = iconColor ?? textColor;
      final iconActualSize = iconSize ?? _getIconSize();
      final displayIcon =
          widgetIcon ??
          Icon(icon, size: iconActualSize, color: iconActualColor);
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: iconPosition == IconPosition.start
            ? [
                displayIcon,
                const SizedBox(width: AppTheme.spacing8),
                Text(text, style: styledText),
              ]
            : [
                Text(text, style: styledText),
                const SizedBox(width: AppTheme.spacing8),
                displayIcon,
              ],
      );
    }

    return Text(text, style: styledText);
  }

  TextStyle _getTypographyStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTypography.buttonSmall;
      case ButtonSize.medium:
        return AppTypography.buttonMedium;
      case ButtonSize.large:
        return AppTypography.buttonLarge;
    }
  }

  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return 38;
      case ButtonSize.medium:
        return 50;
      case ButtonSize.large:
        return 58;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing12,
          vertical: AppTheme.spacing8,
        );
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing16,
          vertical: AppTheme.spacing12,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing24,
          vertical: AppTheme.spacing16,
        );
    }
  }

  double _getLoadingSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 18;
      case ButtonSize.large:
        return 20;
    }
  }
}

class _GradientButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final double borderRadius;
  final bool isDisabled;
  final Widget child;
  final List<Color>? gradientColors;

  const _GradientButton({
    required this.onPressed,
    required this.padding,
    required this.borderRadius,
    required this.isDisabled,
    required this.child,
    this.gradientColors,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: widget.padding,
          decoration: BoxDecoration(
            gradient: widget.isDisabled
                ? const LinearGradient(
                    colors: [AppTheme.borderMedium, AppTheme.borderMedium],
                  )
                : _buildGradient(),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.isDisabled ? null : AppTheme.lightShadow,
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }

  LinearGradient _buildGradient() {
    final baseColors =
        widget.gradientColors ?? [AppTheme.primary, AppTheme.primaryLight];

    if (_isPressed) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: baseColors
            .map((color) => color.withValues(alpha: 0.8))
            .toList(),
      );
    }

    if (_isHovered) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: baseColors
            .map((color) => color.withValues(alpha: 0.9))
            .toList(),
      );
    }

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: baseColors,
    );
  }
}

enum ButtonType { primary, secondary, text, danger, ghost, success, gradient }

enum ButtonSize { small, medium, large }

enum IconPosition { start, end }
