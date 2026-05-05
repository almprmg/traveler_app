import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/packages/model/package_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class PackagesService extends GetxService {
  final ApiClient apiClient;
  PackagesService({required this.apiClient});

  Future<List<PackageListItem>> getPackages({
    String? query,
    String? sort,
    bool? featured,
    int page = 1,
  }) async {
    final params = <String, String>{'page': page.toString()};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (sort != null) params['sort'] = sort;
    if (featured == true) params['featured'] = '1';

    final uri = Uri.parse(AppConstants.packagesUrl)
        .replace(queryParameters: params)
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] as Map<String, dynamic>? ?? {};
      final list = data['items'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(PackageListItem.fromJson)
          .toList();
    }
    return [];
  }

  Future<PackageDetail?> getPackageDetail(String slug) async {
    final response =
        await apiClient.getData(AppConstants.packageDetailUrl(slug));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return PackageDetail.fromJson(body['data'] ?? body);
    }
    return null;
  }
}
