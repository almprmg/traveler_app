import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/destinations/model/destination_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class DestinationsService extends GetxService {
  final ApiClient apiClient;
  DestinationsService({required this.apiClient});

  Future<List<DestinationListItem>> getDestinations({
    String? query,
    int page = 1,
  }) async {
    final params = <String, String>{'page': page.toString()};
    if (query != null && query.isNotEmpty) params['q'] = query;
    final uri = Uri.parse(AppConstants.destinationsUrl)
        .replace(queryParameters: params)
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] as Map<String, dynamic>? ?? {};
      final list = data['items'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(DestinationListItem.fromJson)
          .toList();
    }
    return [];
  }

  Future<DestinationDetail?> getDestinationDetail(String slug) async {
    final response =
        await apiClient.getData(AppConstants.destinationDetailUrl(slug));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return DestinationDetail.fromJson(body['data'] ?? body);
    }
    return null;
  }
}
