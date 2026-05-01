import 'package:traveler_app/data/api/api_client.dart';
import 'package:get/get.dart';

class ProfileService extends GetxService {
  final ApiClient apiClient;

  ProfileService({required this.apiClient});
}
