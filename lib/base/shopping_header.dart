import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/circle_icon_button.dart';
import 'package:traveler_app/controllers/auth_controller.dart';
import 'package:traveler_app/controllers/localization_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

/// App-bar used on shopping/browsing screens.
///
/// Renders a back button, the screen title, a search button, and a cart
/// button (with live item-count badge) — the same chrome used at the top of
/// the product-details page. Implements [PreferredSizeWidget] so it plugs
/// straight into `Scaffold.appBar`.
class ShoppingHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final VoidCallback? onBackTap;
  final bool showSearch;
  final bool showCart;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;

  const ShoppingHeader({
    super.key,
    this.title,
    this.showBack = true,
    this.onBackTap,
    this.showSearch = true,
    this.showCart = true,
    this.onSearchTap,
    this.onCartTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final isLtr = Get.find<LocalizationController>().isLtr;
    final hasTitle = title != null && title!.isNotEmpty;

    return AppBar(
      backgroundColor: AppTheme.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      titleSpacing: AppTheme.spacing16,
      title: Row(
        children: [
          if (showBack) ...[
            CircleIconButton(
              icon: isLtr
                  ? HugeIcons.strokeRoundedArrowLeft01
                  : HugeIcons.strokeRoundedArrowRight01,
              onTap: onBackTap ?? () => Get.back(),
            ),
            const Gap(AppTheme.spacing12),
          ],
          Expanded(
            child: hasTitle
                ? Text(
                    title!,
                    style: AppTypography.h5.copyWith(
                      fontFamily: AppTheme.fontFamily,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : const SizedBox.shrink(),
          ),
          if (showSearch) ...[
            const Gap(AppTheme.spacing8),
            CircleIconButton(
              icon: HugeIcons.strokeRoundedSearch01,
              onTap: onSearchTap ?? () => Get.toNamed('/search'),
            ),
          ],
          if (showCart) ...[
            const Gap(AppTheme.spacing8),
            _CartIconButton(onTap: onCartTap),
          ],
        ],
      ),
    );
  }
}

class _CartIconButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _CartIconButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return CircleIconButton(
      icon: HugeIcons.strokeRoundedShoppingCart01,
      onTap: onTap ??
          () {
            if (Get.find<AuthController>().isLoggedIn()) {
              Get.toNamed('/cart');
            } else {
              Get.toNamed('/login');
            }
          },
    );
  }
}
