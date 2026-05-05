import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/esim/controller/esim_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class EsimOrdersScreen extends StatefulWidget {
  const EsimOrdersScreen({super.key});

  @override
  State<EsimOrdersScreen> createState() => _EsimOrdersScreenState();
}

class _EsimOrdersScreenState extends State<EsimOrdersScreen> {
  late final EsimOrdersController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.find<EsimOrdersController>();
    _c.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('esim_orders'.tr)),
      body: Obx(() {
        if (_c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_c.orders.isEmpty) return EmptyState(onRefresh: _c.fetch);
        return RefreshIndicator(
          onRefresh: _c.fetch,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _c.orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final o = _c.orders[i];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(AppTheme.radius16),
                  border: Border.all(color: AppTheme.cardBorder, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedSmartPhone01,
                          color: AppTheme.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            o.packageTitle,
                            style: AppTypography.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        _StatusChip(
                          text: o.paymentStatus,
                          isOk:
                              o.paymentStatus.toLowerCase() == 'paid',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('#${o.orderNumber}',
                            style: AppTypography.labelSmall.copyWith(
                                color: AppTheme.textTertiary)),
                        const SizedBox(width: 12),
                        Text(o.createdAt,
                            style: AppTypography.labelSmall.copyWith(
                                color: AppTheme.textTertiary)),
                        const Spacer(),
                        MoneyWithIcon(
                          money: o.totalAmount,
                          precision: 2,
                          textSize: 14,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final bool isOk;
  const _StatusChip({required this.text, required this.isOk});

  @override
  Widget build(BuildContext context) {
    final c = isOk ? AppTheme.success : AppTheme.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: c,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
