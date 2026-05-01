import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/base/app_text_field.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _balance = 0;
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _isLoading = true);
    final response =
        await Get.find<ApiClient>().getData(AppConstants.walletUrl);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] ?? {};
      _balance = (data['balance'] as num?)?.toDouble() ?? 0;
    }
    final txResponse =
        await Get.find<ApiClient>().getData(AppConstants.walletTransactionsUrl);
    if (txResponse.statusCode == 200) {
      final body = json.decode(txResponse.body);
      final list = body['data'] as List? ?? [];
      _transactions = list.cast<Map<String, dynamic>>();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _showDepositSheet() {
    final amountCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('deposit'.tr,
                style: AppTypography.h4),
            const SizedBox(height: 16),
            AppTextField(
              controller: amountCtrl,
              labelText: 'amount'.tr,
              hintText: 'enter_amount'.tr,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.attach_money, size: 20),
            ),
            const SizedBox(height: 20),
            AppButton(
              text: 'deposit'.tr,
              onPressed: () async {
                final amount =
                    double.tryParse(amountCtrl.text.trim()) ?? 0;
                if (amount <= 0) return;
                Get.back();
                await Get.find<ApiClient>().postData(
                  AppConstants.walletDepositUrl,
                  {'amount': amount},
                );
                _fetch();
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('wallet'.tr)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetch,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radius16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'wallet_balance'.tr,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppTheme.white.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          MoneyWithIcon(
                            money: _balance,
                            precision: 2,
                            textSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.white,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      text: 'deposit'.tr,
                      onPressed: _showDepositSheet,
                      icon: Icons.add,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 24),
                    Text('transactions'.tr, style: AppTypography.h4),
                    const SizedBox(height: 12),
                    if (_transactions.isEmpty)
                      EmptyState(onRefresh: _fetch)
                    else
                      ...List.generate(_transactions.length, (i) {
                        final tx = _transactions[i];
                        final amount =
                            (tx['amount'] as num?)?.toDouble() ?? 0;
                        final isCredit = tx['type'] == 'credit' ||
                            (tx['type'] == null && amount > 0);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radius12),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isCredit
                                      ? AppTheme.successWithOpacity
                                      : AppTheme.errorWithOpacity,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isCredit
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: isCredit
                                      ? AppTheme.success
                                      : AppTheme.error,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx['description'] ??
                                          (isCredit ? 'credit'.tr : 'debit'.tr),
                                      style: AppTypography.bodyMedium,
                                    ),
                                    Text(
                                      tx['created_at'] ?? '',
                                      style: AppTypography.bodySmall.copyWith(
                                          color: AppTheme.textTertiary),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isCredit ? '+' : '-',
                                    style: AppTypography.labelLarge.copyWith(
                                      color: isCredit
                                          ? AppTheme.success
                                          : AppTheme.error,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  MoneyWithIcon(
                                    money: amount.abs(),
                                    precision: 2,
                                    textSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isCredit
                                        ? AppTheme.success
                                        : AppTheme.error,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
    );
  }
}
