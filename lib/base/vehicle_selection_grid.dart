import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/base/app_input.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/base/skeleton_card.dart' show ShimmerBox;

/// A reusable grid selection widget used across all vehicle selection steps.
///
/// - Items **with** an icon: image fills the card, label appears below.
/// - Items **without** an icon: label is centered inside the card, nothing below.
class VehicleSelectionGrid<T> extends StatefulWidget {
  /// The full list of items to display.
  final List<T> items;

  /// Whether a loading indicator should be shown instead of the grid.
  final bool isLoading;

  /// The currently selected item (used for highlight). May be null.
  final T? selectedItem;

  /// Extracts the display label from an item.
  final String Function(T item) labelOf;

  /// Extracts the icon URL from an item. Return null / empty string if none.
  final String? Function(T item)? iconOf;

  /// Compares two items for equality (used for selected-state highlight).
  /// Defaults to `==` if not provided.
  final bool Function(T a, T b)? isEqual;

  /// Called when the user taps an item.
  final void Function(T item) onSelected;

  /// Keyboard type for the search field (default: text).
  final TextInputType searchKeyboardType;

  /// When true, items without an icon show the car SVG fallback inside the card
  /// and the label appears **below** — same layout as items that have an icon.
  /// When false (default), items without an icon show the label **inside** the card.
  final bool useFallbackIcon;

  /// Optional refresh callback shown in the empty-state.
  final VoidCallback? onRefresh;

  const VehicleSelectionGrid({
    super.key,
    required this.items,
    required this.labelOf,
    required this.onSelected,
    this.isLoading = false,
    this.selectedItem,
    this.iconOf,
    this.isEqual,
    this.searchKeyboardType = TextInputType.text,
    this.useFallbackIcon = false,
    this.onRefresh,
  });

  @override
  State<VehicleSelectionGrid<T>> createState() =>
      _VehicleSelectionGridState<T>();
}

class _VehicleSelectionGridState<T> extends State<VehicleSelectionGrid<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isSelected(T item) {
    if (widget.selectedItem == null) return false;
    if (widget.isEqual != null) {
      return widget.isEqual!(item, widget.selectedItem as T);
    }
    return item == widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? widget.items
        : widget.items.where((item) {
            return widget
                .labelOf(item)
                .toLowerCase()
                .contains(_query.toLowerCase());
          }).toList();

    return ColoredBox(
      color: AppTheme.background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing8),
            child: CustomInputField(
              controller: _searchController,
              type: InputFieldType.search,
              hint: 'search'.tr,
              keyboardType: widget.searchKeyboardType,
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: widget.isLoading
                ? _VehicleGridSkeleton(useFallbackIcon: widget.useFallbackIcon)
                : filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          'assets/json/emptybox.json',
                          width: 140,
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                        const Gap(AppTheme.spacing8),
                        Text(
                          'no_results_found'.tr,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const Gap(AppTheme.spacing12),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _query = '';
                              _searchController.clear();
                            });
                            widget.onRefresh?.call();
                          },
                          borderRadius: BorderRadius.circular(
                            AppTheme.radius12,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing16,
                              vertical: AppTheme.spacing8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              border: Border.all(
                                color: AppTheme.border,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radius12,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedRefresh,
                                  size: 16,
                                  color: AppTheme.textPrimary,
                                ),
                                const Gap(AppTheme.spacing6),
                                Text(
                                  'retry'.tr,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: AppTypography.semiBold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing16,
                      vertical: AppTheme.spacing8,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: AppTheme.spacing12,
                          crossAxisSpacing: AppTheme.spacing12,
                          childAspectRatio: 0.72,
                        ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return _GridCard<T>(
                        label: widget.labelOf(item),
                        icon: widget.iconOf?.call(item),
                        isSelected: _isSelected(item),
                        useFallbackIcon: widget.useFallbackIcon,
                        onTap: () => widget.onSelected(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Internal card widget ─────────────────────────────────────────────────────

class _GridCard<T> extends StatelessWidget {
  final String label;
  final String? icon;
  final bool isSelected;
  final bool useFallbackIcon;
  final VoidCallback onTap;

  const _GridCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.useFallbackIcon = false,
  });

  bool get _hasIcon => icon != null && icon!.isNotEmpty;

  /// True when the card should always render an image area (real icon or SVG fallback)
  /// and keep the label below — applies to brand step only.
  bool get _showImageLayout => _hasIcon || useFallbackIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(AppTheme.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.white,
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.border,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radius12),
              ),
              child: Stack(
                children: [
                  // Content: image, fallback SVG, or label-inside-box
                  Positioned.fill(
                    child: _showImageLayout
                        ? (_hasIcon
                              ? AppCachedImage(
                                  imageUrl: icon,
                                  fit: BoxFit.contain,
                                  errorWidget: SvgPicture.asset(
                                    'assets/svg/car_card_ics.svg',
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : SvgPicture.asset(
                                  'assets/svg/car_card_ics.svg',
                                  fit: BoxFit.contain,
                                ))
                        : Center(
                            child: Text(
                              label,
                              style: AppTypography.caption.copyWith(
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.textPrimary,
                                fontWeight: AppTypography.semiBold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ),
                  // Selection checkmark
                  if (isSelected)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        'assets/svg/verified.svg',
                        width: 14,
                        height: 14,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Label below box — only when image layout is active
          if (_showImageLayout) ...[
            const SizedBox(height: AppTheme.spacing4),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                fontWeight: AppTypography.semiBold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Skeleton loader ──────────────────────────────────────────────────────────

class _VehicleGridSkeleton extends StatelessWidget {
  final bool useFallbackIcon;

  const _VehicleGridSkeleton({this.useFallbackIcon = false});

  Widget _row() {
    return Row(
      children: List.generate(4, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : AppTheme.spacing8),
            child: Column(
              children: [
                ShimmerBox(
                  width: double.infinity,
                  height: 72,
                  borderRadius: BorderRadius.circular(AppTheme.radius12),
                ),
                const SizedBox(height: 6),
                ShimmerBox(
                  width: 36,
                  height: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing16,
        AppTheme.spacing12,
        AppTheme.spacing16,
        AppTheme.spacing24,
      ),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _row(),
        const SizedBox(height: AppTheme.spacing20),
        _row(),
        const SizedBox(height: AppTheme.spacing20),
        Opacity(opacity: 0.45, child: _row()),
      ],
    );
  }
}
