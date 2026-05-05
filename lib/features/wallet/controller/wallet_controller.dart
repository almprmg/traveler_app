import 'package:get/get.dart';
import 'package:traveler_app/features/payments/model/payment_method_model.dart';
import 'package:traveler_app/features/payments/service/payments_service.dart';
import 'package:traveler_app/features/wallet/model/wallet_model.dart';
import 'package:traveler_app/features/wallet/service/wallet_service.dart';

class WalletController extends GetxController {
  final WalletService _service;
  final PaymentsService _payments;
  WalletController({
    required WalletService service,
    required PaymentsService payments,
  })  : _service = service,
        _payments = payments;

  final balance = Rxn<WalletBalance>();
  final transactions = <WalletTransaction>[].obs;
  final isLoading = false.obs;
  final isDepositing = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      balance.value = await _service.getBalance();
      transactions.value = await _service.getTransactions();
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<PaymentMethod>> getMethods() => _payments.getMethods();

  Future<WalletDepositInitiation?> initiateDeposit({
    required double amount,
    required String methodKey,
  }) async {
    isDepositing.value = true;
    try {
      return await _service.initiateDeposit(
        amount: amount,
        methodKey: methodKey,
      );
    } finally {
      isDepositing.value = false;
    }
  }
}
