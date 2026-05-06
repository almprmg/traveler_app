import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';

/// Unified search input used across listing screens (tours/hotels/etc).
///
/// Renders a [TextField] with a leading search glyph; the icon size honours
/// [iconSize] because the leading slot is unconstrained
/// (`prefixIconConstraints` set to zero minimums).
class AppSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String? hintText;
  final double iconSize;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const AppSearchField({
    super.key,
    required this.onChanged,
    this.hintText,
    this.iconSize = 22,
    this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText ?? 'search_hint'.tr,
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppTheme.spacing16,
            end: AppTheme.spacing8,
          ),
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedSearch01,
            color: AppTheme.textTertiary,
            size: iconSize,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }
}
