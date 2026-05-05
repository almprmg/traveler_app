import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/payments/screens/payment_methods_sheet.dart';
import 'package:traveler_app/features/wallet/controller/wallet_controller.dart';
import 'package:traveler_app/features/wallet/model/wallet_model.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late final WalletController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.find<WalletController>();
    _c.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('wallet'.tr)),
      body: Obx(() {
        if (_c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: _c.fetch,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _BalanceCard(balance: _c.balance.value),
                const SizedBox(height: 16),
                AppButton(
                  text: 'top_up'.tr,
                  onPressed: _showDepositSheet,
                  widgetIcon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedPlusSign,
                    color: AppTheme.white,
                    size: 18,
                  ),
                  width: double.infinity,
                ),
                const SizedBox(height: 24),
                Text('transactions'.tr, style: AppTypography.h4),
                const SizedBox(height: 12),
                if (_c.transactions.isEmpty)
                  EmptyState(onRefresh: _c.fetch)
                else
                  ..._c.transactions.map(
                    (tx) => _TransactionTile(tx: tx),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> _showDepositSheet() async {
    final amount = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _DepositAmountSheet(),
    );
    if (amount == null || amount <= 0) return;
    if (!mounted) return;

    final method = await showPaymentMethodsSheet(context);
    if (method == null) return;

    final init = await _c.initiateDeposit(
      amount: amount,
      methodKey: method.key,
    );
    if (init == null) {
      Get.snackbar(
        'wallet'.tr,
        'top_up_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final result = await Get.toNamed(
      paymentWebViewRoute,
      arguments: {'url': init.paymentUrl},
    );
    if (result == 'success') {
      _c.fetch();
      Get.snackbar(
        'wallet'.tr,
        'top_up_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class _BalanceCard extends StatelessWidget {
  final WalletBalance? balance;
  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radius20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radius12),
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedWallet01,
                  color: AppTheme.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'wallet_balance'.tr,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppTheme.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MoneyWithIcon(
            money: balance?.balance ?? 0,
            precision: 2,
            textSize: 32,
            fontWeight: FontWeight.w800,
            color: AppTheme.white,
          ),
          if (balance != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: 'total_deposited'.tr,
                    value: balance!.totalDeposited,
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: AppTheme.white.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _MiniStat(
                    label: 'total_spent'.tr,
                    value: balance!.totalSpent,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final double value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppTheme.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          MoneyWithIcon(
            money: value,
            precision: 0,
            textSize: 14,
            color: AppTheme.white,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final WalletTransaction tx;
  const _TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isCredit = tx.isCredit;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.cardBorder, width: 1),
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
            child: HugeIcon(
              icon: isCredit
                  ? HugeIcons.strokeRoundedArrowDown01
                  : HugeIcons.strokeRoundedArrowUp01,
              color: isCredit ? AppTheme.success : AppTheme.error,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.details ?? (isCredit ? 'credit'.tr : 'debit'.tr),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(tx.createdAt),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isCredit ? '+' : '-',
                    style: AppTypography.labelLarge.copyWith(
                      color: isCredit ? AppTheme.success : AppTheme.error,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 2),
                  MoneyWithIcon(
                    money: tx.amount.abs(),
                    precision: 2,
                    textSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isCredit ? AppTheme.success : AppTheme.error,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                tx.status,
                style: AppTypography.labelSmall.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String s) {
    if (s.isEmpty) return '';
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(s));
    } catch (_) {
      return s;
    }
  }
}

class _DepositAmountSheet extends StatefulWidget {
  const _DepositAmountSheet();

  @override
  State<_DepositAmountSheet> createState() => _DepositAmountSheetState();
}

class _DepositAmountSheetState extends State<_DepositAmountSheet> {
  final _ctrl = TextEditingController();
  final _quickAmounts = const [50.0, 100.0, 200.0, 500.0, 1000.0];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
              Text('top_up'.tr, style: AppTypography.h4),
              const SizedBox(height: 16),
              TextField(
                controller: _ctrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'enter_amount'.tr,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedDollar01,
                      color: AppTheme.textTertiary,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickAmounts.map((a) {
                  return ChoiceChip(
                    label: Text(a.toStringAsFixed(0)),
                    selected: false,
                    onSelected: (_) {
                      _ctrl.text = a.toStringAsFixed(0);
                      setState(() {});
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final v = double.tryParse(_ctrl.text.trim());
                  if (v == null || v <= 0) return;
                  Navigator.of(context).pop(v);
                },
                child: Text('continue'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
