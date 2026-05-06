import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/features/profile/controller/profile_controller.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  bool get _isSetup => (Get.arguments as Map?)?['setup'] == true;

  @override
  void initState() {
    super.initState();
    final p = Get.find<ProfileController>().profile.value;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _emailCtrl = TextEditingController(text: p?.email ?? '');
    _phoneCtrl = TextEditingController(text: p?.phone ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(ProfileController c) async {
    if (!_formKey.currentState!.validate()) return;
    await c.updateProfile(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );
    if (!c.isLoading.value) {
      if (_isSetup) {
        Get.offAllNamed(navRoute);
      } else {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();
    if (_isSetup) return _buildSetupMode(c);
    return _buildEditMode(c);
  }

  Widget _buildSetupMode(ProfileController c) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/sky_background.png',
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              bottom: false,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing24,
                    vertical: 80,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppTheme.white,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(AppTheme.spacing24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'complete_profile'.tr,
                                style: AppTypography.h2,
                                textAlign: TextAlign.center,
                              ),
                              const Gap(AppTheme.spacing8),
                              Text(
                                'complete_profile_subtitle'.tr,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Gap(AppTheme.spacing32),
                              _buildFields(),
                              const Gap(AppTheme.spacing24),
                              Obx(
                                () => AppButton(
                                  text: 'save'.tr,
                                  type: ButtonType.gradient,
                                  size: ButtonSize.medium,
                                  width: double.infinity,
                                  borderRadius: AppTheme.radiusPill,
                                  isLoading: c.isLoading.value,
                                  onPressed:
                                      c.isLoading.value
                                          ? null
                                          : () => _submit(c),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditMode(ProfileController c) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('edit_profile'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFields(),
              const Gap(AppTheme.spacing32),
              Obx(
                () => AppButton(
                  text: 'save'.tr,
                  type: ButtonType.gradient,
                  size: ButtonSize.large,
                  width: double.infinity,
                  borderRadius: AppTheme.radiusPill,
                  isLoading: c.isLoading.value,
                  onPressed: c.isLoading.value ? null : () => _submit(c),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'name_label'.tr,
            prefixIcon: const HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              size: 20,
              color: AppTheme.textSecondary,
            ),
          ),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'name_required'.tr : null,
        ),
        const Gap(AppTheme.spacing16),
        TextFormField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email_label'.tr,
            prefixIcon: const HugeIcon(
              icon: HugeIcons.strokeRoundedMail01,
              size: 20,
              color: AppTheme.textSecondary,
            ),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'email_required'.tr;
            if (!GetUtils.isEmail(v.trim())) return 'email_invalid'.tr;
            return null;
          },
        ),
        const Gap(AppTheme.spacing16),
        TextFormField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'phone_label'.tr,
            prefixIcon: const HugeIcon(
              icon: HugeIcons.strokeRoundedSmartPhone01,
              size: 20,
              color: AppTheme.textSecondary,
            ),
          ),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'phone_required'.tr : null,
        ),
      ],
    );
  }
}
