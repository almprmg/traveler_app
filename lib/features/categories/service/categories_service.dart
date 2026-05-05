import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/categories/model/category_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class CategoriesService extends GetxService {
  final ApiClient apiClient;
  CategoriesService({required this.apiClient});

  Future<CategoriesGroup?> getCategories({String type = 'tour'}) async {
    final uri = Uri.parse(AppConstants.categoriesUrl)
        .replace(queryParameters: {'type': type})
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return CategoriesGroup.fromJson(body['data'] ?? body);
    }
    return null;
  }
}
