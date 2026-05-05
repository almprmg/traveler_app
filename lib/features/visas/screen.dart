import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/features/visas/controller/visas_controller.dart';
import 'package:traveler_app/features/visas/widgets/visa_card.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';

class VisasScreen extends StatefulWidget {
  const VisasScreen({super.key});

  @override
  State<VisasScreen> createState() => _VisasScreenState();
}

class _VisasScreenState extends State<VisasScreen> {
  late final VisasController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.find<VisasController>();
    _c.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('tab_visa'.tr)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: _c.search,
              decoration: InputDecoration(
                hintText: 'search_hint'.tr,
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedSearch01,
                    color: AppTheme.textTertiary,
                    size: 20,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_c.visas.isEmpty) {
                return EmptyState(onRefresh: _c.fetch);
              }
              return RefreshIndicator(
                onRefresh: _c.fetch,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  itemCount: _c.visas.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => VisaCard(
                    visa: _c.visas[i],
                    onTap: () => Get.toNamed(
                      visaDetailRoute,
                      arguments: {'slug': _c.visas[i].slug},
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
