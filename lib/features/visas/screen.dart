import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_header.dart';
import 'package:traveler_app/base/circle_icon_button.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/features/visas/controller/visas_controller.dart';
import 'package:traveler_app/features/visas/widgets/visa_card.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/widgets/app_search_field.dart';
import 'package:traveler_app/widgets/filter_bottom_sheet.dart';
import 'package:traveler_app/widgets/search_forms.dart';

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

  void _openFilter() {
    showFilterBottomSheet(
      context,
      form: VisaSearchForm(
        onSearch: (_) {
          Navigator.of(context).pop();
          _c.fetch();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppHeader(
        title: 'tab_visa'.tr,
        actions: [
          CircleIconButton(
            icon: HugeIcons.strokeRoundedFilterHorizontal,
            onTap: _openFilter,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacing16,
              AppTheme.spacing12,
              AppTheme.spacing16,
              AppTheme.spacing8,
            ),
            child: AppSearchField(onChanged: _c.search),
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
                    horizontal: AppTheme.spacing16,
                    vertical: AppTheme.spacing8,
                  ),
                  itemCount: _c.visas.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppTheme.spacing12),
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
