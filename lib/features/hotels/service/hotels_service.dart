import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/hotels/model/hotel_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class HotelsService extends GetxService {
  final ApiClient apiClient;

  HotelsService({required this.apiClient});

  Future<List<HotelListItem>> getHotels({
    String? query,
    String? countryId,
    String? cityId,
    String? sort,
    int page = 1,
  }) async {
    final params = <String, String>{'page': page.toString()};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (countryId != null) params['country_id'] = countryId;
    if (cityId != null) params['city_id'] = cityId;
    if (sort != null) params['sort'] = sort;

    final uri = Uri.parse(AppConstants.hotelsUrl)
        .replace(queryParameters: params)
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] as Map<String, dynamic>? ?? {};
      final list = data['items'] as List? ?? [];
      return list.map((e) => HotelListItem.fromJson(e)).toList();
    }
    return [];
  }

  Future<HotelDetail?> getHotelDetail(String slug) async {
    final response =
        await apiClient.getData(AppConstants.hotelDetailUrl(slug));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return HotelDetail.fromJson(body['data'] ?? body);
    }
    return null;
  }
}
