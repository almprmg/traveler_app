import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_bottom_sheet.dart';
import 'package:traveler_app/base/app_cash_image.dart';

import 'package:traveler_app/base/app_input.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:shimmer/shimmer.dart';

/// Global Dropdown Widget - Reusable dropdown with bottom sheet
class DropdownBottomSheet<T> extends StatelessWidget {
  final String title;
  final String hint;
  final T? selectedItem;
  final List<T> items;
  final String Function(T) itemLabel;
  final String Function(T) itemId;
  final String? Function(T)? itemImage; // New: Optional image URL getter
  final void Function(T) onItemSelected;
  final bool isLoading;
  final IconData? prefixIcon;
  final bool showSearch;
  final String? searchHint;
  final double? height;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final bool hideIfEmpty;
  final VoidCallback? onMenuOpen;
  final double imageSize; // New: Control image size
  final BoxFit imageFit; // New: Control how image fits
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final bool hasMore;
  final bool isPlain;
  final Widget? subtitle;
  // Optional radius override so callers like the tire-size finder can
  // render fully-rounded pills (999) while default callers keep the
  // standard 12-px corners.
  final double? borderRadius;

  const DropdownBottomSheet({
    super.key,
    required this.title,
    required this.hint,
    this.selectedItem,
    required this.items,
    required this.itemLabel,
    required this.itemId,
    this.itemImage, // New parameter
    required this.onItemSelected,
    this.isLoading = false,
    this.prefixIcon,
    this.showSearch = true,
    this.searchHint,
    this.height,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.hideIfEmpty = true,
    this.onMenuOpen,
    this.imageSize = 40, // Default image size
    this.imageFit = BoxFit.cover, // Default fit
    this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.isPlain = false,
    this.subtitle,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && selectedItem == null) {
      return Shimmer.fromColors(
        baseColor: AppTheme.shimmerBase,
        highlightColor: AppTheme.shimmerHighlight,
        child: Container(
          height: height ?? 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    if (hideIfEmpty && items.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () {
        if (onMenuOpen != null) onMenuOpen!();
        _showSelectionSheet(context);
      },
      child: isPlain
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefixIcon != null) ...[
                      Icon(
                        prefixIcon,
                        color: iconColor ?? AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      selectedItem != null
                          ? itemLabel(selectedItem as T)
                          : hint,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: textColor ?? AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 4),
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      color: iconColor ?? AppTheme.textPrimary,
                    ),
                  ],
                ),
                if (subtitle != null) subtitle!,
              ],
            )
          : Container(
              // Vertical padding matched to AppInput so dropdowns align
              // on the same baseline when sat next to each other.
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white,
                borderRadius: BorderRadius.circular(borderRadius ?? 12),
                border: Border.all(color: borderColor ?? AppTheme.border),
              ),
              child: Row(
                children: [
                  // Show image if available for selected item
                  if (itemImage != null &&
                      selectedItem != null &&
                      itemImage!(selectedItem as T) != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: _buildImage(
                        itemImage!(selectedItem as T)!,
                        imageSize,
                        imageFit,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ] else if (prefixIcon != null) ...[
                    Icon(
                      prefixIcon,
                      color: iconColor ?? AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      selectedItem != null
                          ? itemLabel(selectedItem as T)
                          : hint,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor ?? AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowDown01,
                    color: iconColor ?? AppTheme.textSecondary,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildImage(String imageUrl, double size, BoxFit fit) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: size,
        height: size,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorIcon(size),
      );
    }
    return AppCachedImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: fit,
    );
  }

  Widget _buildErrorIcon(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: HugeIcon(
        icon: HugeIcons.strokeRoundedImage01,
        size: size * 0.5,
        color: Colors.grey[400] ?? Colors.grey,
      ),
    );
  }

  void _showSelectionSheet(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final RxString searchText = ''.obs;

    AppBottomSheet.show(
      title: title,
      child: Column(
        children: [
          // Search Bar
          if (showSearch) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomInputField(
                controller: searchController,
                type: InputFieldType.search,
                hint: searchHint ?? 'search'.tr,
                fillColor: Colors.white,
                onChanged: (val) {
                  searchText.value = val;
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // List
          Expanded(
            child: Obx(() {
              List<T> currentItems;
              if (items is RxList<T>) {
                currentItems = (items as RxList<T>).toList();
              } else {
                currentItems = items;
              }

              final List<T> filteredList;
              if (searchText.value.isEmpty) {
                filteredList = currentItems;
              } else {
                filteredList = currentItems.where((item) {
                  return itemLabel(
                    item,
                  ).toLowerCase().contains(searchText.value.toLowerCase());
                }).toList();
              }

              if (filteredList.isEmpty) {
                return Center(
                  child: Text(
                    'no_results_found'.tr,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (onLoadMore != null &&
                      hasMore &&
                      !isLoadingMore &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200) {
                    onLoadMore!();
                  }
                  return false;
                },
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16,
                  ).copyWith(bottom: 50),
                  itemCount: filteredList.length + (isLoadingMore ? 1 : 0),
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppTheme.spacing8),
                  itemBuilder: (context, index) {
                    if (index == filteredList.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final item = filteredList[index];
                    final isSelected =
                        selectedItem != null &&
                        itemId(selectedItem as T) == itemId(item);
                    final imageUrl = itemImage?.call(item);

                    return InkWell(
                      onTap: () {
                        onItemSelected(item);
                        Get.back();
                      },
                      borderRadius: BorderRadius.circular(AppTheme.radius12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        // Compact rhythm: trims the legacy 16-px padding
                        // down to 12/10 so rows feel tighter and more
                        // options fit before the user has to scroll.
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primary.withValues(alpha: 0.05)
                              : AppTheme.white,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radius12,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primary.withValues(alpha: 0.35)
                                : AppTheme.border,
                            width: isSelected ? 1.0 : 0.75,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (imageUrl != null) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radius8,
                                ),
                                child: imageUrl.startsWith('assets/')
                                    ? Image.asset(
                                        imageUrl,
                                        width: 32,
                                        height: 32,
                                        fit: imageFit,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                _buildErrorIcon(32),
                                      )
                                    : Image.network(
                                        imageUrl,
                                        width: 32,
                                        height: 32,
                                        fit: imageFit,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                _buildErrorIcon(32),
                                      ),
                              ),
                              const SizedBox(width: AppTheme.spacing12),
                            ],
                            Expanded(
                              child: Text(
                                itemLabel(item),
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: isSelected
                                      ? AppTypography.semiBold
                                      : AppTypography.regular,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacing8),
                            // Radio indicator — same shape used by the
                            // delivery-options + view-mode sheets, so
                            // every selectable row in the project reads
                            // the same way.
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryLight
                                      : AppTheme.borderMedium,
                                  width: isSelected ? 5 : 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ============================================
// USAGE EXAMPLE
// ============================================

/*
// Example Model
class City {
  final String id;
  final String name;
  final String? imageUrl;

  City({
    required this.id,
    required this.name,
    this.imageUrl,
  });
}

// Usage
DropdownBottomSheet<City>(
  title: 'اختر المدينة',
  hint: 'اختر مدينة',
  selectedItem: controller.selectedCity,
  items: controller.cities,
  itemLabel: (city) => city.name,
  itemId: (city) => city.id,
  itemImage: (city) => city.imageUrl, // NEW: Add image getter
  onItemSelected: (city) {
    controller.onCitySelected(city);
  },
  imageSize: 50, // Optional: customize image size
  imageFit: BoxFit.cover, // Optional: customize image fit
  prefixIcon: Icons.location_city,
  showSearch: true,
)
*/
