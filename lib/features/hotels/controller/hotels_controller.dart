import 'package:get/get.dart';
import 'package:traveler_app/features/hotels/model/hotel_model.dart';
import 'package:traveler_app/features/hotels/service/hotels_service.dart';

class HotelsController extends GetxController {
  final HotelsService _service;

  HotelsController({required HotelsService service}) : _service = service;

  final hotels = <HotelListItem>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedSort = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      final result = await _service.getHotels(
        query: searchQuery.value.isEmpty ? null : searchQuery.value,
        sort: selectedSort.value,
      );
      hotels.value = result;
    } finally {
      isLoading.value = false;
    }
  }

  void search(String q) {
    searchQuery.value = q;
    fetch();
  }

  void clearFilters() {
    selectedSort.value = null;
    searchQuery.value = '';
    fetch();
  }
}
