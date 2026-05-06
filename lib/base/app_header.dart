import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/circle_icon_button.dart';
import 'package:traveler_app/controllers/localization_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

/// Project-wide app header used as `Scaffold.appBar`.
///
/// Same chrome as [ShoppingHeader] (back button on the leading side, optional
/// title centered, custom action buttons on the trailing side) but generic —
/// actions are supplied per-screen as [CircleIconButton]s.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final VoidCallback? onBackTap;
  final List<Widget> actions;
  final Widget? leading;
  final Color backgroundColor;

  const AppHeader({
    super.key,
    this.title,
    this.showBack = true,
    this.onBackTap,
    this.actions = const [],
    this.leading,
    this.backgroundColor = AppTheme.white,
  });

  static const double _circleSize = 38;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final isLtr = Get.find<LocalizationController>().isLtr;
    final hasTitle = title != null && title!.isNotEmpty;
    final resolvedLeading =
        leading ??
        (showBack
            ? CircleIconButton(
                icon: isLtr
                    ? HugeIcons.strokeRoundedArrowLeft01
                    : HugeIcons.strokeRoundedArrowRight01,
                onTap: onBackTap ?? () => Get.back(),
              )
            : null);

    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      titleSpacing: 0,
      centerTitle: true,
      leading: resolvedLeading != null
          ? Padding(
              padding: const EdgeInsetsDirectional.only(
                start: AppTheme.spacing16,
              ),
              child: resolvedLeading,
            )
          : null,
      leadingWidth: resolvedLeading != null
          ? _circleSize + AppTheme.spacing16
          : 0,
      title: hasTitle
          ? Text(
              title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.h5.copyWith(
                fontFamily: AppTheme.fontFamily,
                color: AppTheme.textPrimary,
                fontWeight: AppTypography.semiBold,
              ),
            )
          : null,
      actions: [
        for (final action in actions) ...[action, const Gap(AppTheme.spacing8)],
        const Gap(AppTheme.spacing8),
      ],
    );
  }
}
