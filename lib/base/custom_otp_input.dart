import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class CustomOtpInput extends StatefulWidget {
  final int length;
  final void Function(String)? onChanged;
  final void Function(String)? onCompleted;
  final bool hasError;
  final bool autofocus;

  const CustomOtpInput({
    super.key,
    this.length = 4,
    this.onChanged,
    this.onCompleted,
    this.hasError = false,
    this.autofocus = false,
  });

  @override
  State<CustomOtpInput> createState() => _CustomOtpInputState();
}

class _CustomOtpInputState extends State<CustomOtpInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = 8.0;
          final pinWidth =
              (constraints.maxWidth - gap * (widget.length - 1)) /
              widget.length;

          // Same visual as CustomInputField
          final base = PinTheme(
            width: pinWidth,
            height: 56,
            textStyle: AppTypography.bodyLarge.copyWith(
              color: AppTheme.textPrimary,
              fontFamily: AppTheme.fontFamily,
            ),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radius12),
              border: Border.all(color: AppTheme.border),
            ),
          );

          return Pinput(
            length: widget.length,
            controller: _controller,
            focusNode: _focusNode,
            autofillHints: const [AutofillHints.oneTimeCode],
            keyboardType: TextInputType.number,
            separatorBuilder: (_) => const SizedBox(width: gap),
            forceErrorState: widget.hasError,
            defaultPinTheme: base,
            focusedPinTheme: base.copyDecorationWith(
              border: Border.all(color: AppTheme.primary),
            ),
            submittedPinTheme: base.copyDecorationWith(
              border: Border.all(color: AppTheme.primary),
            ),
            errorPinTheme: base.copyDecorationWith(
              border: Border.all(color: AppTheme.error),
            ),
            onChanged: widget.onChanged,
            onCompleted: widget.onCompleted,
          );
        },
      ),
    );
  }
}
