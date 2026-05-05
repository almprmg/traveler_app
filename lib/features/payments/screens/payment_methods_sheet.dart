import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/features/payments/model/payment_method_model.dart';
import 'package:traveler_app/features/payments/service/payments_service.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

Future<PaymentMethod?> showPaymentMethodsSheet(BuildContext context) async {
  return showModalBottomSheet<PaymentMethod>(
    context: context,
    backgroundColor: AppTheme.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _PaymentMethodsBody(),
  );
}

class _PaymentMethodsBody extends StatefulWidget {
  const _PaymentMethodsBody();

  @override
  State<_PaymentMethodsBody> createState() => _PaymentMethodsBodyState();
}

class _PaymentMethodsBodyState extends State<_PaymentMethodsBody> {
  late Future<List<PaymentMethod>> _future;

  @override
  void initState() {
    super.initState();
    _future = Get.find<PaymentsService>().getMethods();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppTheme.borderMedium,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('select_payment_method'.tr, style: AppTypography.h4),
            const SizedBox(height: 12),
            FutureBuilder<List<PaymentMethod>>(
              future: _future,
              builder: (_, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final list = snap.data ?? [];
                if (list.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('no_payment_methods'.tr,
                        style: AppTypography.bodyMedium),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: list.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, color: AppTheme.border),
                  itemBuilder: (_, i) {
                    final m = list[i];
                    return ListTile(
                      leading: m.iconUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: AppCachedImage(
                                imageUrl: m.iconUrl!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                              ),
                            )
                          : const HugeIcon(
                              icon: HugeIcons.strokeRoundedCreditCard,
                              color: AppTheme.primary,
                              size: 28,
                            ),
                      title: Text(m.displayName,
                          style: AppTypography.bodyLarge),
                      trailing: const HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowRight01,
                        color: AppTheme.textTertiary,
                        size: 18,
                      ),
                      onTap: () => Navigator.of(context).pop(m),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
