import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/esim/controller/esim_controller.dart';
import 'package:traveler_app/features/esim/model/esim_model.dart';
import 'package:traveler_app/features/payments/screens/payment_methods_sheet.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class EsimPackagesScreen extends StatefulWidget {
  const EsimPackagesScreen({super.key});

  @override
  State<EsimPackagesScreen> createState() => _EsimPackagesScreenState();
}

class _EsimPackagesScreenState extends State<EsimPackagesScreen> {
  late final EsimPackagesController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.find<EsimPackagesController>();
  }

  @override
  Widget build(BuildContext context) {
    final args = (Get.arguments as Map?) ?? const {};
    final title = args['name']?.toString() ?? 'esim_packages'.tr;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Obx(() => FilterChip(
                      label: Text('esim_unlimited'.tr),
                      selected: _c.unlimitedOnly.value,
                      onSelected: (v) {
                        _c.unlimitedOnly.value = v;
                        _c.fetch();
                      },
                    )),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_c.packages.isEmpty) {
                return EmptyState(onRefresh: _c.fetch);
              }
              return RefreshIndicator(
                onRefresh: _c.fetch,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _c.packages.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _PackageCard(
                    pkg: _c.packages[i],
                    onCheckout: () => _checkout(_c.packages[i]),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _checkout(EsimPackage pkg) async {
    final method = await showPaymentMethodsSheet(context);
    if (method == null) return;
    final ctrl = Get.find<EsimCheckoutController>();
    final result = await ctrl.checkout(
      packageId: pkg.id,
      methodKey: method.key,
    );
    if (result == null) {
      Get.snackbar('esim'.tr, 'esim_checkout_failed'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final paymentResult = await Get.toNamed(
      paymentWebViewRoute,
      arguments: {'url': result.paymentIframe},
    );
    if (paymentResult == 'success') {
      Get.offAllNamed(esimOrdersRoute);
    } else if (paymentResult == 'failure') {
      Get.snackbar('payment'.tr, 'payment_failed'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

class _PackageCard extends StatelessWidget {
  final EsimPackage pkg;
  final VoidCallback onCheckout;
  const _PackageCard({required this.pkg, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryWithOpacity,
                  borderRadius: BorderRadius.circular(AppTheme.radius12),
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedSmartPhone01,
                  color: AppTheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pkg.title,
                      style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      children: [
                        if (pkg.data != null)
                          _Chip(text: pkg.data!),
                        if (pkg.days != null)
                          _Chip(text: '${pkg.days} ${'esim_days'.tr}'),
                        if (pkg.isUnlimited)
                          _Chip(
                            text: 'esim_unlimited'.tr,
                            color: AppTheme.success,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              MoneyWithIcon(
                money: pkg.price,
                precision: 2,
                textSize: 18,
                color: AppTheme.primary,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onCheckout,
                child: Text('esim_buy'.tr),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color? color;
  const _Chip({required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primary;
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
