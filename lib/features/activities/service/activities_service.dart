import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/activities/model/activity_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class ActivitiesService extends GetxService {
  final ApiClient apiClient;

  ActivitiesService({required this.apiClient});

  Future<List<ActivityListItem>> getActivities({
    String? query,
    String? destinationId,
    String? sort,
    int page = 1,
  }) async {
    final params = <String, String>{'page': page.toString()};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (destinationId != null) params['destination_id'] = destinationId;
    if (sort != null) params['sort'] = sort;

    final uri = Uri.parse(AppConstants.activitiesUrl)
        .replace(queryParameters: params)
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] as Map<String, dynamic>? ?? {};
      final list = data['items'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(ActivityListItem.fromJson)
          .toList();
    }
    return [];
  }

  Future<ActivityDetail?> getActivityDetail(String slug) async {
    final response =
        await apiClient.getData(AppConstants.activityDetailUrl(slug));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return ActivityDetail.fromJson(body['data'] ?? body);
    }
    return null;
  }
}
