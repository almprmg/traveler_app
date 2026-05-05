import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/controllers/auth_controller.dart';
import 'package:traveler_app/features/profile/controller/profile_controller.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _pickAvatar(
      BuildContext context, ProfileController c) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const HugeIcon(
                icon: HugeIcons.strokeRoundedCamera01,
                color: AppTheme.primary,
                size: 22,
              ),
              title: Text('take_photo'.tr),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const HugeIcon(
                icon: HugeIcons.strokeRoundedImage02,
                color: AppTheme.primary,
                size: 22,
              ),
              title: Text('choose_from_gallery'.tr),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      imageQuality: 85,
    );
    if (picked == null) return;
    final ok = await c.uploadAvatar(File(picked.path));
    if (!ok) {
      Get.snackbar('profile'.tr, 'avatar_upload_failed'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, ProfileController c, AuthController auth) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('delete_account'.tr),
        content: Text('delete_account_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'confirm'.tr,
              style: const TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final ok = await c.deleteAccount();
    if (ok) {
      await auth.logout();
      Get.offAllNamed(loginRoute);
    } else {
      Get.snackbar('profile'.tr, 'delete_account_failed'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

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
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedEdit02),
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
                const HugeIcon(icon: HugeIcons.strokeRoundedUser, size: 64, color: Colors.grey),
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
                      Stack(
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
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _pickAvatar(context, c),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppTheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.fromBorderSide(BorderSide(
                                      color: AppTheme.white, width: 2)),
                                ),
                                child: Obx(() => c.isUploadingAvatar.value
                                    ? const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppTheme.white,
                                        ),
                                      )
                                    : const HugeIcon(
                                        icon: HugeIcons.strokeRoundedCamera01,
                                        color: AppTheme.white,
                                        size: 14,
                                      )),
                              ),
                            ),
                          ),
                        ],
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
                  icon: HugeIcons.strokeRoundedSmartPhone01,
                  title: 'phone_label'.tr,
                  value: p?.phone ?? '',
                ),
                _tile(
                  icon: HugeIcons.strokeRoundedFavourite,
                  title: 'wishlist'.tr,
                  onTap: () => Get.toNamed(wishlistRoute),
                  trailing: const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01),
                ),
                _tile(
                  icon: HugeIcons.strokeRoundedWallet01,
                  title: 'wallet'.tr,
                  onTap: () => Get.toNamed(walletRoute),
                  trailing: const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01),
                ),
                _tile(
                  icon: HugeIcons.strokeRoundedClock01,
                  title: 'reservations'.tr,
                  onTap: () => Get.toNamed(reservationsRoute),
                  trailing: const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01),
                ),
                _tile(
                  icon: HugeIcons.strokeRoundedSmartPhone01,
                  title: 'esim'.tr,
                  onTap: () => Get.toNamed(esimRoute),
                  trailing: const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01),
                ),
                const SizedBox(height: 12),
                _tile(
                  icon: HugeIcons.strokeRoundedLogout01,
                  title: 'logout'.tr,
                  iconColor: AppTheme.error,
                  titleColor: AppTheme.error,
                  onTap: () async {
                    await auth.logout();
                    Get.offAllNamed(loginRoute);
                  },
                ),
                _tile(
                  icon: HugeIcons.strokeRoundedDelete02,
                  title: 'delete_account'.tr,
                  iconColor: AppTheme.error,
                  titleColor: AppTheme.error,
                  onTap: () => _confirmDelete(context, c, auth),
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
    required List<List<dynamic>> icon,
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
        border: Border.all(color: AppTheme.cardBorder, width: 1),
      ),
      child: ListTile(
        leading: HugeIcon(icon: icon, color: iconColor ?? AppTheme.primary),
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
