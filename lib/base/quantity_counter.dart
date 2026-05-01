import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shimmer/shimmer.dart';

import 'package:traveler_app/base/app_bottom_sheet.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/base/app_input.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

enum QuantityCounterSize { large, medium, small }

class _SizeConfig {
  final double btnSize;
  final double iconSize;
  final double displayHeight;
  final double displayMinWidth;
  final double displayMargin;
  final double displayPadding;
  final double arrowSize;
  final double shimmerWidth;
  final TextStyle quantityStyle;

  const _SizeConfig({
    required this.btnSize,
    required this.iconSize,
    required this.displayHeight,
    required this.displayMinWidth,
    required this.displayMargin,
    required this.displayPadding,
    required this.arrowSize,
    required this.shimmerWidth,
    required this.quantityStyle,
  });
}

class QuantityCounter extends StatefulWidget {
  final int quantity;
  final int minQuantity;
  final int? maxQuantity;
  final ValueChanged<int> onChanged;
  final bool isLoading;
  final String? productName;
  final QuantityCounterSize size;

  const QuantityCounter({
    super.key,
    required this.quantity,
    this.minQuantity = 1,
    this.maxQuantity,
    required this.onChanged,
    this.isLoading = false,
    this.productName,
    this.size = QuantityCounterSize.large,
  });

  @override
  State<QuantityCounter> createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  bool get _canIncrement =>
      !widget.isLoading &&
      (widget.maxQuantity == null || widget.quantity < widget.maxQuantity!);

  bool get _canDecrement =>
      !widget.isLoading && widget.quantity > widget.minQuantity;

  void _showQuantityBottomSheet() {
    if (widget.isLoading) return;

    Get.bottomSheet(
      _QuantitySheetContent(
        currentQuantity: widget.quantity,
        minQuantity: widget.minQuantity,
        maxQuantity: widget.maxQuantity,
        productName: widget.productName,
        onSelected: (value) {
          Get.back();
          widget.onChanged(value);
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  _SizeConfig get _cfg {
    switch (widget.size) {
      case QuantityCounterSize.small:
        return _SizeConfig(
          btnSize: 30,
          iconSize: 15,
          displayHeight: 30,
          displayMinWidth: 48,
          displayMargin: 4,
          displayPadding: 4,
          arrowSize: 16,
          shimmerWidth: 22,
          quantityStyle: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        );
      case QuantityCounterSize.medium:
        return _SizeConfig(
          btnSize: 34,
          iconSize: 17,
          displayHeight: 34,
          displayMinWidth: 58,
          displayMargin: 6,
          displayPadding: 6,
          arrowSize: 18,
          shimmerWidth: 26,
          quantityStyle: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        );
      case QuantityCounterSize.large:
        return _SizeConfig(
          btnSize: 40,
          iconSize: 20,
          displayHeight: 40,
          displayMinWidth: 68,
          displayMargin: 8,
          displayPadding: 8,
          arrowSize: 20,
          shimmerWidth: 32,
          quantityStyle: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButton(
          icon: HugeIcons.strokeRoundedMinusSign,
          enabled: _canDecrement,
          onTap: () => widget.onChanged(widget.quantity - 1),
        ),
        _buildQuantityDisplay(),
        _buildButton(
          icon: HugeIcons.strokeRoundedAdd01,
          enabled: _canIncrement,
          onTap: () => widget.onChanged(widget.quantity + 1),
        ),
      ],
    );
  }

  Widget _buildButton({
    required List<List<dynamic>> icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final cfg = _cfg;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppTheme.radius8),
      child: Container(
        width: cfg.btnSize,
        height: cfg.btnSize,
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(AppTheme.radius8),
          border: Border.all(color: AppTheme.border),
        ),
        alignment: Alignment.center,
        child: widget.isLoading
            ? _buildShimmer(cfg.iconSize - 2)
            : HugeIcon(
                icon: icon,
                size: cfg.iconSize,
                color: enabled
                    ? AppTheme.textPrimary
                    : AppTheme.textTertiary.withValues(alpha: 0.4),
              ),
      ),
    );
  }

  Widget _buildQuantityDisplay() {
    final cfg = _cfg;
    final textLength = '${widget.quantity}'.length;
    final baseMin = cfg.displayMinWidth;
    final displayWidth =
        (textLength < 2 ? baseMin : baseMin - 10 + (textLength * 10))
            .toDouble();

    return InkWell(
      onTap: widget.isLoading ? null : _showQuantityBottomSheet,
      borderRadius: BorderRadius.circular(AppTheme.radius8),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: cfg.displayMargin),
        constraints: BoxConstraints(
          minWidth: baseMin,
          maxWidth: displayWidth.clamp(baseMin, baseMin + 40),
        ),
        height: cfg.displayHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radius8),
          border: Border.all(color: AppTheme.border, width: 0.5),
        ),
        padding: EdgeInsets.symmetric(horizontal: cfg.displayPadding),
        child: widget.isLoading
            ? _buildShimmer(cfg.shimmerWidth)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${widget.quantity}', style: cfg.quantityStyle),
                  const SizedBox(width: 2),
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowDown01,
                    size: cfg.arrowSize,
                    color: AppTheme.textSecondary,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildShimmer(double width) {
    return Shimmer.fromColors(
      baseColor: AppTheme.shimmerBase,
      highlightColor: AppTheme.shimmerHighlight,
      child: Container(
        width: width,
        height: 18,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radius4),
        ),
      ),
    );
  }
}

