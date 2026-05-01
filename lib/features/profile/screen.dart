import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/controllers/auth_controller.dart';
import 'package:traveler_app/features/profile/controller/profile_controller.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('profile'.tr),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Get.toNamed(editProfileRoute),
          ),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!auth.isLoggedIn()) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text('login_to_view_profile'.tr,
                    style: const TextStyle(color: AppTheme.textSecondary)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.toNamed(loginRoute),
                  child: Text('login'.tr),
                ),
              ],
            ),
          );
        }

        final p = c.profile.value;
        return RefreshIndicator(
          onRefresh: c.fetchProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: const BoxDecoration(
                    color: AppTheme.white,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppTheme.primaryWithOpacity,
                        child: p?.avatar != null
                            ? ClipOval(
                                child: AppCachedImage(
                                  imageUrl: p!.avatar!,
                                  width: 88,
                                  height: 88,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                p?.name.isNotEmpty == true
                                    ? p!.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        p?.name ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p?.email ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _tile(
                  icon: Icons.phone_outlined,
                  title: 'phone_label'.tr,
                  value: p?.phone ?? '',
                ),
                _tile(
                  icon: Icons.favorite_border,
                  title: 'wishlist'.tr,
                  onTap: () => Get.toNamed(wishlistRoute),
                  trailing: const Icon(Icons.chevron_right),
                ),
                _tile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'wallet'.tr,
                  onTap: () => Get.toNamed(walletRoute),
                  trailing: const Icon(Icons.chevron_right),
                ),
                _tile(
                  icon: Icons.history_outlined,
                  title: 'reservations'.tr,
                  onTap: () => Get.toNamed(reservationsRoute),
                  trailing: const Icon(Icons.chevron_right),
                ),
                const SizedBox(height: 12),
                _tile(
                  icon: Icons.logout,
                  title: 'logout'.tr,
                  iconColor: AppTheme.error,
                  titleColor: AppTheme.error,
                  onTap: () async {
                    await auth.logout();
                    Get.offAllNamed(loginRoute);
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    String? value,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? AppTheme.primary),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: titleColor ?? AppTheme.textPrimary,
          ),
        ),
        subtitle: value != null && value.isNotEmpty ? Text(value) : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
