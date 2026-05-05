import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/payments/model/payment_method_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class PaymentsService extends GetxService {
  final ApiClient apiClient;
  PaymentsService({required this.apiClient});

  Future<List<PaymentMethod>> getMethods() async {
    final response = await apiClient.getData(AppConstants.paymentMethodsUrl);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final raw = body['data'];
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(PaymentMethod.fromJson)
            .toList();
      }
    }
    return [];
  }

  Future<PaymentInitiation?> initiate({
    required String orderId,
    required String methodKey,
  }) async {
    final response = await apiClient.postData(AppConstants.initiatePaymentUrl, {
      'order_id': int.tryParse(orderId) ?? orderId,
      'method_key': methodKey,
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = json.decode(response.body);
      return PaymentInitiation.fromJson(body['data'] ?? body);
    }
    return null;
  }
}
