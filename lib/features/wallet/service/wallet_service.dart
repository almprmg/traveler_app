import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/wallet/model/wallet_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class WalletService extends GetxService {
  final ApiClient apiClient;
  WalletService({required this.apiClient});

  Future<WalletBalance?> getBalance() async {
    final response = await apiClient.getData(AppConstants.walletUrl);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return WalletBalance.fromJson(body['data'] ?? body);
    }
    return null;
  }

  Future<List<WalletTransaction>> getTransactions({
    String? type,
    int page = 1,
  }) async {
    final params = <String, String>{'page': page.toString()};
    if (type != null) params['type'] = type;
    final uri = Uri.parse(AppConstants.walletTransactionsUrl)
        .replace(queryParameters: params)
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'];
      List? raw;
      if (data is Map && data['items'] is List) raw = data['items'] as List;
      if (data is List) raw = data;
      return (raw ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(WalletTransaction.fromJson)
          .toList();
    }
    return [];
  }

  Future<List<WalletTransaction>> getDeposits({int page = 1}) async {
    final uri = Uri.parse('${AppConstants.walletDepositUrl}s')
        .replace(queryParameters: {'page': page.toString()})
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'];
      List? raw;
      if (data is Map && data['items'] is List) raw = data['items'] as List;
      if (data is List) raw = data;
      return (raw ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(WalletTransaction.fromJson)
          .toList();
    }
    return [];
  }

  Future<WalletDepositInitiation?> initiateDeposit({
    required double amount,
    required String methodKey,
  }) async {
    final response = await apiClient.postData(
      '${AppConstants.walletDepositUrl}/initiate',
      {'amount': amount, 'method_key': methodKey},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = json.decode(response.body);
      return WalletDepositInitiation.fromJson(body['data'] ?? body);
    }
    return null;
  }
}
