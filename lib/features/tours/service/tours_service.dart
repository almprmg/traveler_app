import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/tours/model/tour_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class ToursService extends GetxService {
  final ApiClient apiClient;

  ToursService({required this.apiClient});

  Future<List<TourListItem>> getTours({
    String? query,
    String? categoryId,
    String? destinationId,
    String? sort,
    int page = 1,
  }) async {
    final params = <String, String>{'page': page.toString()};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (categoryId != null) params['category_id'] = categoryId;
    if (destinationId != null) params['destination_id'] = destinationId;
    if (sort != null) params['sort'] = sort;

    final uri = Uri.parse(AppConstants.toursUrl)
        .replace(queryParameters: params)
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] as Map<String, dynamic>? ?? {};
      final list = data['items'] as List? ?? [];
      return list.map((e) => TourListItem.fromJson(e)).toList();
    }
    return [];
  }

  Future<TourDetail?> getTourDetail(String slug) async {
    final response =
        await apiClient.getData(AppConstants.tourDetailUrl(slug));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return TourDetail.fromJson(body['data'] ?? body);
    }
    return null;
  }
}
