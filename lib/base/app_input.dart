import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/util/app_theme.dart';

class CustomInputField extends StatefulWidget {
  // Basic properties
  final String? label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;

  // Input configuration
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;

  // Icons and widgets
  final IconData? prefixIcon;
  final Widget? prefix;
  final IconData? suffixIcon;
  final Widget? suffix;
  final VoidCallback? onSuffixIconTap;

  // Styling
  final TextStyle? style;
  final double borderRadius;
  final Color? fillColor;
  final bool showBorder;

  /// Autofill hints (e.g. [AutofillHints.oneTimeCode] for OTP).
  final Iterable<String>? autofillHints;

  /// Force a specific text direction regardless of locale (e.g. phone numbers).
  final TextDirection? textDirection;

  /// Override text alignment (e.g. center for OTP cells).
  final TextAlign? textAlign;

  /// Force error border without using the validator (e.g. server-side errors).
  final bool hasError;

  // Type-based configuration
  final InputFieldType type;

  const CustomInputField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.onSuffixIconTap,
    this.style,
    this.borderRadius = 12.0,
    this.fillColor,
    this.showBorder = true,
    this.autofillHints,
    this.textDirection,
    this.textAlign,
    this.hasError = false,
    this.type = InputFieldType.text,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late FocusNode _focusNode;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  bool get _isFocused => _focusNode.hasFocus;
  bool get _isRTL => Get.locale?.languageCode == 'ar';

  // Get configuration based on type
  _TypeConfig get _config => _TypeConfig.getConfig(widget.type);

  /// Search inputs always render fully rounded — every other type respects
  /// whatever [widget.borderRadius] the call site set.
  double get _resolvedRadius =>
      widget.type == InputFieldType.search ? 999 : widget.borderRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_label != null) ...[
          Text(
            _label!,
            style: AppTypography.withColor(
              AppTypography.withWeight(
                AppTypography.labelLarge,
                AppTypography.medium,
              ),
              _isFocused ? AppTheme.textPrimary : AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          validator: _validator,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onFieldSubmitted: widget.onSubmitted,
          autofillHints: widget.autofillHints,
          keyboardType: widget.keyboardType ?? _config.keyboardType,
          textInputAction: widget.textInputAction ?? _config.textInputAction,
          obscureText: widget.type == InputFieldType.password
              ? !_isPasswordVisible
              : widget.obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.maxLines ?? _config.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters ?? _config.inputFormatters,
          autofocus: widget.autofocus,
          style:
              widget.style ??
              AppTypography.withColor(
                AppTypography.bodyLarge,
                widget.enabled ? AppTheme.textPrimary : AppTheme.textTertiary,
              ),
          textDirection: widget.textDirection,
          textAlign:
              widget.textAlign ??
              (widget.textDirection == TextDirection.ltr
                  ? TextAlign.left
                  : (_isRTL ? TextAlign.right : TextAlign.left)),
          decoration: InputDecoration(
            hintText: widget.hint ?? _config.hint,
            hintStyle: AppTypography.withColor(
              AppTypography.bodyMedium,
              AppTheme.textTertiary,
            ),
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            counterText: '',
            prefixIcon: _prefixIcon,
            prefix: widget.prefix,
            // Let the search icon render at its declared size instead of
            // being centered inside Material's default 48×48 slot.
            prefixIconConstraints: widget.type == InputFieldType.search
                ? const BoxConstraints(minWidth: 0, minHeight: 0)
                : null,
            suffixIcon: _suffixIcon,
            suffixIconConstraints: widget.suffix != null
                ? const BoxConstraints(minWidth: 0, minHeight: 0)
                : null,
            filled: true,
            fillColor: widget.fillColor ?? AppTheme.white,
            focusedBorder: widget.showBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_resolvedRadius),
                    borderSide: BorderSide(
                      color: widget.hasError
                          ? AppTheme.error
                          : AppTheme.primary,
                      width: 1.0,
                    ),
                  )
                : InputBorder.none,
            enabledBorder: widget.showBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_resolvedRadius),
                    borderSide: BorderSide(
                      color: widget.hasError ? AppTheme.error : AppTheme.border,
                      width: 1.0,
                    ),
                  )
                : InputBorder.none,
            focusedErrorBorder: widget.showBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_resolvedRadius),
                    borderSide: const BorderSide(
                      color: AppTheme.error,
                      width: 1.0,
                    ),
                  )
                : InputBorder.none,
            errorBorder: widget.showBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_resolvedRadius),
                    borderSide: const BorderSide(
                      color: AppTheme.error,
                      width: 1.0,
                    ),
                  )
                : InputBorder.none,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: widget.type == InputFieldType.search
                  ? 10.0
                  : ((widget.maxLines ?? 1) > 1
                        ? AppTheme.spacing20
                        : AppTheme.spacing16),
            ),
          ),
        ),
        if (_helperOrError != null) ...[
          const SizedBox(height: AppTheme.spacing2),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _isRTL ? AppTheme.spacing8 : AppTheme.spacing12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_errorMessage != null)
                  Expanded(
                    child: Text(
                      _helperOrError!,
                      style: AppTypography.withColor(
                        AppTypography.labelSmall,
                        _errorMessage != null
                            ? AppTheme.error
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String? get _label => widget.label;
  String? get _helperOrError => _errorMessage ?? widget.helperText;

  String? Function(String?)? get _validator {
    final validator = widget.validator ?? _config.validator;
    if (validator == null) return null;

    return (value) {
      final error = validator(value);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _errorMessage = error);
      });
      return error;
    };
  }

  Widget? get _prefixIcon {
    if (widget.prefix != null) return null;

    // Check for custom widget from config first
    if (_config.prefixWidget != null) return _config.prefixWidget;

    final icon = widget.prefixIcon ?? _config.prefixIcon;
    if (icon == null) return null;
    return Icon(icon, color: AppTheme.textTertiary, size: 20);
  }

  Widget? get _suffixIcon {
    // Widget suffix → render at the trailing edge like a suffixIcon
    if (widget.suffix != null) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(end: 12),
        child: widget.suffix,
      );
    }

    IconData? icon;
    VoidCallback? onTap;

    if (widget.type == InputFieldType.password) {
      final hugeIcon = _isPasswordVisible
          ? HugeIcons.strokeRoundedViewOff
          : HugeIcons.strokeRoundedView;
      onTap = () => setState(() => _isPasswordVisible = !_isPasswordVisible);
      return GestureDetector(
        onTap: onTap,
        child: HugeIcon(icon: hugeIcon, color: AppTheme.textTertiary, size: 20),
      );
    } else {
      icon = widget.suffixIcon;
      onTap = widget.onSuffixIconTap;
    }

    if (icon == null) return null;
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppTheme.textTertiary, size: 20),
    );
  }
}

