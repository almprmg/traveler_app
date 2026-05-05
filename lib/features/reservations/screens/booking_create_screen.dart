import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/payments/screens/payment_methods_sheet.dart';
import 'package:traveler_app/features/reservations/controller/booking_create_controller.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class BookingCreateScreen extends StatelessWidget {
  const BookingCreateScreen({super.key});

  String _fmt(DateTime d) => DateFormat('dd MMM yyyy').format(d);

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BookingCreateController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('booking_detail'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(c.productTitle.value, style: AppTypography.h3),
            const SizedBox(height: 16),
            _section(
              title: 'travel_dates'.tr,
              children: [
                Obx(() => _PickerTile(
                      icon: HugeIcons.strokeRoundedCalendarCheckIn02,
                      label: 'start_date'.tr,
                      value: c.startDate.value == null
                          ? 'select_date'.tr
                          : _fmt(c.startDate.value!),
                      onTap: () async {
                        final now = DateTime.now();
                        final v = await showDatePicker(
                          context: context,
                          initialDate: c.startDate.value ?? now,
                          firstDate: now,
                          lastDate: DateTime(now.year + 2),
                        );
                        if (v != null) c.startDate.value = v;
                      },
                    )),
                const SizedBox(height: 8),
                Obx(() => _PickerTile(
                      icon: HugeIcons.strokeRoundedCalendarCheckOut02,
                      label: 'end_date'.tr,
                      value: c.endDate.value == null
                          ? 'optional'.tr
                          : _fmt(c.endDate.value!),
                      onTap: () async {
                        final start = c.startDate.value ?? DateTime.now();
                        final v = await showDatePicker(
                          context: context,
                          initialDate:
                              c.endDate.value ?? start.add(const Duration(days: 1)),
                          firstDate: start,
                          lastDate: DateTime(start.year + 2),
                        );
                        if (v != null) c.endDate.value = v;
                      },
                    )),
              ],
            ),
            const SizedBox(height: 16),
            _section(
              title: 'travelers'.tr,
              children: [
                Obx(() => _CounterTile(
                      label: 'adults'.tr,
                      icon: HugeIcons.strokeRoundedUser,
                      value: c.adultQty.value,
                      min: 1,
                      onChanged: (v) => c.adultQty.value = v,
                    )),
                const SizedBox(height: 8),
                Obx(() => _CounterTile(
                      label: 'children'.tr,
                      icon: HugeIcons.strokeRoundedUserCircle,
                      value: c.childQty.value,
                      min: 0,
                      onChanged: (v) => c.childQty.value = v,
                    )),
              ],
            ),
            const SizedBox(height: 16),
            _section(
              title: 'contact_details'.tr,
              children: [
                _Field(
                  label: 'name_label'.tr,
                  hint: 'name_hint'.tr,
                  onChanged: (v) => c.firstName.value = v,
                ),
                _Field(
                  label: 'last_name_label'.tr,
                  hint: 'last_name_hint'.tr,
                  onChanged: (v) => c.lastName.value = v,
                ),
                _Field(
                  label: 'phone_label'.tr,
                  hint: 'phone_hint'.tr,
                  keyboard: TextInputType.phone,
                  onChanged: (v) => c.phone.value = v,
                ),
                _Field(
                  label: 'email_label'.tr,
                  hint: 'email_hint'.tr,
                  keyboard: TextInputType.emailAddress,
                  onChanged: (v) => c.email.value = v,
                ),
                _Field(
                  label: 'address'.tr,
                  hint: 'address_hint'.tr,
                  onChanged: (v) => c.address.value = v,
                ),
                _Field(
                  label: 'notes'.tr,
                  hint: 'multiline_hint'.tr,
                  maxLines: 3,
                  onChanged: (v) => c.notes.value = v,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (c.lastError.value == null) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppTheme.errorWithOpacity,
                  borderRadius: BorderRadius.circular(AppTheme.radius12),
                ),
                child: Text(
                  c.lastError.value!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppTheme.error,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: AppTheme.white,
              border: const Border(
                top: BorderSide(color: AppTheme.border, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'total_amount'.tr,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                    ),
                    MoneyWithIcon(
                      money: c.total,
                      precision: 0,
                      textSize: 18,
                      color: AppTheme.primary,
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: c.isSubmitting.value
                      ? null
                      : () => _checkout(context, c),
                  icon: c.isSubmitting.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.white,
                          ),
                        )
                      : const HugeIcon(
                          icon: HugeIcons.strokeRoundedShoppingBag01,
                          color: AppTheme.white,
                          size: 18,
                        ),
                  label: Text('confirm_pay'.tr),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> _checkout(
      BuildContext context, BookingCreateController c) async {
    final method = await showPaymentMethodsSheet(context);
    if (method == null) return;
    final orderId = await c.submit();
    if (orderId == null) return;
    final init = await c.startPayment(orderId, method.key);
    if (init == null) {
      Get.snackbar(
        'payment'.tr,
        'payment_init_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final result = await Get.toNamed(
      paymentWebViewRoute,
      arguments: {'url': init.paymentUrl},
    );
    if (result == 'success') {
      Get.offAllNamed(
        reservationDetailRoute,
        arguments: {'id': orderId},
      );
    } else if (result == 'failure') {
      Get.snackbar('payment'.tr, 'payment_failed'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius16),
        border: Border.all(color: AppTheme.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              style: AppTypography.h5.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(AppTheme.radius12),
        ),
        child: Row(
          children: [
            HugeIcon(icon: icon, color: AppTheme.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label,
                      style: AppTypography.labelSmall.copyWith(
                          color: AppTheme.textTertiary)),
                  const SizedBox(height: 2),
                  Text(value,
                      style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowDown01,
              color: AppTheme.textTertiary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterTile extends StatelessWidget {
  final String label;
  final List<List<dynamic>> icon;
  final int value;
  final int min;
  final ValueChanged<int> onChanged;
  const _CounterTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.min,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppTheme.radius12),
      ),
      child: Row(
        children: [
          HugeIcon(icon: icon, color: AppTheme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600)),
          ),
          _CounterButton(
            icon: HugeIcons.strokeRoundedMinusSign,
            onTap: value > min ? () => onChanged(value - 1) : null,
          ),
          const SizedBox(width: 8),
          Text('$value', style: AppTypography.bodyLarge),
          const SizedBox(width: 8),
          _CounterButton(
            icon: HugeIcons.strokeRoundedPlusSign,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final List<List<dynamic>> icon;
  final VoidCallback? onTap;
  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? AppTheme.primary : AppTheme.border,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: HugeIcon(icon: icon, color: AppTheme.white, size: 16),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextInputType? keyboard;
  final int maxLines;
  final ValueChanged<String> onChanged;
  const _Field({
    required this.label,
    required this.hint,
    required this.onChanged,
    this.keyboard,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTypography.labelMedium.copyWith(
                color: AppTheme.textSecondary,
              )),
          const SizedBox(height: 4),
          TextField(
            keyboardType: keyboard,
            maxLines: maxLines,
            onChanged: onChanged,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}
