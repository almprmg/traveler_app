import 'package:get/get.dart';
import 'package:traveler_app/features/destinations/model/destination_model.dart';
import 'package:traveler_app/features/destinations/service/destinations_service.dart';

class DestinationsController extends GetxController {
  final DestinationsService _service;
  DestinationsController({required DestinationsService service})
      : _service = service;

  final destinations = <DestinationListItem>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      destinations.value = await _service.getDestinations(
        query: searchQuery.value.isEmpty ? null : searchQuery.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void search(String q) {
    searchQuery.value = q;
    fetch();
  }
}

class DestinationDetailController extends GetxController {
  final DestinationsService _service;
  DestinationDetailController({required DestinationsService service})
      : _service = service;

  final destination = Rxn<DestinationDetail>();
  final isLoading = true.obs;
  String get slug => Get.arguments?['slug'] ?? '';

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      destination.value = await _service.getDestinationDetail(slug);
    } finally {
      isLoading.value = false;
    }
  }
}