// ─── Sheet content as separate widget to manage its own state ────────────────

class _QuantitySheetContent extends StatefulWidget {
  final int currentQuantity;
  final int minQuantity;
  final int? maxQuantity;
  final String? productName;
  final ValueChanged<int> onSelected;

  const _QuantitySheetContent({
    required this.currentQuantity,
    required this.minQuantity,
    this.maxQuantity,
    this.productName,
    required this.onSelected,
  });

  @override
  State<_QuantitySheetContent> createState() => _QuantitySheetContentState();
}

class _QuantitySheetContentState extends State<_QuantitySheetContent> {
  late final TextEditingController _customController;

  @override
  void initState() {
    super.initState();
    _customController = TextEditingController();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: 'select_quantity'.tr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          if (widget.productName != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacing16,
                AppTheme.spacing8,
                AppTheme.spacing16,
                0,
              ),
              child: Text(
                widget.productName!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          const Divider(height: 1, color: AppTheme.border),

          // Quick selection grid (1–30)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 260),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: AppTheme.spacing8,
                  mainAxisSpacing: AppTheme.spacing8,
                  childAspectRatio: 1.2,
                ),
                itemCount: 30,
                itemBuilder: (_, index) {
                  final value = index + 1;
                  final isSelected = value == widget.currentQuantity;
                  final isDisabled =
                      (widget.maxQuantity != null &&
                          value > widget.maxQuantity!) ||
                      value < widget.minQuantity;

                  return Opacity(
                    opacity: isDisabled ? 0.3 : 1.0,
                    child: AppButton(
                      text: '$value',
                      type: isSelected ? ButtonType.gradient : ButtonType.ghost,
                      size: ButtonSize.small,
                      onPressed: isDisabled
                          ? null
                          : () => widget.onSelected(value),
                      borderRadius: AppTheme.radius8,
                    ),
                  );
                },
              ),
            ),
          ),

          const Divider(height: 1, color: AppTheme.border),

          // Custom input
          Padding(
            padding: EdgeInsets.only(
              left: AppTheme.spacing16,
              right: AppTheme.spacing16,
              top: AppTheme.spacing16,
              bottom:
                  MediaQuery.of(context).viewInsets.bottom + AppTheme.spacing16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'custom_quantity'.tr,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Gap(AppTheme.spacing8),
                Row(
                  children: [
                    Expanded(
                      child: CustomInputField(
                        controller: _customController,
                        type: InputFieldType.number,
                        hint: 'enter_quantity'.tr,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const Gap(AppTheme.spacing12),
                    AppButton(
                      text: 'apply'.tr,
                      type: ButtonType.gradient,
                      size: ButtonSize.medium,
                      onPressed: () {
                        final value = int.tryParse(_customController.text);
                        if (value != null && value >= widget.minQuantity) {
                          if (widget.maxQuantity == null ||
                              value <= widget.maxQuantity!) {
                            widget.onSelected(value);
                          }
                        }
                      },
                      borderRadius: AppTheme.radius8,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