class _TypeConfig {
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final String? hint;
  final String? label;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;

  const _TypeConfig({
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.prefixWidget,
    this.hint,
    this.label,
    this.validator,
    this.inputFormatters,
    this.maxLines,
  });

  static _TypeConfig getConfig(InputFieldType type) {
    switch (type) {
      case InputFieldType.email:
        return _TypeConfig(
          keyboardType: TextInputType.emailAddress,
          hint: 'email_hint'.tr,
          label: 'email_label'.tr,
          validator: _Validators.email,
        );

      case InputFieldType.password:
        return _TypeConfig(
          keyboardType: TextInputType.visiblePassword,
          prefixIcon: Icons.lock_outline,
          hint: 'password_hint'.tr,
          label: 'password_label'.tr,
          validator: _Validators.password,
        );

      case InputFieldType.phone:
        return _TypeConfig(
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
          hint: 'phone_hint'.tr,
          label: 'phone_label'.tr,
          validator: _Validators.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        );

      case InputFieldType.number:
        return _TypeConfig(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hint: 'number_hint'.tr,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
        );

      case InputFieldType.multiline:
        return _TypeConfig(
          keyboardType: TextInputType.multiline,
          hint: 'multiline_hint'.tr,
          label: 'message_label'.tr,
          maxLines: 4,
        );

      case InputFieldType.search:
        return _TypeConfig(
          keyboardType: TextInputType.text,
          hint: 'search_hint'.tr,
          label: 'search_label'.tr,
          textInputAction: TextInputAction.search,
          prefixWidget: const Padding(
            padding: EdgeInsetsDirectional.only(start: 14, end: 8),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              size: 16,
              color: AppTheme.textSecondary,
            ),
          ),
        );

      default:
        return const _TypeConfig(keyboardType: TextInputType.text);
    }
  }
}

class _Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'email_required'.tr;
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'email_invalid'.tr;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'password_required'.tr;
    if (value.length < 6) return 'password_min_length'.tr;
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'phone_required'.tr;
    if (value.length < 10) return 'phone_invalid'.tr;
    return null;
  }
}

enum InputFieldType {
  text,
  email,
  password,
  phone,
  number,
  multiline,
  search,
  outlined,
}
