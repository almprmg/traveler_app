import 'package:get/get.dart';
import 'package:traveler_app/features/hotels/model/hotel_model.dart';
import 'package:traveler_app/features/hotels/service/hotels_service.dart';

class HotelDetailController extends GetxController {
  final HotelsService _service;

  HotelDetailController({required HotelsService service}) : _service = service;

  final hotel = Rxn<HotelDetail>();
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
      hotel.value = await _service.getHotelDetail(slug);
    } finally {
      isLoading.value = false;
    }
  }
}
