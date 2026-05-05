import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/controllers/auth_controller.dart';
import 'package:traveler_app/features/profile/controller/profile_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  String _greetingKey() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'good_morning';
    if (hour < 17) return 'good_afternoon';
    return 'good_evening';
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final isLoggedIn = auth.isLoggedIn();

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Row(
          children: [
            _Avatar(isLoggedIn: isLoggedIn),
            const SizedBox(width: 12),
            Expanded(
              child: isLoggedIn
                  ? GetBuilder<ProfileController>(
                      init: Get.isRegistered<ProfileController>()
                          ? Get.find<ProfileController>()
                          : null,
                      builder: (_) {
                        final c = Get.isRegistered<ProfileController>()
                            ? Get.find<ProfileController>()
                            : null;
                        return Obx(() {
                          final name = c?.profile.value?.name ?? '';
                          final firstName = name.split(' ').first.trim();
                          return _Greeting(
                            line1: _greetingKey().tr,
                            line2: firstName.isEmpty
                                ? 'ready_to_explore'.tr
                                : '$firstName 👋',
                          );
                        });
                      },
                    )
                  : _Greeting(
                      line1: _greetingKey().tr,
                      line2: 'ready_to_explore'.tr,
                    ),
            ),
            _CircleButton(
              icon: HugeIcons.strokeRoundedNotification01,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  final String line1;
  final String line2;
  const _Greeting({required this.line1, required this.line2});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          line1,
          style: AppTypography.bodySmall.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          line2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMedium.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final bool isLoggedIn;
  const _Avatar({required this.isLoggedIn});

  static const double _size = 56;
  static const String _placeholder = 'assets/images/profile_sumple_icon.webp';

  Widget _circle({required Widget child}) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _placeholderImage() {
    return Image.asset(
      _placeholder,
      width: _size,
      height: _size,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn || !Get.isRegistered<ProfileController>()) {
      return _circle(child: _placeholderImage());
    }

    return Obx(() {
      final avatar = Get.find<ProfileController>().profile.value?.avatar;
      if (avatar != null && avatar.isNotEmpty) {
        return _circle(
          child: AppCachedImage(imageUrl: avatar, fit: BoxFit.cover),
        );
      }
      return _circle(child: _placeholderImage());
    });
  }
}

class _CircleButton extends StatelessWidget {
  final List<List<dynamic>> icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.white.withValues(alpha: 0.6),
      shape: const CircleBorder(
        side: BorderSide(color: AppTheme.cardBorder, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: HugeIcon(icon: icon, color: AppTheme.textPrimary, size: 22),
        ),
      ),
    );
  }
}
