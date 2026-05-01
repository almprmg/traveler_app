import 'dart:convert';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:get/get.dart';

class HomeService extends GetxService {
  final ApiClient apiClient;

  HomeService({required this.apiClient});

  Future<HomeModel?> getHomeData() async {
    final response = await apiClient.getData(AppConstants.homeUrl);
    if (response.statusCode == 200) {
      return HomeModel.fromJson(json.decode(response.body));
    }
    return null;
  }
}
