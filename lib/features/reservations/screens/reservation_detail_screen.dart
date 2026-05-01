import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/reservations/model/reservation_model.dart';
import 'package:traveler_app/features/reservations/service/reservations_service.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class ReservationDetailScreen extends StatefulWidget {
  const ReservationDetailScreen({super.key});

  @override
  State<ReservationDetailScreen> createState() =>
      _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  ReservationDetail? _detail;
  bool _isLoading = true;
  bool _isCancelling = false;

  String get _id => (Get.arguments as Map?)?['id'] ?? '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _isLoading = true);
    _detail =
        await Get.find<ReservationsService>().getBookingDetail(_id);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _cancel() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('cancel_booking'.tr),
        content: Text('cancel_booking_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'confirm'.tr,
              style: const TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() => _isCancelling = true);
    final success =
        await Get.find<ReservationsService>().cancelBooking(_id);
    if (success) {
      Get.back();
    }
    if (mounted) setState(() => _isCancelling = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('booking_detail'.tr)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _detail == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text('failed_to_load'.tr),
                      TextButton(
                          onPressed: _fetch, child: Text('retry'.tr)),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoCard([
                        _row('booking_number'.tr, '#${_detail!.bookingNumber}'),
                        _row('status'.tr, _detail!.status,
                            valueColor: _statusColor(_detail!.status)),
                        _row('product_type'.tr, _detail!.productType),
                        _row('product_name'.tr, _detail!.productName),
                      ]),
                      const SizedBox(height: 16),
                      _infoCard([
                        _row('booking_date'.tr, _detail!.bookingDate),
                        if (_detail!.startDate != null)
                          _row('start_date'.tr, _detail!.startDate!),
                        if (_detail!.endDate != null)
                          _row('end_date'.tr, _detail!.endDate!),
                        _row('adults'.tr, '${_detail!.adults}'),
                        _row('children'.tr, '${_detail!.children}'),
                      ]),
                      const SizedBox(height: 16),
                      _infoCard([
                        _row('contact_name'.tr, _detail!.contactName),
                        _row('contact_phone'.tr, _detail!.contactPhone),
                        _row('contact_email'.tr, _detail!.contactEmail),
                      ]),
                      const SizedBox(height: 16),
                      _infoCard([
                        if (_detail!.paymentMethod != null)
                          _row('payment_method'.tr, _detail!.paymentMethod!),
                        if (_detail!.paymentStatus != null)
                          _row('payment_status'.tr, _detail!.paymentStatus!),
                        _moneyRow('total_amount'.tr, _detail!.totalAmount),
                      ]),
                      if (_detail!.notes != null &&
                          _detail!.notes!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text('notes'.tr,
                            style: AppTypography.h5),
                        const SizedBox(height: 8),
                        Text(_detail!.notes!,
                            style: AppTypography.bodyMedium.copyWith(
                                color: AppTheme.textSecondary)),
                      ],
                      if (_detail!.status.toLowerCase() == 'pending' ||
                          _detail!.status.toLowerCase() == 'confirmed') ...[
                        const SizedBox(height: 24),
                        AppButton(
                          text: 'cancel_booking'.tr,
                          onPressed: _isCancelling ? null : _cancel,
                          isLoading: _isCancelling,
                          type: ButtonType.danger,
                          width: double.infinity,
                        ),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _infoCard(List<Widget> rows) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: rows
            .expand((w) => [w, const Divider(height: 16)])
            .toList()
          ..removeLast(),
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    Color? valueColor,
    bool bold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTypography.bodySmall
                .copyWith(color: AppTheme.textTertiary),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.bodyMedium.copyWith(
              color: valueColor ?? AppTheme.textPrimary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _moneyRow(String label, double amount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(label,
              style:
                  AppTypography.bodySmall.copyWith(color: AppTheme.textTertiary)),
        ),
        MoneyWithIcon(
          money: amount,
          precision: 2,
          textSize: 14,
          fontWeight: FontWeight.w700,
          color: AppTheme.primary,
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        return AppTheme.success;
      case 'cancelled':
        return AppTheme.error;
      default:
        return AppTheme.warning;
    }
  }
}
