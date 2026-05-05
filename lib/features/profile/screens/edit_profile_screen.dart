import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/features/profile/controller/profile_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:hugeicons/hugeicons.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    final p = Get.find<ProfileController>().profile.value;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _phoneCtrl = TextEditingController(text: p?.phone ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('edit_profile'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'phone_label'.tr,
                  prefixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedSmartPhone01),
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
                            phone: _phoneCtrl.text.trim(),
                          );
                          if (!c.isLoading.value) Get.back();
                        },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52)),
                  child: c.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
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
