import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/visas/model/visa_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class VisasService extends GetxService {
  final ApiClient apiClient;
  VisasService({required this.apiClient});

  Future<List<VisaListItem>> getVisas({
    String? query,
    String? country,
    String? category,
    String? mode,
    int page = 1,
  }) async {
    final params = <String, String>{'page': page.toString()};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (country != null) params['country'] = country;
    if (category != null) params['category'] = category;
    if (mode != null) params['visa_mode'] = mode;

    final uri = Uri.parse(AppConstants.visasUrl)
        .replace(queryParameters: params)
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] as Map<String, dynamic>? ?? {};
      final list = data['items'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(VisaListItem.fromJson)
          .toList();
    }
    return [];
  }

  Future<VisaDetail?> getVisaDetail(String slug) async {
    final response = await apiClient.getData(AppConstants.visaDetailUrl(slug));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return VisaDetail.fromJson(body['data'] ?? body);
    }
    return null;
  }
}
