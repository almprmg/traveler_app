import 'package:get/get.dart';
import 'package:traveler_app/features/tours/model/tour_model.dart';
import 'package:traveler_app/features/tours/service/tours_service.dart';

class TourDetailController extends GetxController {
  final ToursService _service;

  TourDetailController({required ToursService service}) : _service = service;

  final tour = Rxn<TourDetail>();
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
      tour.value = await _service.getTourDetail(slug);
    } finally {
      isLoading.value = false;
    }
  }
}
