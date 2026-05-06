import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_bottom_sheet.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class SortOption {
  final String key;
  final String label;
  const SortOption({required this.key, required this.label});
}

/// Opens an [AppBottomSheet] with a list of sort options as choice chips.
/// Calls [onApply] with the selected key (or `null` if cleared).
Future<void> showSortBottomSheet(
  BuildContext context, {
  required List<SortOption> options,
  required String? currentValue,
  required ValueChanged<String?> onApply,
}) {
  return AppBottomSheet.show<void>(
    title: 'sort_by'.tr,
    shrinkContent: true,
    child: _SortContent(
      options: options,
      initialValue: currentValue,
      onApply: onApply,
    ),
  );
}

class _SortContent extends StatefulWidget {
  final List<SortOption> options;
  final String? initialValue;
  final ValueChanged<String?> onApply;

  const _SortContent({
    required this.options,
    required this.initialValue,
    required this.onApply,
  });

  @override
  State<_SortContent> createState() => _SortContentState();
}

class _SortContentState extends State<_SortContent> {
  late String? _selected = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing20,
        0,
        AppTheme.spacing20,
        AppTheme.spacing16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppTheme.spacing8,
            runSpacing: AppTheme.spacing8,
            children: [
              for (final option in widget.options)
                _SortChip(
                  label: option.label,
                  selected: _selected == option.key,
                  onTap: () => setState(() {
                    _selected = _selected == option.key ? null : option.key;
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing20),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'clear_filters'.tr,
                  type: ButtonType.ghost,
                  borderRadius: AppTheme.radius24,
                  onPressed: () {
                    widget.onApply(null);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: AppButton(
                  text: 'apply'.tr,
                  type: ButtonType.gradient,
                  borderRadius: AppTheme.radius24,
                  onPressed: () {
                    widget.onApply(_selected);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppTheme.primary.withValues(alpha: 0.06)
          : AppTheme.backgroundLight,
      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing16,
            vertical: AppTheme.spacing8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.cardBorder,
              width: 0.75,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: selected ? AppTheme.primary : AppTheme.textPrimary,
              fontWeight: selected
                  ? AppTypography.bold
                  : AppTypography.semiBold,
            ),
          ),
        ),
      ),
    );
  }
}
