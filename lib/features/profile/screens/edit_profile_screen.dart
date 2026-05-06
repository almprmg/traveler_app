import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/features/profile/controller/profile_controller.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:hugeicons/hugeicons.dart';

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

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(_isSetup ? 'complete_profile'.tr : 'edit_profile'.tr),
        automaticallyImplyLeading: !_isSetup,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isSetup) ...[
                Text(
                  'complete_profile_subtitle'.tr,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'name_label'.tr,
                  prefixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedUser),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'name_required'.tr : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'email_label'.tr,
                  prefixIcon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedMail01,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'email_required'.tr;
                  if (!GetUtils.isEmail(v)) return 'email_invalid'.tr;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'phone_label'.tr,
                  prefixIcon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedSmartPhone01,
                  ),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'phone_required'.tr : null,
              ),
              const SizedBox(height: 32),
              Obx(
                () => ElevatedButton(
                  onPressed: c.isLoading.value
                      ? null
                      : () async {
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
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: c.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('save'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
