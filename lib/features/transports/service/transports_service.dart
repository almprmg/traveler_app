import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/transports/model/transport_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class TransportsService extends GetxService {
  final ApiClient apiClient;
  TransportsService({required this.apiClient});

  Future<List<TransportListItem>> getTransports({
    String? query,
    String? destinationId,
    String? type,
    int page = 1,
  }) async {
    final params = <String, String>{'page': page.toString()};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (destinationId != null) params['destination_id'] = destinationId;
    if (type != null) params['type'] = type;

    final uri = Uri.parse(AppConstants.transportsUrl)
        .replace(queryParameters: params)
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] as Map<String, dynamic>? ?? {};
      final list = data['items'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(TransportListItem.fromJson)
          .toList();
    }
    return [];
  }

  Future<TransportDetail?> getTransportDetail(String slug) async {
    final response =
        await apiClient.getData(AppConstants.transportDetailUrl(slug));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return TransportDetail.fromJson(body['data'] ?? body);
    }
    return null;
  }
}
