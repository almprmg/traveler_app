import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/features/transports/controller/transports_controller.dart';
import 'package:traveler_app/features/transports/widgets/transport_card.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';

class TransportsScreen extends StatefulWidget {
  const TransportsScreen({super.key});

  @override
  State<TransportsScreen> createState() => _TransportsScreenState();
}

class _TransportsScreenState extends State<TransportsScreen> {
  late final TransportsController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.find<TransportsController>();
    _c.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('tab_transport'.tr)),
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
              if (_c.transports.isEmpty) {
                return EmptyState(onRefresh: _c.fetch);
              }
              return RefreshIndicator(
                onRefresh: _c.fetch,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  itemCount: _c.transports.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => TransportCard(
                    transport: _c.transports[i],
                    onTap: () => Get.toNamed(
                      transportDetailRoute,
                      arguments: {'slug': _c.transports[i].slug},
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
