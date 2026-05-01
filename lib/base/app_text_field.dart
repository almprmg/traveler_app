import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

/// Global text field with thin border + smooth focus ring.
class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        boxShadow: _isFocused
            ? [
                const BoxShadow(
                  color: AppTheme.white,
                  blurRadius: 0,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.10),
                  blurRadius: 0,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.03),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : [],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        validator: widget.validator,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        readOnly: widget.readOnly,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onSubmitted,
        style: AppTypography.bodyMedium.copyWith(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          prefixIconConstraints: widget.prefixIconConstraints,
          suffixIconConstraints: widget.suffixIconConstraints,
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radius12),
            borderSide: const BorderSide(color: AppTheme.border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radius12),
            borderSide: const BorderSide(color: AppTheme.primary, width: 1),
          ),
        ),
      ),
    );
  }
}
